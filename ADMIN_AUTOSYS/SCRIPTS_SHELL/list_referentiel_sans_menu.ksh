#!/bin/ksh
#Dans un script d'audit sur un serveur autosys
#A lancer en auto113


list_servers ()
{
autorep -M ALL -n 
}

list_boxs ()
{
autorep -j % -l0 -n
}

list_jobs ()
{
autorep -j % -n
}

list_resources ()
{
autorep -V ALL -n
}

list_calendars ()
{
autocal_asc -l
}

list_global_variables ()
{
autorep -G ALL
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

echo "LIST_AUTOSYS_OBJECTS"
echo ""
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_SERVERS"
#list_servers > ${SERVER}
list_servers | tee ${SERVER}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_BOXS"
#list_boxs > ${BOX}
list_boxs | tee ${BOX}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_JOBS"
#list_jobs > ${JOB}
list_jobs | tee ${JOB}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_RESOURCES"
#list_resources > ${RES}
list_resources | tee ${RES}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_CALENDARS"
#list_calendars > ${CAL}
list_calendars | tee ${CAL}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "LIST_GLOBAL_VARIABLES"
#list_global_variables > ${VAR}
list_global_variables | tee ${VAR}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}