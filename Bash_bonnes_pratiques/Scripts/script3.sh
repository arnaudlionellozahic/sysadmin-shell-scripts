#!/bin/bash
# Script de déploiement de l'application archeschool

# Configuration du script
WORK_DIR="/tmp/"
. $0.conf
LOG="${WORKDIR}script1.log"
ARCHIVE_NAME="version1.tar.gz"

echo "Déploiement de archeschool" > ${LOG}

# récupération de l'archive
sftp -4 -o ConnectTimeout=3 -q -P ${SFTP_PORT} ${SFTP_LOGIN}@${SFTP_HOST}:/${ARCHIVE_NAME} ${WORK_DIR} >> ${LOG}

# déploiement de l'application
mkdir -p ${WWW_DIR} > /dev/null
cd ${WWW_DIR} > /dev/null
tar -xvzf ${WORK_DIR}${ARCHIVE_NAME} >> ${LOG}
cd - > /dev/null

# redémarrage du service
systemctl status apache2 >> ${LOG}

# log & fin
echo "Déploiement terminé" >> ${LOG}
cat ${LOG} | mail -s "${MAIL_SUBJECT}" -- ${MAIL_FROM}
exit 0
