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


#Main

REP=/ficsav/EQUIPE_MEO/arnaud/guinee/
SERVER=${REP}/backup_server
JOB=${REP}/backup_job
RES=${REP}/backup_res
CAL_EXT=${REP}/cal.ext
CAL_STD=${REP}/cal.std
CAL_CYC=${REP}/cal.cycle

echo "BACKUP_AUTOSYS_OBJECTS"
echo ""
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_SERVERS"
backup_servers > ${SERVER}
#backup_servers | tee ${SERVER}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_JOBS"
backup_jobs > ${JOB}
#backup_jobs | tee ${JOB}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_RESOURCES"
backup_resources > ${RES}
#backup_resources | tee ${RES}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_EXTENDED_CALENDARS"
backup_extended_calendars > ${CAL_EXT}
#backup_extended_calendars | tee ${CAL_EXT}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_STANDARD_CALENDARS"
backup_standard_calendars > ${CAL_STD}
#backup_standard_calendars | tee ${CAL_STD}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""

echo "BACKUP_CYCLE_CALENDARS"
backup_cycle_calendars > ${CAL_CYC}
#backup_cycle_calendars | tee ${CAL_CYC}
echo "----------------------------------------------------------------"
echo "----------------------------------------------------------------"
echo ""
