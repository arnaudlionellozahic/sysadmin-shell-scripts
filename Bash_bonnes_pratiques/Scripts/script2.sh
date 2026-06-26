#!/bin/bash
# Script de déploiement de l'application archeschool

WORK_DIR="/tmp/"
WWW_DIR=~/www/
LOG="${WORKDIR}script1.log"
SFTP_HOST="sftp1.apovir.net"
SFTP_LOGIN="archeschool"
SFTP_PORT="1122"
ARCHIVE_NAME="version1.tar.gz"
MAIL_SUBJECT="déploiement d'archeschool OK"
MAIL_FROM="ludovic.lefloch@arche-mc2.fr"

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
