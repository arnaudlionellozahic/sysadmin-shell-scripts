#!/bin/ksh
#-------------------------------------------------------------------
#Diverses initialisations de variables obligatoires
#-------------------------------------------------------------------

#Date passee en argument par CONTROLM
ODATE=${1}
[ "X${ODATE}" = "X" ] && echo "Parm ODATE non specifie" && exit 1

ctrlmExports ${0}
switch ${GEHLOG} > /dev/null


#-------------------------------------------------------------------
#Chargement des variables d'environnement
#-------------------------------------------------------------------
_GENERAL_ENV="${GEDAA}/etc/`echo ${GEIENV} | tr "PXG" "pxg"`v/env.ksh"
_LOCAL_ENV="${GEDAACC}/etc/env.ksh"
[ -a ${_GENERAL_ENV} ] && . ${_GENERAL_ENV}
[ -a ${_LOCAL_ENV} ] && . ${_LOCAL_ENV}
#-------------------------------------------------------------------
#Initialisation des variables n'ayant pas a etre modifiees
#-------------------------------------------------------------------
_P_DATE=`date +"%y%m%d_%H%M%S"`
_CODE=0

#-------------------------------------------------------------------
#Initialisation des variables specifiques au job
#-------------------------------------------------------------------
DATA=$APP_DIR/pm/travaux/ftp2
FTPOUT=$REP_SYSOUT/$JOB.FTP
RR_FTP_USER=$PROXY_USER@$FTP_FI_USER@$FTP_FI_SERVEUR@$PROXY_EXT
RR_FTP_PASSWD=$PROXY_PASSWORD@$FTP_FI_PASSWORD 

#override de tmp pour la marche en double
TMP=$APP_DIR/pm/travaux/tmp2

LISTE_FTP_FITCH=Notation_ftp_FI.txt
LISTE_INTEG_FITCH=Notation_integ_FI.txt



# Exec PS
fonc_execproc ()
{

echo   "*---------------------------------------------------*"
echo   "*  Construction de la liste des fichiers Fitch's     "
echo   "*---------------------------------------------------*"
>$ISQL_OUT

isql -S$SERVER -U$USER -P$PASS -s" " <<EOF 1> $ISQL_OUT 2>&1

use $BASE
go

Set nocount on
Set proc_return_status off
go 		

Declare @syb_err Int,		
		@syb_lib VarChar(255)		

EXECUTE $1  @syb_err OUTPUT, @syb_lib OUTPUT
Select "RET_SYB :",@syb_err
Select "LIB_SYB :",@syb_lib

go
EOF

CODE=$?
if [ $CODE -ne 0 ]
then
  echo "Code retour $CODE <> zero sur la PS $1"  
  cat $ISQL_OUT
  exit 254
fi


egrep "Msg|error" $ISQL_OUT 2>/dev/null
if [ $? -eq 0 ]
then
	echo "ERREUR detectee par grep sur trace du fichier de sortie."
	cat $ISQL_OUT
	exit 254
fi

RET_SYB=`cat $ISQL_OUT | grep "RET_SYB" | \
 sed s/" "//g | $path_awk/awk -F":" '{print $2 }'`
LIB_SYB=`cat $ISQL_OUT | grep "LIB_SYB" | \
 $path_awk/awk -F":" '{print $2 }'`

echo "Retour sybase = $RET_SYB $LIB_SYB"

if [ $RET_SYB -ne 0 ]
then
	echo "\nCode retour $RET_SYB $RET_SYB <> zero sur PS $1"
  	exit 254

else
 echo "\n*---------------*"
 echo   "*... Exec PS OK  "
 echo   "*---------------*"
fi
}


fonc_ftp_fic ()
{

echo "\n*--------------------------------------------------------*" 
echo   "* FTP des fichiers indiques dans $DATA/$LISTE_FTP_FITCH	  " 
echo   "*--------------------------------------------------------*" 

for LIGNE in `cat $DATA/$LISTE_FTP_FITCH`
do
	REPERTOIRE=`expr $LIGNE : '\(.*\)|'`
 	FICHIER=`expr $LIGNE : '.*|\(.*\)'`
 	echo "==> Recuperation du fichier $FICHIER dans le $REPERTOIRE"
    
	ftp -n $PROXY > $FTPOUT 2>&1 <<-EOT 
	  	

		user $RR_FTP_USER $RR_FTP_PASSWD
	  	pwd
	  	cd $REPERTOIRE
	  	pwd
	  	lcd $DATA	  	
	  	get $FICHIER
	  	quit
	EOT

	egrep "No such file or directory.|There is not enough space in the file system|Peer has closed connection|Login failed|must be connected to remote server|Content Security Server disconnected|Login failed|can't find list of remote files, oops" $FTPOUT 2>/dev/null

	if [ $? -eq 0 ]
	then
		echo " ===> ERREUR detectee par grep sur trace du ftp. On sort du shell sans erreur !!!"
	  	echo " ===> On envoie un mail d'alerte aux etudes !!!"
	  	echo " ===> Prevenir les etudes : GRP-dsi-etu-TRR !!!"
	  	cat $FTPOUT   

		 # Envoi d'un mail
                > $TMP/mail_job_ko.txt
            FIC_DEST_MAIL=$PARM/adresse_mail_tech.lst
            TITRE_MAIL="Batch RR : Perte de connexion par FTP vers le site Fitchratings"
            FIC_A_ENVOYER=$TMP/mail_job_ko.txt
            echo "Le Batch $JOB du `date +"%d/%m/%Y"` est KO :" >> $FIC_A_ENVOYER
            echo "A `date +"%Hh%M"`, perte de connexion par FTP vers Fitchrating's"  >> $FIC_A_ENVOYER

            ksh $PARM/env_mail.ksh "$TITRE_MAIL" $FIC_DEST_MAIL $FIC_A_ENVOYER


	  	exit 1
	fi
	sleep 30
done

echo "\n*---------------*"
echo   "*... FTP OK  	 " 
echo   "*---------------*"

}

fonc_verif_recup_ftp ()
{

	for LIGNE in `cat $DATA/$LISTE_FTP_FITCH`
	do	
	 	FICHIER=`expr $LIGNE : '.*|\(.*\)'`
	 	
	 	if [ -e $DATA/$FICHIER ]
	   	then
	      echo " Par rapport au contenu du fichier $LISTE_FTP_FITCH : "
	      echo " Le fichier $FICHIER est present dans le repertoire $DATA"
	  	else
	      echo " Par rapport au contenu du fichier $LISTE_FTP_FITCH : "
	      echo " Le fichier $FICHIER est absent dans le repertoire $DATA"
	      echo " ===> On envoie un mail d'alerte aux etudes !!! \n"
	      #DATE0=`cat $PARM/ctrlm.date`
	      #$XALERTE -c BATCHR4_FTP_ALERTE -m "Le Batch $JOB du `echo $DATE0 | cut -c 5-6`/`echo $DATE0 | cut -c 3-4`/20`echo $DATE0 | cut -c 1-2` est NOK : il manque $FICHIER de fitchratings dans le repertoire DATA a `date "+%H"`h`date "+%M"` " -t "**** Batch RR : Absence de fichiers de fitchratings dans le repertoire DATA ****" 
	   
              # Envoi d'un mail
              > $TMP/mail_job_ko.txt
              FIC_DEST_MAIL=$PARM/adresse_mail_tech.lst
              TITRE_MAIL="Batch RR : Absence de fichiers de fitchratings dans le repertoire DATA"
              FIC_A_ENVOYER=$TMP/mail_job_ko.txt
              echo "Le Batch $JOB du `date +"%d/%m/%Y"` est KO :" >> $FIC_A_ENVOYER
              echo "A `date +"%Hh%M"`, il manque le fichier $FICHIER de fitchratings dans le repertoire D
ATA "  >> $FIC_A_ENVOYER

              ksh $PARM/env_mail.ksh "$TITRE_MAIL" $FIC_DEST_MAIL $FIC_A_ENVOYER

		exit 1

	fi
done
}

fonc_format_liste()
 {

echo "*--------------------------------------------------------*" 
echo "*   Formatage de la liste $LISTE_FTP_FITCH		" 
echo "*--------------------------------------------------------*" 
FIC_TMP1=$LISTE_FTP_FITCH"1"
ls -1 $DATA | egrep "dir|dis|mis|mir" > $TMP/$FIC_TMP1

$path_awk/awk '	{	fic[NR]=$0;}
		END {
				for(i=1;i<=NR;i++) {			
									
					# Fichiers mensuels
					if (substr(fic[i],10,1) == "m"){ 	
						
						if (substr(fic[i+1],10,1) == "m"){ 		
							lig_fic="M|N|"fic[i];
						}
						else {
							lig_fic="M|O|"fic[i];
						}
					}
					
					# Fichiers quotidiens
					if (substr(fic[i],10,1) == "d"){ 	
						
						if (substr(fic[i+1],10,1) == "d"){ 		
							lig_fic="J|N|"fic[i];
						}
						else {
							lig_fic="J|O|"fic[i];
						}
					}
					
					
	 				print lig_fic;			 				
	 			}

			}				
' $TMP/$FIC_TMP1 > $DATA/$LISTE_INTEG_FITCH
echo "Liste des fichiers formates :"
cat $DATA/$LISTE_INTEG_FITCH
rm $TMP/$FIC_TMP1

echo "*-----------------*" 
echo "*... Formatage OK  " 
echo "*-----------------*" 

}
#----------#
#  MAIN    #
#----------#

FITCH_DESACTIVE_FTP=`cat $PARM/PARAM_TRR | grep "FITCH_DESACTIVE_FTP"|cut -d= -f2`
echo "FITCH_DESACTIVE_FTP = $FITCH_DESACTIVE_FTP"
if [ "$FITCH_DESACTIVE_FTP" = "O" ]
then
	echo "Recup FTP desactivee"
	exit 0
fi

echo "*---------------------------------------------------*"
echo "*   Recuperation des fichiers fitchrating's via ftp  " 
echo "*   Debut de $0 = $P_DATE                            "
echo "*---------------------------------------------------*"
rm $DATA/*.dir* $DATA/*.dis* $DATA/*.mir* $DATA/*.mis* 2>/dev/null

#---------------------------------------------------
# Construction de la liste par la PS ps_33s03_ftp_fi
#---------------------------------------------------
>$DATA/$LISTE_FTP_FITCH
fonc_execproc ps_33s03_ftp_fi
$path_awk/awk -F"|" '/|/ {printf("%s|%s\n",$1,$2)}' $ISQL_OUT > $DATA/$LISTE_FTP_FITCH
#rm $ISQL_OUT

#----------------------------------
# Récupération des fichiers via FTP
#----------------------------------
if [ ! -s $DATA/$LISTE_FTP_FITCH ]
then
	echo "Le fichier $LISTE_FTP_FITCH est vide !!"
	echo "Pas de récuperation de fichiers sur le site de Fitchratings"
else
	fonc_ftp_fic 
fi

fonc_verif_recup_ftp

#-----------------------------------
# Formatage de la liste des fichiers
#-----------------------------------
fonc_format_liste

echo "\n*--------------------------------------------*"
echo   "* Fin du script $JOB = `date +"%d%m%H%M%S"`   "
echo   "*--------------------------------------------*"


#FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")
#-------------------------------------------------------------------
#Fin du job proprement dit
#-------------------------------------------------------------------
exit ${_CODE}
