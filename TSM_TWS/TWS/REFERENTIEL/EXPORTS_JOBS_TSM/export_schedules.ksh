#!/bin/ksh -x 

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

