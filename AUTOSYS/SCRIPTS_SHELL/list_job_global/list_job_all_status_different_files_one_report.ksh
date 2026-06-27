#!/bin/ksh -x

entete ()
{
echo "Report of the autosys jobs le $(date "+%Y%m%d a %H%M%S")"
echo ""
echo "###################################################################"
}

jobs_report_FA ()
{
# autorep -j ALL | grep -w FA | awk '{print $1}'
autorep -j ALL | grep -w FA
}

jobs_report_RU ()
{
# autorep -j ALL | grep -w RU | awk '{print $1}'
autorep -j ALL | grep -w RU
}

jobs_report_OH ()
{
# autorep -j ALL | grep -w OH | awk '{print $1}'
autorep -j ALL | grep -w OH
}

jobs_report_OI ()
{
# autorep -j ALL | grep -w OI | awk '{print $1}'
autorep -j ALL | grep -w OI
}


verif_jobs ()
{

if [ `awk '/FA/' ${FILE_FA} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en erreur"
#  rm -f ${FILE_FA} ${FILE_LOG_FA}
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/FA/' ${FILE_FA} | wc -l` jobs in error"
        echo ""
        cat ${FILE_FA}
#        rm -f ${FILE_FA} ${FILE_LOG_FA}
fi

echo ""
echo "###################################################################"

if [ `awk '/RU/' ${FILE_RU} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en running"
#  rm -f ${FILE_RU} ${FILE_LOG_RU}
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/RU/' ${FILE_RU} | wc -l` jobs running"
        echo ""
        cat ${FILE_RU}
#        rm -f ${FILE_RU} ${FILE_LOG_RU}
fi

echo ""
echo "###################################################################"

if [ `awk '/OH/' ${FILE_OH} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en hold"
#  rm -f ${FILE_OH} ${FILE_LOG_OH}
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/OH/' ${FILE_OH} | wc -l` jobs on hold"
        echo ""
        cat ${FILE_OH}
#        rm -f ${FILE_OH} ${FILE_LOG_OH}
fi

echo ""
echo "###################################################################"

if [ `awk '/OI/' ${FILE_OI} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs on ice"
  echo ""
  echo " "
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
#  rm -f ${FILE_OI} ${FILE_LOG_OI}
  exit 0
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/OI/' ${FILE_OI} | wc -l` jobs on ice"
        echo ""
        cat ${FILE_OI}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit ${?}"
#        rm -f ${FILE_OI} ${FILE_LOG_OI}
        exit ${?}
fi

}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
#DATE=$(date "+%Y%m%d a %H%M%S")

REP=/apps/meoatlas2/arnaud
FILE_LOG=${REP}/report.log_KSH

FILE_FA=${REP}/jobs_FA.txt_KSH
FILE_RU=${REP}/jobs_RU.txt_KSH
FILE_OH=${REP}/jobs_OH.txt_KSH
FILE_OI=${REP}/jobs_OI.txt_KSH

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

jobs_report_FA | tee ${FILE_FA}
jobs_report_RU | tee ${FILE_RU}
jobs_report_OH | tee ${FILE_OH}
jobs_report_OI | tee ${FILE_OI}

entete | tee ${FILE_LOG}

verif_jobs | tee -a ${FILE_LOG}

rm -f ${FILE_FA}
rm -f ${FILE_RU}
rm -f ${FILE_OH}
rm -f ${FILE_OI}

#echo ""
#echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#echo "exit ${?}"
#exit ${?}
