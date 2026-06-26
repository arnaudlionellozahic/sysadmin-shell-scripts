#!/bin/sh
#
# Auteur        : PETITPRE (script modifié de BDSI/MEDIT)
# Date          : 08/10/2013
#
# Principe      : Extrait la conlog de la nuit pour donner
#               : - Les heures de fermeture/ouverture TP
#               : - Le nombre de mouvements
#               : - Le nombre d'abort total et specifiques
#               : - Le status des traitements suivis par le site
#               : Ces infos sont mises dans un .csv et envoyées aux gpmx
#
# Prerequis     : utilise perl pour generer la date J-1
#
# Fréquence     : lancé en crontab tous les jours même fériés
#
# Input en dur  : /apps/meoatlas2/outils/Rapport_GPMX/traitements_surveilles.lst
#		: Il donne la liste des jobsets dont le site veut connaitre l'etat le matin
#		: Il est composé d'une ligne par jobset, dans ce format :
#		: <label du jobset>:<nom du jobset>:<jour de surveillance (J ou J-1)> 
#
#
# Output        : /apps/meoatlas2/outils/Rapport_GPMX/rapport_gpmx.mail
#               : /apps/meoatlas2/outils/Rapport_GPMX/rapport_atlas.csv
# Outils        : perl
#
#************************************************************************

export LANG=C

# hostname et label du site :

site=parva4000633
label_site="REUNION"
SUFF="Reun"

# Preciser si le jtp1 du jour monte a l'autoscan du jour 
# car pour certains site il monte le matin pour etre execute apres FJ

export jtp1_autoscan=yes




# initialisation FERIE a no

export FERIE="no"

#-------------------------------------
# Definition de la date du jour
# Et des variables en rapport
#-------------------------------------

jfin=$(date +%d)
moisf=$(date +%b)
anneeF=$(date +%Y)
jour=$(date +%d/%m/%y)
jour2=$(date +%d-%m-%Y)
jour3=$(date | awk '{print $1}')
jour4=$(date +%d/%h/%Y)
vday=`date +%a`
A2_IMP=/apps/atlas/atlas2v0/uf1/data1/imp
A2_FIC=/apps/atlas/atlas2v0/uf1/data1/fic
export A2_IMP0=/apps/arch/imp-0

#-------------------------------------
# Definition de la date de la veille
# Et des variables en rapport
#-------------------------------------

# on aura besoin de perl. YESTERDAY donne la date de la veille en jj mm yyyy

export YESTERDAY=$(perl -e '($sec,$min,$hour,$mday,$mon,$year) = localtime(time - 86400);$year += 1900;$mon += 1;print "$mday $mon $year\n";')

jdeb=$(printf "%02.f\n" $(echo $YESTERDAY | awk '{print $1}' ))
moisd=$(printf "%02.f\n" $(echo $YESTERDAY | awk '{print $2}' ))
anneeD=$(printf "%02.f\n" $(echo $YESTERDAY | awk '{print $3}' ))
jtrait=${jdeb}0


# les chiffres sont écrits avec un 0 devant

#-------------------------------------
# Definition du qualifier de jtp1
#-------------------------------------


if [[ $jtp1_autoscan == yes ]]
then
qual_jtp1=${jfin}0
else
qual_jtp1=${jtrait} 
fi

#-------------------------------------
# Definition de la date du lendemain
# Et des variables en rapport
#-------------------------------------

# on aura besoin de perl. TOMORROW donne la date du lendemain en jj/mm/yyyy

export TOMORROW=$(perl -e '($sec,$min,$hour,$mday,$mon,$year) = localtime(time + 86400);$year += 1900;$mon += 1;print "$mday/$mon/$year\n";')


#-------------------------------------
# Definition des input/output
#-------------------------------------

# liste des jobsets surveillés avec leur label
export JOBSET_SURV_LIST=/apps/meoatlas2/outils/Rapport_GPMX/traitements_surveilles.lst

# fichier du mail
export MAIL_GPMX=/apps/meoatlas2/outils/Rapport_GPMX/rapport_gpmx.mail

# fichier .csv qui sera constitué et envoyé par mail
export EXCEL_GPMX=/apps/meoatlas2/outils/Rapport_GPMX/rapport_atlas.${label_site}.csv



#----------------------------------------
# Variables de repertoires de travail
#----------------------------------------

RESULT_RAP=/apps/meoatlas2/outils/Rapport_GPMX/logatlas
A2_IMP=/apps/atlas/atlas2v0/uf1/data1/imp
TMP=/apps/meoatlas2/outils/Rapport_GPMX/tmp
REP_STAT=/apps/meoatlas2/outils/Rapport_GPMX/stat
REP=/apps/meoatlas2/outils/Rapport_GPMX
REPLOG=/apps/meoatlas2/outils/Rapport_GPMX/log


#----------------------------------------------------------------------
# Exécution Sous-scripts d'initialisation d'environnements nécessaires
#----------------------------------------------------------------------

. /home/atlas/profile.cft 1>/dev/null 2>&1

if [ "$CAIGLBL0000" = '' ]
   then
      CAIGLBL0000=/apps/unicenter/EM/3.1
      export CAIGLBL0000
fi
. "$CAIGLBL0000/scripts/envusr"


#----------------------------------------------------
# reinitialisation du fichier d'extraction de conlog
#----------------------------------------------------

# ATTENTION !!!! Si le jour de lancement est Dimanche ou férié, on génère le rapport vers midi
# donc on extrait la conlog vers midi.
# Pour tester si ce jour est férié, on teste si le jtp2 va monter à l'autoscan
# Si il va tourner, c'est un jour ouvré
# Pour cela on lance un forecast TNG sur la date du jour


cautil sel conlog li | grep -i autoscan | grep $jour2 1>/dev/null 2>&1
if [[ $? -eq 0 ]]
then
# L'autoscan est passé : ce jour est férié si jtp2 n'est pas au tracking au qualifier d'aujourd'hui
echo "autoscan ok"
cautil li tjobset id=jtp2${SUFF} qualifier="${jfin}00" | grep jtp2 1>/dev/null 2>&1
else
# L'autoscan n'est pas passé. ce jour est férié si jtp2 est prévu au tracking aujourd'hui
echo "autoscan a venir"
$CAIGLBL0000/sche/scripts/schdfore JOBSET "*" $jour4 | grep "Jobset = jtp2" 1>/dev/null 2>&1
fi

if [[ $? -ne 0 ]]
then
# On est Dimanche ou férié
echo "JOUR FERIE"
export FERIE="yes"
#sleep 23400
fi

> $RESULT_RAP

cautil select conlog start=$jdeb-$moisd-$anneeD  list conlog | grep CASH_ | grep -v Purged | sort -u >> $RESULT_RAP  2> $TMP/ERR
cautil select conlog start=$jfin-$moisf-$anneeF  list conlog | grep CASH_ | grep -v Purged | sort -u >> $RESULT_RAP  2> $TMP/ERR

#-------------------------
# Comptage des aborts
#-------------------------

export NBTOTAB=0
export NBTOTABSPE=0

NBTOTAB=$(grep I_0062 $RESULT_RAP | grep $jtrait | grep -v "00:00:"|awk '{print $7}'|sort -u | wc -l  )

if [[ $NBTOTAB -ne 0 ]]
then
NBTOTABSPE=$(grep I_0062 $RESULT_RAP | grep $jtrait | grep -v "00:00:"| grep -E "ju|mu|du"|awk '{print $7}'|sort -u | wc -l)
fi

#-------------------------
# EXTRACTION NB DE MVTS
#-------------------------

export MEO_TMP=$TMP/cal_mvt_dts.tmp

# test si le jas9ar est deja passe
# dans ce cas le jasf31 doit etre cherché dans imp-0 et non imp
# de plus si on est Dimanche, on est sur que les logs sont dans imp-0


grep "jas9ar" ${RESULT_RAP}| grep "Qual ${qual_jtp1}1" 1>/dev/null 2>&1

if [[ $? -eq 0 ]]
then
# alors un jas9ar a tourné ou va tourner entre hier et aujourd'hui

export LAST_JAS9AR=$(grep -i jas9ar $RESULT_RAP| grep CASH_I_0054 | tail -1 | awk '{print $9}')

  if [[ $LAST_JAS9AR -eq ${qual_jtp1}1 ]]
  then
  # le jas9ar de la nuit est passe, les logs de la nuit sont dans imp-0
  cd $A2_IMP0
  else
  # le jas9ar n'est pas encore passe
  cd $A2_IMP
  fi




# extraction du nombre de mouvements a partir de la sysout du jasf31

CHK_MVT=$(ls -d JASF31*sys* |wc -l)
  if [[ $CHK_MVT -eq 1 ]] then
          cat JASF31*sys* > $MEO_TMP
          NB_MVT=$(sed s/^M// $MEO_TMP |grep HM06 |awk '{print $2}' |awk '{sum += $1} END {print sum}')
  else
          NB_MVT="ERR"
  fi
else
# pas de jas9ar, on a ce cas le Dimanche ou lorsqu'il y a des jours fériés consécutifs
NB_MVT="0, hier était férié"
fi

#----------------------------------------
# Détermination des heures de fermeture
# et d'ouverture TP
#----------------------------------------

# Fermeture

if (grep "jcics2" $RESULT_RAP | grep "jtp2${SUFF}" |grep $jtrait |grep ".CASH_I_0054" 1>/dev/null 2>&1)
then
FERM=$(grep "jcics2" $RESULT_RAP | grep jtp2 |grep $jtrait |grep ".CASH_I_0054" | tail -1|awk '{ print $12 }')
FERMF=$(echo ${FERM%.*} |tr '.' 'h')
elif (grep "jcics2" $RESULT_RAP | grep "jtp2${SUFF}" | grep ${jtrait}1 1>/dev/null 2>&1)
then
FERMF=$(echo "Non démarré")
# très peu probable, cela signifierait que le TP n'a pas fermé la veille
else
FERMF=$(echo "Pas de fermeture la veille")
fi

# Ouverture

if (grep "jcics1" $RESULT_RAP | grep "jtp1${SUFF}" |grep ${qual_jtp1}1 |grep ".CASH_I_0054" 1>/dev/null 2>&1)
then
OUV=$(grep "jcics1" $RESULT_RAP | grep "jtp1${SUFF}" | grep ${qual_jtp1}1 |grep ".CASH_I_0054" |head -1 | awk '{ print $12 }' )
OUVF=$(echo ${OUV%.*} |tr '.' 'h')
elif (grep "jcics1" $RESULT_RAP | grep "jtp1${SUFF}" | grep ${qual_jtp1}1 1>/dev/null 2>&1)
then
OUVF=$(echo "Ouverture TP du jour : KO")
else
OUVF=$(echo "N/A")
fi


#----------------------------------------------
# Remplissage du fichier .csv
#----------------------------------------------

# TP, mouvements et aborts

echo "Fermeture TP;${FERMF}
Ouverture TP;${OUVF}" > $EXCEL_GPMX

echo "Nombre de Mouvement;$NB_MVT
Nombre total d'aborts;$NBTOTAB
Nombre total d'aborts spécifiques;$NBTOTABSPE" >> $EXCEL_GPMX

# remplissage du .csv avec le status des traitements surveillés
# le nom du jobset n'apparait pas, mais le label oui
# les états possibles sont :
# Terminé, en cours, abort, en attente ou n/a si pas au tracking
# la variable jtrait donne les 3 1ers chiffres du qualifier recherché

line_counter=2
export nb_lines=$(cat $JOBSET_SURV_LIST | wc -l)
# ( la 1ere ligne du fichier est un commentaire )
while [[ $line_counter -le $nb_lines ]]
do
  export JOBSET_SURV=$(cat $JOBSET_SURV_LIST | sed -n ${line_counter}p|awk -F: '{print $2}')
  export LABEL=$(cat $JOBSET_SURV_LIST | sed -n ${line_counter}p|awk -F: '{print $1}')
  export QUALIFIER=$(cat $JOBSET_SURV_LIST | sed -n ${line_counter}p|awk -F: '{print $3}')

  # on determine si le jobset se lance avec le qualifier J (ouvertures TP par ex.) ou J-1 (batch)

  if [[ ${QUALIFIER} == J-1 ]]
  then
    export qual_jobset=${jtrait}
  elif [[ ${QUALIFIER} == J ]]
  then  
    export qual_jobset=${jfin}0
  else
    echo "Erreur de qualifier dans le fichier en entree pour le jobset ${JOBSET}: J ou J-1\n"
  fi

  # determination de l'etat du jobset pour remplir le rapport
  grep "${JOBSET_SURV} ${qual_jobset}" ${RESULT_RAP}  | grep CASH_I_0060 1>/dev/null 2>&1
  if [[ $? -eq 0 ]]
  then
    # le jobset est COMPL au tracking
    echo "${LABEL};TERMINE" >> $EXCEL_GPMX
  else
    grep "${JOBSET_SURV}" ${RESULT_RAP}| grep "Qual ${qual_jobset}0" 1>/dev/null 2>&1
    if [[ $? -eq 0 ]]
    then
      # le jobset est au tracking et non termine donc :
      # soit un ou plusieurs de ses jobs sont start
      # soit le jobset est en wpred ou wstart
      # soit un de ses jobs est en abort
      export JOBSET_STATUS=$(cautil li tjobset id=${JOBSET_SURV} qualifier=${qual_jobset}0 | grep Status: | awk '{print $3}')
      if [[ $JOBSET_STATUS != "START" ]]
      then
        # le jobset est WPRED ou OPHELD ou WSTART
        echo "${LABEL};NON DEMARRE" >> $EXCEL_GPMX
      else
        # le jobset est en start ou en abort
        cautil sel tjob id=${JOBSET_SURV},*,* li qualifier=${qual_jobset}1 | grep Status: | grep -v Cyc > jobs_status_${JOBSET_SURV}.tmp
        grep -i ABORT jobs_status_${JOBSET_SURV}.tmp 1>/dev/null 2>&1
        if [[ $? -eq 0 ]]
        then
          # il y a un job en abort
          echo "${LABEL};ABORT" >> $EXCEL_GPMX
        else
          # le jobset est en cours
          echo "${LABEL};EN COURS" >> $EXCEL_GPMX
        fi
      fi
    else
    # le jobset n'est pas au tracking (cas du Dimanche ou férié)
    echo "${LABEL};N/A" >> $EXCEL_GPMX
    fi

  fi
let line_counter=line_counter+1
done

#-------------------------------------------------------------
# Constitution et envoie du mail avec le .csv en pièce jointe
#-------------------------------------------------------------


echo "Subject:Morning Report Atlas $label_site
To: thomas.petitpre@externe.bnpparibas.com


" > $MAIL_GPMX

echo "Bonjour,

Voici le rapport technique de la nuit pour Atlas ${label_site} :" >> $MAIL_GPMX

uuencode $EXCEL_GPMX $EXCEL_GPMX >> $MAIL_GPMX

echo "\n\nCordialement\nMeo IRB\n" >> $MAIL_GPMX

sendmail -f meo_atlas_paris -t < $MAIL_GPMX

