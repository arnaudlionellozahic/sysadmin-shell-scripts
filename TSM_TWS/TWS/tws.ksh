#!/bin/ksh -x


menu ()
{
rep=""
echo -e "\033[35m              EXPORTS TWS \033[00m"
echo -e "\033[36m 0 HELP \033[00m"
echo -e "\033[35m 1 PROCESS_STATUS_MASTER \033[00m"
echo -e "\033[35m 2 PROCESS STATUS CLIENTS \033[00m"
echo -e "\033[35m 3 EXPORT_JOBS_SCHED_ERROR \033[00m"
echo -e "\033[35m 4 EXPORT_REFERENTIEL \033[00m"
echo -e "\033[35m 5 EXPORT_PLANIF_JOBS_TSM \033[00m"
echo -e "\033[35m 6 CSV_JOBS_TSM_(SUITE_5) \033[00m"
echo -e "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo -e "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


#############################################################################
#############################################################################


process_status_master ()
{

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
        echo "The 14 wtriter PROCESSES ARE PRESENTS"
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

}


#############################################################################
#############################################################################


process_status_clients ()
{

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

}


#############################################################################
#############################################################################


export_jobs_sched_error ()
{

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

}


#############################################################################
#############################################################################


export_referentiel ()
{

menu ()
{
rep=""
echo -e "\033[35m              TWS REFERENTIEL'S EXTRACTION \033[00m"
echo -e "\033[36m 0 HELP \033[00m"
echo -e "\033[35m 1 VERSION_CPU \033[00m"
echo -e "\033[35m 2 LIST_CPU \033[00m"
echo -e "\033[35m 3 EXPORT_JOBS \033[00m"
echo -e "\033[35m 4 EXPORT SCHEDULES \033[00m"
echo -e "\033[35m 5 EXPORT_CALENDARS \033[00m"
echo -e "\033[35m 6 EXPORT EVENTRULES \033[00m"
echo -e "\033[35m 7 EXTRACTION VARTABLES \033[00m"
echo -e "\033[35m 8 EXTRACTION VARIABLES \033[00m"
echo -e "\033[35m 9 EXTRACTION RESSOURCES \033[00m"
echo -e "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo -e "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


version_cpu ()
{
. ${REP}/version_cpu.ksh
}

list_cpu ()
{
. ${REP}/list_cpu.ksh
}

export_jobs ()
{
. ${REP}/export_jobs.ksh
}

export_schedules ()
{
. ${REP}/export_schedules.ksh
}

export_calendars ()
{
. ${REP}/export_calendars.ksh
}

export_erules ()
{
. ${REP}/export_erules.ksh
}

export_vartables ()
{
. ${REP}/export_vartables.ksh
}

export_variables ()
{
. ${REP}/export_variables.ksh
}

export_resources ()
{
. ${REP}/export_resources.ksh
}

choix ()
{
case $rep in
0) info ;;
1) version_cpu ;;
2) list_cpu ;;
3) export_jobs ;;
4) export_schedules ;;
5) export_calendars ;;
6) export_erules ;;
7) export_vartables ;;
8) export_variables ;;
9) export_resources ;;
q) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}

#Main
REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/SCRIPTS
clear
menu

}


#############################################################################
#############################################################################


export_planif_jobs_tsm ()
{

sched_PVL0BE-CYG-01 ()
{
cd ${REP}
ssh tws85@hades /maestro85/TWS/bin/composer extract ${FIC1} from schedule=PVL0BE-CYG-01#@ << EOJ
quit
EOJ
scp tws85@hades:$FIC1 .
}

sched_PVL0UL-CYG-01 ()
{
cd ${REP}
ssh tws85@hades /maestro85/TWS/bin/composer extract ${FIC2} from schedule=PVL0UL-CYG-01#@ << EOJ
quit
EOJ
scp tws85@hades:$FIC2 .
}

concat ()
{
cat schedules_PVL0BE-CYG-01.txt schedules_PVL0UL-CYG-01.txt > $FIC
}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/EXPORTS_JOBS_TSM
FIC1=/maestro85/export/schedules_PVL0BE-CYG-01.txt
FIC2=/maestro85/export/schedules_PVL0UL-CYG-01.txt
FIC=${REP}/schedules_all_wk.txt

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

sched_PVL0BE-CYG-01
sched_PVL0UL-CYG-01
concat

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}

}


#############################################################################
#############################################################################


csv_jobs_tsm ()
{

entete ()
{
echo "SCHEDULE;DESCRIPTION;CALENDAR;BEGIN_SCHED;CARRYFORWARD;LIMIT;JOB;BEGIN_JOB"
}

req ()
{
cat ${FIC} | sed -e 's/\(SCHEDULE.*\)/RECORD_SEP\1/' -e 's/\(FINFIN.*\)/\1RECORD_SEP/' |awk 'BEGIN{ RS="RECORD_SEP" } /SCHEDULE.*FINFIN.*/ { print $0 }' | awk -F "=" 'BEGIN {deb=""}
  $1 == "SCHEDULE" { printf "\n%-s%-s",$2,";"}
  $1 == "DESCRIPTION" { printf "%-s%-s",$2,";"}
  $1 == "CALENDAR" { printf "%-s%-s",$2,";"}
  $1 == "BEGINSCHED" { printf "%-s%-s",$2,";"}
  $1 == "CARRYFORWARD" { printf "%-s%-s",$2,";"}
  $1 == "LIMIT" { printf "%-s%-s",$2,";"}
  $1 == "JOB" { printf "%-s%-s",$2,";"}
  $1 == "BEGINJOB" { printf "%-s%-s",$2,";"}
'
}

#Main
REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/EXPORTS_JOBS_TSM
FIC=${REP}/schedules_all_wk.txt
LIST=${REP}/list
OUT=${REP}/export_schedule_global.csv

cd ${REP}
perl -pi -e "s/://g" ${FIC}
sed -i '/^$/d' ${FIC}
sed -i "s/^ *//g" ${FIC}

#manque un parser => les delimiteurs sont a rajouter a la main
entete > ${OUT}
req >> ${OUT}

#perl -pi -e 's/\"DESCRIPTION \"//g' ${OUT}
#perl -pi -e 's/SCHEDULE //g' ${OUT}

}


#############################################################################
#############################################################################


choix ()
{
case $rep in
0) info ;;
1) process_status_master ;;
2) process_status_clients ;;
3) export_jobs_sched_error ;;
4) export_referentiel ;;
5) export_planif_jobs_tsm ;;
6) csv_jobs_tsm ;;
q) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}


#Main
clear
menu
