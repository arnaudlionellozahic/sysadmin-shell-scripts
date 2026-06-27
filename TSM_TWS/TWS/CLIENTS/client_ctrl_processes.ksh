#!/bin/ksh -x 

entete ()
{
echo "[TWS] : Control of the tws clients processes le $(date "+%Y%m%d a %H%M%S")"
echo ""
echo "###################################################################"
}

control_processes_1 ()
{
for u in `cat ${LIST1}`
do
	ssh tws85@$u ps -ef | egrep "jobman|netman|batchman|mailman|writer" | grep -v egrep | awk -F"/" '{print $5}' | sort -n | sort -u > ${REP}/${u}_processes.log
done
}

control_processes_2 ()
{
for u in `cat ${LIST2}`
do
        ssh tws85@$u ps -ef | egrep "jobman|netman|batchman|mailman|writer" | grep -v egrep | awk -F"/" '{print $6}' | sort -n | sort -u > ${REP}/${u}_processes.log
done
}

control_processes_3 ()
{
for u in `cat ${LIST3}`
do
        ssh tws85@$u ps -ef | egrep "jobman|netman|batchman|mailman|writer" | grep -v egrep | awk -F"/" '{print $7}' | sort -n | sort -u > ${REP}/${u}_processes.log
done
}

verif_errors ()
{

# We verify that all the master processes are presents

for v in `cat ${LIST_PROC}`
do
echo ""
echo "*******************************************************************"
echo "CONTROL THE PRESENCE OF THE PROCESS ${v}"
echo "*******************************************************************"

	for i in `cat ${LIST_ALL}`
	do

	if [ `grep ${v} ${REP}/$i*.log | wc -l` -lt 1 ]; then
  	echo ""
  	echo "THE ${v} PROCESS of $i IS MISSING, RESTART IT"
  	echo "Here is the processes log : ${REP}/${i}_processes.log"
  	echo ""
  	echo "-------------------------------------------------------------------"
  	echo ""
  	echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
  	echo "exit 2"
	email -s "Control of the tws clients processes le $(date "+%Y%m%d a %H%M%S")" Arnaud_LOZAHIC@europ-assistance.fr < ${FILE_LOG}	
  	exit 2
        	else
        	echo ""
        	echo "THE ${v} PROCESS of $i IS PRESENT"
        	echo "Here is the processes log : ${REP}/${i}_processes.log"
        	echo ""
        	echo "-------------------------------------------------------------------"
	fi
	done
done
}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
REP=/home/alozahic/SCRIPTS_SHELL/TWS/CLIENTS
FILE_LOG=${REP}/clients_processes.log
LIST1=${REP}/workstations_list1
LIST2=${REP}/workstations_list2
LIST3=${REP}/workstations_list3
LIST_ALL=${REP}/workstations_list_all
LIST_PROC=${REP}/processes_list

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
control_processes_1
control_processes_2
control_processes_3
verif_errors >> ${FILE_LOG} 

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
