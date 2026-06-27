#!/bin/ksh
#Dans un script d'audit sur un serveur autosys
#A lancer en auto113


menu ()
{
rep=""
echo "\033[35m              AUTOSYS REFERENTIEL'S LIST \033[00m"
echo "\033[36m 0 HELP \033[00m"
echo "\033[35m 1 LIST_SERVERS \033[00m"
echo "\033[35m 2 LIST_BOXS \033[00m"
echo "\033[35m 3 LIST_JOBS \033[00m"
echo "\033[35m 4 LIST_RESOURCES \033[00m"
echo "\033[35m 5 LIST_CALENDARS \033[00m"
echo "\033[35m 6 LIST_GLOBAL_VARIABLES \033[00m"
echo "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


#############################################################################


list_servers ()
{
echo "LIST_SERVERS"
autorep -M ALL -n 
}

list_boxs ()
{
echo "LIST_BOXS"
autorep -j % -l0 -n
}

list_jobs ()
{
echo "LIST_JOBS"
autorep -j % -n
}

list_resources ()
{
echo "LIST_RESOURCES"
autorep -V ALL -n
}

list_calendars ()
{
echo "LIST_CALENDARS"
autocal_asc -l
}

list_global_variables ()
{
echo "LIST_GLOBAL_VARIABLES"
autorep -G ALL
}


#############################################################################


choix ()
{
case $rep in
0) info ;;
1) list_servers | tee ${SERVER} ;;
2) list_boxs | tee ${BOX} ;;
3) list_jobs | tee ${JOB} ;;
4) list_resources | tee ${RES} ;;
5) list_calendars | tee ${CAL} ;;
6) list_global_variables | tee ${VAR} ;;
q) echo "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}



#Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

REP=/ficsav/EQUIPE_MEO/arnaud/guinee/
SERVER=${REP}/list_server
BOX=${REP}/list_box
JOB=${REP}/list_job
RES=${REP}/list_res
CAL=${REP}/list_cal
VAR=${REP}/list_global_var

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