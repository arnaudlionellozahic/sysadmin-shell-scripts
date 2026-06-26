#!/bin/bash
# Script de déploiement de l'application archeschool

trap finish 1 2 3 6

# Configuration du script
WORK_DIR="/tmp/"
. $0.conf
LOG="${WORKDIR}script1.log"
ARCHIVE_NAME="version1.tar.gz"

echo "Déploiement de archeschool" > ${LOG}

# récupération de l'archive
function download_archive() {
  local archive_name="${1}"
  sftp -4 -o ConnectTimeout=3 -q -P ${SFTP_PORT} ${SFTP_LOGIN}@${SFTP_HOST}:/${archive_name} ${WORK_DIR} >> ${LOG}
}

# déploiement de l'application
function deploy_archive() {
  local archive_name="${1}"
  local www_dir="${2}"
  mkdir -p ${www_dir} > /dev/null
  cd ${www_dir} > /dev/null
  tar -xvzf ${WORK_DIR}${archive_name} >> ${LOG}
  cd - > /dev/null

  # redémarrage du service
  systemctl status apache2 >> ${LOG}
}

# log & fin
function finish() {
  echo "Déploiement terminé" >> ${LOG}
  cat ${LOG} | mail -s "${MAIL_SUBJECT}" -- ${MAIL_FROM}
}


download_archive ${ARCHIVE_NAME}
deploy_archive ${ARCHIVE_NAME} ${WWW_DIR}
finish

exit 0
