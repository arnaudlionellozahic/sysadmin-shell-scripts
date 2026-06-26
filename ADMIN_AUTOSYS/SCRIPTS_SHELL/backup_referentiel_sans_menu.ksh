#!/bin/ksh
#Dans un script d'audit sur un serveur autosys
#A lancer en auto113


backup_servers ()
{
autorep -M ALL -q
}

backup_jobs ()
{
autorep -j ALL -q
}

backup_resources ()
{
autorep -V ALL -q
}

backup_extended_calendars ()
{
cd $REP
autocal_asc -E ${CAL_EXT} -e ALL
}

backup_standard_calendars ()
{
cd $REP
autocal_asc -E ${CAL_STD} -s ALL
}

backup_cycle_calendars ()
{
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

echo "BACKUP_AUTOSYS_OBJECTS"
echo ""
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_SERVERS"
#backup_servers > ${SERVER}
backup_servers | tee ${SERVER}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_JOBS"
#backup_jobs > ${JOB}
backup_jobs | tee ${JOB}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_RESOURCES"
#backup_resources > ${RES}
backup_resources | tee ${RES}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_EXTENDED_CALENDARS"
#backup_extended_calendars > ${CAL_EXT}
backup_extended_calendars | tee ${CAL_EXT}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_STANDARD_CALENDARS"
#backup_standard_calendars > ${CAL_STD}
backup_standard_calendars | tee ${CAL_STD}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_CYCLE_CALENDARS"
#backup_cycle_calendars > ${CAL_CYC}
backup_cycle_calendars | tee ${CAL_CYC}
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