#!/bin/ksh -x 

cpu_list ()
{
ssh tws85@hades /maestro85/TWS/bin/conman "sc\;link" << EOJ> ${FIC}
quit
EOJ
gawk -i inplace -v INPLACE_SUFFIX=.bak '{print $6}' ${FIC}
cat ${FIC} | egrep -v "ARIANE|M1_TEREE|PPW0-CRM-01|PPW0-CRM-02|ULYSSE" > ${FIC_UNIX}
gawk -i inplace '$0' ${FIC} ${FIC_UNIX}
}

# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/EXPORTS
FIC=${REP}/cpus_list_all.txt
FIC_UNIX=${REP}/cpus_list_unix.txt

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

cpu_list

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
