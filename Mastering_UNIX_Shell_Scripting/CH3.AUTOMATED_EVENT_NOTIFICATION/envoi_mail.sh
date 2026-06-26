#!/bin/ksh
###################################################################
# Fichier     : envoi_mail.sh                                     #
#                                                                 #
# Création    : HAMMADI Choukri       01/11/2016 - version :1.00  #
#                                                                 #
###################################################################
#  set -xv
SERVEUR_NAME=`hostname|tr 'a-z' 'A-Z'`
FILE_ENVOI_MAIL="/tmp/Envoi_Mail_`hostname`_`date +%Y%d%m`_$$.log"
Transfert_Mail="${FILE_ENVOI_MAIL}"

################################
RESULT ()
{
RET=$1
        if [ ${RET} -ne 0 ];
        then
                echo -e "\t\t\tFATAL   :  Probleme sur le Traitement $2"
                exit ${RET}
        fi
}

#=====================================================================

# Usage: nomscript -options
# Note: tiret (-) nM-icessaire

while getopts :f:s:d: opt
do
        case $opt in
            f)  LOG_TRAIT="$OPTARG";;
            s)  SUBJECT_SAVE="$OPTARG";;
            d)  DEST="$OPTARG";;
            \?)  echo "erreur option $opt inconnue"; exit 1;;
        esac

done

if [ -z "${LOG_TRAIT}" ];
then
        echo "Usage: `basename $0` options -f <Fichier a Transferer> -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"
        STATUS=16
        RESULT ${STATUS} "Le Nom du Fichier  doit ETRE INITIALISE AVEC L'OPTION -f <Nom du Fichier a Transferer> -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"
fi


if [ -z "${SUBJECT_SAVE}" ];
then

        echo "Usage: `basename $0` options -f <Fichier a Transferer>  -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"
        STATUS=16
        RESULT ${STATUS} "Le Nom du Fichier  doit ETRE INITIALISE AVEC L'OPTION -f <Nom du Fichier a Transferer> -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"
fi

if [ -z "${DEST}" ];
then

        echo "Usage: `basename $0` options -f <Fichier a Transferer>  -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"
        STATUS=16
        RESULT ${STATUS} "Le Nom du Fichier  doit ETRE INITIALISE AVEC L'OPTION -f <Nom du Fichier a Transferer> -s <Subject a integrer au MAIL> -d <DESTINATAIRE >"

fi


export Subject_Filename="${SUBJECT_SAVE}.txt"


#============================================================



ENVOI_MAIL ()
{
        ENTETE_MAIL ()
        {
        echo "From: rman "                                      >  ${Transfert_Mail}
        echo "To: ${DEST}"                                      >> ${Transfert_Mail}
        echo "Subject: ${SUBJECT_SAVE}  "                       >> ${Transfert_Mail}
        echo "Mime-Version: 1.0"                                >> ${Transfert_Mail}
        echo "Content-Type: multipart/mixed; boundary="." "     >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        echo "--."                                              >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        echo -e "Bonjour"                                         >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        echo -e "Voici le compte rendu de la sauvegarde rman de la base ${SUBJECT_SAVE} sur le serveur ${SERVEUR_NAME}"              >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        echo -e "Cordialement,"                                    >>  ${Transfert_Mail}
        echo -e "Equipe MEO IRB"                                  >> ${Transfert_Mail}
        echo -e                                                   >> ${Transfert_Mail}
        }

        ENTETE_MAIL

         if [ -s ${LOG_TRAIT} ];
         then
                echo "--."                                                                                >> ${Transfert_Mail}
                echo -e "Content-Type: text/plain; name="Fichier_Compte_rendu_${LOG_TRAIT}""                >> ${Transfert_Mail}
                echo -e "Content-Disposition: attachment; filename="${Subject_Filename}""                   >> ${Transfert_Mail}
                echo -e                                                                                     >> ${Transfert_Mail}
                echo -e "Voici le Compte Rendu ${SUBJECT_SAVE}  :  "                                        >> ${Transfert_Mail}
                echo "---------------------------------------"                                            >> ${Transfert_Mail}
                cat ${LOG_TRAIT}                                                                          >> ${Transfert_Mail}
                echo -e                                                                                     >> ${Transfert_Mail}
        fi

                cat ${Transfert_Mail} | /usr/sbin/sendmail -t
}


ENVOI_MAIL
