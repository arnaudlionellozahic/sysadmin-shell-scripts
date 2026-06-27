#!/bin/ksh 

function verif_param {
if [ ${NBRP} = "1" ]
    then
    ecrire_log "Nbre de param. correct : ${NBRP}"
        else
        ecrire_log "Nbre de param. incorrect !" && erreur "Nbre de param. incorrects !"
	echo -e "\033[1;33;40m Usage : \033[0m"
        echo -e "\033[1;33;40m ${PRG} <Code Application de type V58 ou N13> \033[0m"
        ecrire_log "Usage : ${PRG} <Code Application de type V58 ou N13>"
	#echo -e "\033[1;35m exit 1 \033[0m"  
        exit 1
fi
}

function ecrire_log {
        echo "${DT_EXEC} : ${1}" >> ${LOG_FILE}
}

function erreur {
        echo -e "\033[1;31;40m -> ${1} \033[0m"
}

#Main
PRG="Verif_jobs_holdes.ksh"
NBRP="$#"
DT_EXEC=`date +%d%m%Y_%H%M`
DT_J=`date +%Y%m%d`
HOST=`hostname`
REP="/slqdl7bdd01/appli/dl7/sp/tests_ctlm/job_holdes.log"
LOG_FILE="${REP}/${PRG}-${DT_EXEC}.log"
CODAPP="$1"

# 1 - Verification et creation du fichier de log :
if [ -f ${LOG_FILE} ]
    then
    erreur "Erreur : Le fichier ${LOG_FILE} existe deja."
    exit
        else
        echo "${DT_EXEC} : Creation de ${LOG_FILE}" > ${LOG_FILE}
fi

# 2 - Verification de la presence des paramètres
verif_param

ecrire_log "Recuperation des statistiques"
ctmpsm -LISTALL > ${REP}/Recup_statut_plan.txt && ecrire_log "ctmspsm -LISTALL > ${REP}/Recup_statut_plan.txt -> recup ok"

ecrire_log "cat ${REP}/Recup_statut_plan.txt | grep ${DT_J} | grep ${CODAPP} | grep Hold "
cat ${REP}/Recup_statut_plan.txt | grep ${DT_J} | grep ${CODAPP} | grep Hold 1>/${REP}/Recup_statut_plan.txt_filtre

if [ -s ${REP}/Recup_statut_plan.txt_filtre ]
    then
    ecrire_log " -> Les groupes et jobs ci-dessous sont holdes sur le plan du jour"
    cat ${REP}/Recup_statut_plan.txt_filtre >> ${LOG_FILE}
        else
        ecrire_log " -> fichier filtre ${REP}/Recup_statut_plan.txt_filtre vide"
	ecrire_log " -> aucun job holde sur le plan du jour" 
fi

cat ${LOG_FILE}

