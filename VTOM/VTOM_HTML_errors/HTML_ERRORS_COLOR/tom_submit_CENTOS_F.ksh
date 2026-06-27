#!/bin/ksh
# ----------------------------------------------------- #
#               TOM SUBMITTER - KSH Standard            #
# ----------------------------------------------------- #

# Initialisation du contexte VTOM pour le job
cd $HOME || echo "Warning : Repertoire $HOME de ${job_user} non accessible\nExecution du job dans $(pwd)."
. ${TOM_ADMIN}/vtom_init.ksh

# Determination du serveur VTOM central
[[ "${TOM_REMOTE_SERVER}" = lmapexp* ]] && {
  TOM_REMOTE_MEMBER=${TOM_REMOTE_SERVER}
  TOM_REMOTE_SERVER=lmapclu1
}
TOM_SERVER=${TOM_REMOTE_SERVER}
# Affichage d'informations
echo "_______________________________________________________________________"
echo "Job                 : ${job_id}:pid=$$ (${JOB_TYPE}) en mode ${TOM_JOB_EXEC}"
echo "Job ID              : ${TOM_JOB_ID}"
echo "Traitement          : ${TOM_ENVIRONMENT}/${TOM_APPLICATION}/${TOM_JOB}"
echo " "
echo "Machine             : ${HOST}/${TOM_HOST}($TOM_LOGICAL_HOST)"
echo "Utilisateur         : ${job_user}/${TOM_USER}"
echo "Shell               : ${SHELL}"
echo "Queue batch         : ${TOM_QUEUE}"
echo "Script              : ${TOM_SCRIPT}"
echo "Arguments (ne)      : ${TOM_SCRIPT_ARGS}"
echo " "
[[ ${TOM_FAMILY:-0} = "0" ]] || echo "Famille             : ${TOM_FAMILY}"
echo "Date d'exploitation : ${TOM_DATE}(${TOM_DATE_VALUE})"
[[ ${TOM_REMOTE_MEMBER:-0} = "0" ]] || TOM_SERVER="${TOM_SERVER} [${TOM_REMOTE_MEMBER}]"
if [[ ${TOM_BACKUP_SERVER:-0} = "0" ]]; then
  echo "Serveur VTOM        : ${TOM_SERVER}"
else
  echo "Serveurs VTOM       : ${TOM_SERVER} / ${TOM_BACKUP_SERVER}"
fi
echo " "
echo "Periodicite         : ${TOM_PERIODICITY}"
if [[ ${TOM_JOB_RETRY} -gt 0 ]]; then
  if [[ "${TOM_JOB_MAX_RETRY}" = "" ]]; then
    echo "Relance             : ${TOM_JOB_RETRY}"
  else
    echo "Relances            : ${TOM_JOB_RETRY}/${TOM_JOB_MAX_RETRY} => ${TOM_JOB_REMAIN_RETRY}"
  fi
fi
[[ ${TOM_JOB_POINT} -eq 0 ]] || echo "Label de reprise    : ${TOM_JOB_POINT}"

# Verification du script
eval whence ${TOM_SCRIPT} > /dev/null 2>&1
if [[ ${?} -eq 0 ]]; then
  LOCATION=$(whence ${TOM_SCRIPT})
  echo " "
  print "Repertoire courant  : \c"; pwd
  print "Script (type)       : \c"; file $LOCATION
  set -A arg ""
  i=1
  argtot=""
  while [[ ${#} -gt 0 ]]; do
    argtot=${argtot}" "\"\$\{arg\[${i}\]\}\"
    arg[$i]=$(eval echo ${1})
    echo "${i}                   : ${arg[${i}]}"
    shift
    i=$((i+1))
  done
else
  LOCATION=${TOM_SCRIPT}
  TOM_JOB_EXEC="FAILURE"
  echo "${TOM_SCRIPT} n'est pas executable ou est absent du PATH\n(${PATH})."
fi

# Execution du script
echo "_______________________________________________________________________"
T_DEB=$(date +"%d/%m/%Y %H:%M:%S %Z")
date +"%d/%m/%Y - %u/%V/%Y - %j/%Y - %H:%M:%S %Z"
echo " Debut de l'execution du script ..."
echo "_______________________________________________________________________"
echo " "
if [[ ${TOM_JOB_EXEC} = "NORMAL" ]]; then
  eval ${TOM_SCRIPT} $(echo ${argtot})
  stat_fin_job=${?}
elif [[ ${TOM_JOB_EXEC} = "TEST" ]]; then
  echo "<< -- Mode TEST -- >>"
  echo "Pas d'execution"
  stat_fin_job=0
else
  echo "Conditions anormales dans le submitter : mode ${TOM_JOB_EXEC} inconnu ou non gere." >&2
  stat_fin_job=255
fi
echo "_______________________________________________________________________"
T_FIN=$(date +"%d/%m/%Y %H:%M:%S %Z")
date +"%d/%m/%Y - %u/%V/%Y - %j/%Y - %H:%M:%S %Z"
echo "... Fin de l'execution du script."
echo " "

# Gestion du code retour
if [ "${stat_fin_job}" = "0" ]; then
  echo "Termine --> Exit [${stat_fin_job}] donc acquitement"
  ${ABM_BIN}/tsend -sT -r${stat_fin_job} -m"Termine (${stat_fin_job})"
else
  echo "Erreur --> Exit [${stat_fin_job}] donc pas d'acquitement"
  ${ABM_BIN}/tsend -sE -r${stat_fin_job} -m"En erreur (${stat_fin_job})"
fi
echo "_______________________________________________________________________"

# Inscription dans une log
echo "## ${TOM_ENVIRONMENT};${TOM_APPLICATION};${TOM_JOB};${TOM_FAMILY};${TOM_JOB_EXEC};${TOM_REMOTE_SERVER};${TOM_HOST};${TOM_USER};${TOM_QUEUE};${TOM_DATE};${TOM_DATE_VALUE};${T_DEB};${T_FIN};${TOM_JOB_RETRY};${TOM_JOB_REMAIN_RETRY};${TOM_JOB_MAX_RETRY};${TOM_JOB_POINT};${stat_fin_job} ##"
