#!/usr/bin/ksh
#Nom du script    : @(#) cg_vtom_stats
#--                     
#-- Description      : @(#) Generation du rapport quotidien des traitements 
#--                         VTOM depuis le jour ouvre precedent 18h00 jusqu'au
#--                         declenchement du script 
#--                     
#-- Date de creation : 15/12/2011 
#-- Auteur           : Ph.MARQUET
#--                    
#-- Utilisation      : appel
#--                      cg_vtom_stats 
#--                    parametres
#--                      date_deb_rapport : Date de debut du rapport a generer
#--                    
#-- Conception       : 
#--                    
#-- Remarques        : 
#--                    
#-----------------------------------------------------------------------------
#-- Liste de modifications
#
#-- Revision 2, faite le JJ/MM/YYYY par X. Yyyyyyy
#--  
#-----------------------------------------------------------------------------
#
#---------------------------------------------------------------------------------
# Recuperation variables communes (dont les noms de commandes) et fonctions.
#---------------------------------------------------------------------------------
#set -vx

cg_rep_prog_cg="/opt/cg/tools/bin"
cg_rep_prog_vtom="/opt/cg/vtom/bin"

. ${cg_rep_prog_cg}/cg_var_commun
. ${cg_rep_prog_cg}/cg_fonction
. ${cg_rep_prog_vtom}/cg_var_vtom

#Control des arguments
if [ $# -eq 0 ]
then
	echo "INFO : Ce script genere un rapport VTOM sur une periode donnee : "
	echo "USAGE : $0 date-debut (Format = JJ-MM-AAAA) date fin (Format = JJ-MM-AAAA)"
	echo "EXEMPLE : $0 16-02-2011 17-02-2011"
	exit 1
else
	DEB="$1 18:00:00"
	FIN="$2 `date '+%H:%m:%S'`"
	echo $FIN
fi

#################################################################
#DEFINITION DES VARIABLES
#################################################################

#Definition des fichiers support
FIC="/var/tmp/temp.xml"
FIC_W="/var/tmp/temp_w"
FIC_P="/var/tmp/temp_p"

#Generation du fichier en XML
vtexport -x > ${FIC}

#Generation du fichier de travail
vtstools -x -e "${DEB} ${FIN}" >> ${FIC_W}

#Liste JOBS EN-ERREUR
#_______________________________________________________________________________________________________________________________________
ERR_HEAD="<tr class=err><td align=center colspan=8><b>JOBS EN ERREUR</b></td></tr>"
LIB_ERR="<tr><td><b>Indice<b></td><td align=center><b>Environnement<b></td><td align=center><b>Appli${C_CAT}ion<b></td><td align=center><b>Traitement<b></td><td align=center><b>Date Exploitation<b></td><td align=center><b>Libelle Erreur<b></td><td align=center><b>Famille Libelle Job<b></td></tr>"
ERR=`${C_CAT} ${FIC_W} | ${C_GREP} -w EN-ERREUR | ${C_GREP} -v Env_prod_apps | ${C_GREP} -v DEPLANIFIE | ${C_NAWK} -F";" '{ print NR";"$1";"$2";"$3";"$13";"$20";"$6";"}' | ${C_SED} 's/ /;/g'`
CPT=0
for J in ${ERR}
do
	TEST=`echo ${J} | ${C_NAWK} -F";" '{ print $4 }'`	
	COMM=`${C_GREP} Job ${FIC} | ${C_GREP} ${TEST} | ${C_HEAD} -1 | ${C_NAWK} -F"=" '{ print  $4 }' | ${C_NAWK} -F"\"" '{ print $2 }'`
	INTER=`printf "${J}" | ${C_NAWK} -F";" '{ print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5" "$6"</td><td>"$7" "$8" "$9" "$NF"</td><td>"}'`
	echo "${INTER}${COMM}</td></tr>" >> ${FIC_P}
	CPT=$(($CPT+1))
done
NB_ERR=${CPT}
LIGNE=`${C_CAT} ${FIC_P}`

#Liste JOBS DEPLANIFIE
#_______________________________________________________________________________________________________________________________________
DEP_HEAD="<tr class=dep><td align=center colspan=7><b>JOBS DEPLANIFIES</b></td></tr>"
LIB_DEP="<tr><td><b>Indice<b></td><td align=center><b>Environnement<b></td><td align=center><b>Appli${C_CAT}ion<b></td><td align=center><b>Traitement<b></td><td align=center><b>Code Retour<b></td><td align=center><b>Libelle Deplanifi${C_CAT}ion<b></td></tr>"
DEP=`${C_CAT} ${FIC_W} | ${C_GREP} -w DEPLANIFIE | ${C_GREP} -v Env_prod_apps | ${C_GREP} -v DMD | ${C_NAWK} -F";" '{ print "<tr><td>"NR"</td><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$19"</td><td>"$20"</td></tr>"}'`

#Liste JOBS SIMULATION
#_______________________________________________________________________________________________________________________________________
SIM_HEAD="<tr class=sim><td align=center colspan=4><b>JOBS EN SIMULATION</b></td></tr>"
LIB_SIM="<tr><td><b>Indice<b></td><td align=center><b>Environnement<b></td><td align=center><b>Appli${C_CAT}ion<b></td><td align=center><b>Traitement<b></td></tr>"
SIM=`${C_TLIST} -v jobs_simulation | ${C_GREP} -v Env_Templates |  ${C_NAWK} '{ print "<tr><td>"NR"</td><td>"$1"</td><td>"$2"</td><td>"$3"</td></tr>" }'`

#Liste JOBS  ENCOURS
#_______________________________________________________________________________________________________________________________________
ENCOURS_HEAD="<tr class=enc><td align=center colspan=5><b>JOBS EN COURS</b></td></tr>"
LIB_ENCOURS="<tr><td><b>Indice<b></td><td align=center><b>Environnement<b></td><td align=center><b>Appli${C_CAT}ion<b></td><td align=center><b>Traitement<b></td><td align=center><b>Date/Heure de demarrage<b></td></tr>"
ENCOURS=`${C_TLIST} jobs_last_exec -s ec | ${C_NAWK} -F" " '{ print "<tr><td>"NR"</td><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$6" "$7"</td></tr>"}'`

#NB JOB Total
#_______________________________________________________________________________________________________________________________________
TOT=`${C_TLIST} -v jobs |wc -l` 

#NB JOBS / JOURNEE EXP
#_______________________________________________________________________________________________________________________________________
NB_JOBS=`${C_CAT} ${FIC_W} | ${C_GREP} -v NON-PLANIFIE | wc -l`
POURC=`echo "${NB_ERR}/${NB_JOBS}*100" | bc -l` 
VAL=`printf "%2.2f" ${POURC}` 
LIB_HEAD="<tr class=stat><td colspan=4 align=center><b>STATISTIQUES<b></td></tr>"
RECAP_HEAD="<tr><td><b>NOMBRE TRAITEMENTS<b></td><td><b>TRAITEMENTS JOURNEE EXPLOIT<b></td><td><b>NOMBRE TRAITEMENTS EN ERREUR<b></td><td><b>POURCENTAGE ERREUR<b></td></tr>"
RECAP="<tr class=statval><td>${TOT}</td><td>${NB_JOBS}</td><td>${NB_ERR}</td><td>${VAL}%</td></tr>"

#Liste DATE
#_______________________________________________________________________________________________________________________________________
DATE_J=`date '+%d-%m-%Y'`
LISTE_DATE=`${C_TLIST} -v dates | ${C_NAWK} '{ print $1 }'`
MESS_DATE="<tr class=exp><td align=center><b>DATE EXPLOITATION<b></td><td align=center><b>VALEUR<b></td></tr>
"
for I in ${LISTE_DATE}
do
        ID_DATE=`tgetdate /name=${I}`
		if [ ${ID_DATE} = ${DATE_J} ]
		then
			MESS_DATE="${MESS_DATE}
<tr><td>${I}</td><td>${ID_DATE}</td></tr>"
		else
			MESS_DATE="${MESS_DATE}
<tr><td><font color=red><b>${I}<b></font></td><td><font color=red><b>${ID_DATE}<b></font></td></tr>"
			RESULTTCHKDATE=`tchkdate /name=${I} | ${C_GREP} Env*`
                        MESS_DATE="${MESS_DATE}
<tr><td colspan=2><font color=red><b>${RESULTTCHKDATE}</b></font></td></tr>"
		fi	
done




#Etat des clients VTOM
ETAT_MACHINE=`${C_VTMACHINE} | ${C_GREP} "Can\'t connect" | ${C_NAWK} -F"|" '{ print "<tr><td>"$2"</td><td>"$4"</td></tr>"}` 
LIB_CLIENT="<tr class=client align=center><td colspan=2><b>CLIENT VTOM DOWN<b></font></td></tr>"
COL_CLIENT="<tr><td><b>Machine</b></td><td><b>@IP</b></td></tr>" 




#################################################################
#FIN DEFINITION DES VARIABLES
#################################################################

#_______________________________________________________________________________________________________________________________________

#################################################################
#MISE EN FORME TABLEAUX
#################################################################

STYLE="<style type=text/css> body { font-family: ARIAL; size: 10;} table { margin:30px; border-collapse: collapse; border-width: thin; border-style:solid; border-color:gray; border-spacing:0px; } td { border-width:thin; border-style:solid; border-spacing:0px; } tr.err { background-color:#FFCCCC; } tr.dep { background-color:#C0C0C0; } tr.sim { background-color:#FFFFCC; } tr.enc{ background-color:#66CCCC; } tr:hover {background-color:#FFFFFF;} tr.stat { background-color:#66FF99; } tr.statval { font-style:italic; } tr.client { background-color:#CC9933; } tr.exp { background-color:#FF99FF; }}</style>"
ENCODAGE="<meta http-equiv=Content-Type content=text/html; charset=UTF-8>"

#################################################################
#FIN MISE EN FORME TABLEAUX
#################################################################


#_______________________________________________________________________________________________________________________________________



MESSAGE="<HTML><HEAD>${ENCODAGE}${STYLE}</HEAD><BODY>"
MESSAGE="${MESSAGE}Compte-rendu des traitements VTOM du ${DEB} au ${FIN}"
MESSAGE="${MESSAGE}<table>${ENCOURS_HEAD}${LIB_ENCOURS}${ENCOURS}</table>"
MESSAGE="${MESSAGE}<table>${ERR_HEAD}${LIB_ERR}${LIGNE}</table>"
MESSAGE="${MESSAGE}<table>${LIB_HEAD}${RECAP_HEAD}${RECAP}</table>"
MESSAGE="${MESSAGE}<table>${DEP_HEAD}${LIB_DEP}${DEP}</table>"
MESSAGE="${MESSAGE}<table>${SIM_HEAD}${LIB_SIM}${SIM}</table>"
MESSAGE="${MESSAGE}<table>${MESS_DATE}</table>"
MESSAGE="${MESSAGE}<table>${LIB_CLIENT}${COL_CLIENT}${ETAT_MACHINE}</table>"
MESSAGE="${MESSAGE}</BODY></HTML>"


SUJET="Compte Rendu VTOM du ${DEB} au ${FIN}"
(
  echo "Subject: $SUJET"
  echo "MIME-Version: 1.0"
  echo "Content-Type: text/html"
  echo "Content-Disposition: inline"
  echo "${MESSAGE}"
) |  /usr/sbin/sendmail ${cgglo_liste_dest_expl} 
rm ${FIC_W} ${FIC_P}