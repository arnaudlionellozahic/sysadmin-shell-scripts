#!/bin/ksh -x

entete ()
{
echo "Paging of the tws jobs le $(date "+%Y%m%d a %H%M%S")"
echo ""
echo "###################################################################"
}

jobs_abend_paging ()
{
ssh tws85@hades /maestro85/TWS/bin/conman "sj @#@+state=abend" << EOJ> ${FIC}
quit
EOJ
}

jobs_abend_paging_info ()
{
ssh tws85@hades /maestro85/TWS/bin/conman "sj @#@+state=abend\;info" << EOJ> ${FIC_INFO}
quit
EOJ
}

fonc_rapport_global ()
{
echo ""
grep ABEND ${FIC}
echo ""
echo "###################################################################"
}

fonc_rapport_jobs_unix ()
{
echo ""
cat ${FIC_INFO} |  awk -F "/" '{print $6}' | awk NF 
echo ""
echo "###################################################################"
}

fonc_rapport_jobs_win ()
{
echo ""
cat ${FIC_INFO} |  awk -F "\\" '{print $6}' | awk NF
echo ""
}

verif ()
{

if [ `grep ABEND ${FILE} | wc -l` -lt 1 ]; then
  echo ""
  echo "Pas de jobs en erreur"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 0"
  rm -f ${FILE} ${FILE_LOG}
  exit 0
        else
        cd ${REP}
        ./rapport_html_all.ksh
        ./rapport_csv_all.ksh
        echo ""
        echo "There are jobs in error"
        cat ${FILE}
        echo ""
        echo "-------------------------------------------------------------------"
        echo ""
        echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
        echo "exit 5"
        rm -f ${FILE} ${FILE_LOG}
        exit 5
fi

}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
REP=/home/alozahic/SCRIPTS_SHELL/TWS/MASTER/STATUS_CONTROL
FIC=${REP}/jobs_abend_paging.txt
FIC_INFO=${REP}/jobs_abend_paging_info.txt
FILE=${REP}/rapport.txt
FILE_LOG=${REP}/jobs_abend_paging.log

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

entete > ${FILE_LOG}
jobs_abend_paging > ${FIC}
jobs_abend_paging_info > ${FIC_INFO} 
fonc_rapport_global > ${FILE}
fonc_rapport_jobs_unix >> ${FILE}
fonc_rapport_jobs_win >> ${FILE}
verif >> ${FILE_LOG}

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
