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


verif_jobs_FA ()
{

if [ `awk '/FA/' ${FILE_FA} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en erreur"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
#  rm -f ${FILE_FA} ${FILE_LOG_FA}
  exit 0
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/FA/' ${FILE_FA} | wc -l` jobs in error, check the file : ${FILE_FA}"
        echo ""
        cat ${FILE_FA}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
#        rm -f ${FILE_FA} ${FILE_LOG_FA}
        exit 5
fi

}

verif_jobs_RU ()
{

if [ `awk '/RU/' ${FILE_RU} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en running"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
#  rm -f ${FILE_RU} ${FILE_LOG_RU}
  exit 0
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/RU/' ${FILE_RU} | wc -l` jobs running, check the file : ${FILE_RU}"
        echo ""
        cat ${FILE_RU}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
#        rm -f ${FILE_RU} ${FILE_LOG_RU}
        exit 5
fi

}

verif_jobs_OH ()
{

if [ `awk '/OH/' ${FILE_OH} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en hold"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
#  rm -f ${FILE_OH} ${FILE_LOG_OH}
  exit 0
        else
        cd ${REP}
#        ./rapport_html_all.ksh
#        ./rapport_csv_all.ksh
        echo ""
        echo "There are `awk '/OH/' ${FILE_OH} | wc -l` jobs on hold, check the file : ${FILE_OH}"
        echo ""
        cat ${FILE_OH}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
#        rm -f ${FILE_OH} ${FILE_LOG_OH}
        exit 5
fi

}

verif_jobs_OI ()
{

if [ `awk '/OI/' ${FILE_OI} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs on ice"
  echo ""
  echo "-------------------------------------------------------------------"
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
        echo "There are `awk '/OI/' ${FILE_OI} | wc -l` jobs on ice, check the file : ${FILE_OI}"
        echo ""
        cat ${FILE_OI}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
#        rm -f ${FILE_OI} ${FILE_LOG_OI}
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

FILE_FA=${REP}/jobs_FA.txt_KSH
FILE_RU=${REP}/jobs_RU.txt_KSH
FILE_OH=${REP}/jobs_OH.txt_KSH
FILE_OI=${REP}/jobs_OI.txt_KSH

FILE_LOG_FA=${REP}/report_FA.log_KSH
FILE_LOG_RU=${REP}/report_RU.log_KSH
FILE_LOG_OH=${REP}/report_OH.log_KSH
FILE_LOG_OI=${REP}/report_OI.log_KSH


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

# JOBS FAILED
entete | tee ${FILE_LOG_FA}
jobs_report_FA | tee ${FILE_FA}
verif_jobs_FA | tee -a ${FILE_LOG_FA}

# JOBS RUNNING
entete | tee ${FILE_LOG_RU}
jobs_report_RU | tee ${FILE_RU}
verif_jobs_RU | tee -a ${FILE_LOG_RU}

# JOBS ON HOLD
entete | tee ${FILE_LOG_OH}
jobs_report_OH | tee ${FILE_OH}
verif_jobs_OH | tee -a ${FILE_LOG_OH}

# JOBS ON ICE
entete | tee ${FILE_LOG_OI}
jobs_report_OI | tee ${FILE_OI}
verif_jobs_OI | tee -a ${FILE_LOG_OI}

#echo ""
#echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#echo "exit ${?}"
#exit ${?}
