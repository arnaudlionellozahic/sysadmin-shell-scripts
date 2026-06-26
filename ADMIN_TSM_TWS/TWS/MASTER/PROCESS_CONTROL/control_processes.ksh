#!/bin/ksh -x 

entete ()
{
echo "Control of the tws master processes le $(date "+%Y%m%d a %H%M%S")"
echo ""
echo "###################################################################"
}

master_control_processes ()
{
ssh tws85@hades ps -ef | egrep "jobman|netman|batchman|mailman|writer" | grep -v egrep | awk -F"/" '{print $5}' | sort -n
}

verif_errors ()
{

# We verify that all the master processes are presents

for v in `cat $LIST_PROC`
do
if [ `grep ${v} ${FIC} | wc -l` -lt 1 ]; then
  echo ""
  echo "THE ${v} PROCESS IS MISSING, RESTART IT"
  echo "Here is the processes log : ${FIC}"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 2"
  exit 2
        else
        echo ""
        echo "THE ${v} PROCESS IS PRESENT"
	echo "Here is the processes log : ${FIC}"
        echo ""
        echo "-------------------------------------------------------------------"
fi
done

if [ `grep mailman ${FIC} | wc -l` -lt 3 ]; then
  echo ""
  echo "One of the three mailman PROCESSES IS MISSING, RESTART IT"
  echo "Here is the processes log : ${FIC}"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 2"
  exit 2
        else
        echo ""
        echo "THE 3 mailman PROCESSES ARE PRESENTS"
        echo "Here is the processes log : ${FIC}"
        echo ""
        echo "-------------------------------------------------------------------"
fi

if [ `grep writer ${FIC} | wc -l` -lt 14 ]; then
  echo ""
  echo "One of the 14 writer PROCESSES IS MISSING, RESTART IT"
  echo "Here is the processes log : ${FIC}"
  echo ""
  echo "-------------------------------------------------------------------"
  echo ""
  echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  echo "exit 2"
  exit 2
        else
        echo ""
        echo "The 14 writer PROCESSES ARE PRESENTS"
        echo "Here is the processes log : ${FIC}"
        echo ""
        echo "-------------------------------------------------------------------"
fi

}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
REP=/home/alozahic/SCRIPTS_SHELL/TWS/MASTER/PROCESS_CONTROL
FIC=${REP}/hades_processes.txt
FILE_LOG=${REP}/hades_processes.log
LIST_PROC=${REP}/master_processes_list

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
master_control_processes > ${FIC}
verif_errors >> ${FILE_LOG} 

email -s "[PROD][TWS] : Control of the tws master processes le $(date "+%Y%m%d a %H%M%S")" Arnaud_LOZAHIC@europ-assistance.fr < ${FILE_LOG}

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
