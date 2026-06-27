#!/bin/ksh -x

entete ()
{
echo "Report of the autosys jobs le $(date "+%Y%m%d a %H%M%S")"
echo ""
echo "###################################################################"
}

jobs_report ()
{
# autorep -j ALL | grep -w OI | awk '{print $1}'
autorep -j ALL | grep -w OI
}

verif ()
{

if [ `awk '/OI/' ${FILE} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs on ice"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
#  rm -f ${FILE} ${FILE_LOG}
  exit 0
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are ${count_oi} jobs on ice, check the file : ${FILE}"
		echo ""
        cat ${FILE}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
#        rm -f ${FILE} ${FILE_LOG}
        exit 5
fi

}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
#DATE=$(date "+%Y%m%d a %H%M%S")
REP=/apps/meoatlas2/arnaud
FILE=${REP}/report.txt_KSH
FILE_LOG=${REP}/jobs_onice.log_KSH
count_oi=`awk '/OI/' report.txt |wc -l`

#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------
echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo ""
echo "#### DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
echo ""

entete | tee ${FILE_LOG}
jobs_report | tee ${FILE}
verif | tee -a ${FILE_LOG}

#echo ""
#echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#echo "exit ${?}"
#exit ${?}

