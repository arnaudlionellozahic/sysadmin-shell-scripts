#!/bin/ksh -x 

resources ()
{
cd ${REP}
ssh tws85@hades /maestro85/TWS/bin/composer extract ${FIC} from resource=@ << EOJ
quit
EOJ
scp tws85@hades:$FIC .
}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/EXPORTS
FIC=/tmp/all_resources.txt

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

resources

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
