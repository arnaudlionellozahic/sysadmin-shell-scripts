#!/bin/ksh
#Dans un script d'audit sur un serveur autosys
#A lancer en auto113


menu ()
{
rep=""
echo "\033[35m              AUTOSYS REFERENTIEL'S BACKUP \033[00m"
echo "\033[36m 0 HELP \033[00m"
echo "\033[35m 1 BACKUP_SERVERS \033[00m"
echo "\033[35m 2 BACKUP_JOBS \033[00m"
echo "\033[35m 3 BACKUP_RESOURCES \033[00m"
echo "\033[35m 4 BACKUP_EXTENDED_CALENDARS \033[00m"
echo "\033[35m 5 BACKUP_STANDARD_CALENDARS \033[00m"
echo "\033[35m 6 BACKUP_CYCLE_CALENDARS \033[00m"
echo "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


#############################################################################


backup_servers ()
{
echo "BACKUP_SERVERS"
autorep -M ALL -q
}

backup_jobs ()
{
echo "BACKUP_JOBS"
autorep -j ALL -q
}

backup_resources ()
{
echo "BACKUP_RESOURCES"
autorep -V ALL -q
}

backup_extended_calendars ()
{
echo "BACKUP_EXTENDED_CALENDARS"
cd $REP
autocal_asc -E ${CAL_EXT} -e ALL
}

backup_standard_calendars ()
{
echo "BACKUP_STANDARD_CALENDARS"
cd $REP
autocal_asc -E ${CAL_STD} -s ALL
}

backup_cycle_calendars ()
{
echo "BACKUP_CYCLE_CALENDARS"
cd $REP
autocal_asc -E ${CAL_CYC} -c ALL
}


# autorep -J ALL -q > $AUTOUSER/archive/JOBS.jil
# autorep -G ALL > $AUTOUSER/archive/VARS.txt
# autocal_asc -e ALL -E $AUTOUSER/archive/CALENDARS_EXT.txt
# autocal_asc -s ALL -E $AUTOUSER/archive/CALENDARS_STD.txt
# autocal_asc -c ALL -E $AUTOUSER/archive/CALENDARS_CYC.txt
# autorep -M ALL -q > $AUTOUSER/archive/MACHINES.jil
# autorep -V ALL -q > $AUTOUSER/archive/RESOURCES.jil
# autoaggr -d


#############################################################################


choix ()
{
case $rep in
0) info ;;
1) backup_servers | tee ${SERVER} ;;
2) backup_jobs | tee ${JOB} ;;
3) backup_resources | tee ${JOB} ;;
4) backup_extended_calendars | tee ${CAL_EXT} ;;
5) backup_standard_calendars | tee ${CAL_STD} ;;
6) backup_cycle_calendars | tee ${CAL_CYC} ;;
q) echo "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}


#Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

REP=/ficsav/EQUIPE_MEO/arnaud/guinee/
SERVER=${REP}/backup_server
JOB=${REP}/backup_job
RES=${REP}/backup_res
CAL_EXT=${REP}/backup_cal.ext
CAL_STD=${REP}/backup_cal.std
CAL_CYC=${REP}/backup_cal.cycle

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

clear
menu

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}