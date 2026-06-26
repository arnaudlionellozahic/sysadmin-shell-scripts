#
# MAJ PRojet Palier VTOM 5
#
# MAANDJIS 27/06/2011
# commande vtaddjob et vtaddmach
#

sleep 10


# On recupere la premiere ligne du fichier des machines a purger
MACHINE=`sed -n '1p' "${REP_PURGE_LOG}"/donnee/mac_actif_win.csv`

#On test si on est a la fin du fichier
if [ "${MACHINE}" = "fin" ]
then
/usr/users/pbytela/vtom_client/abm/bin/tval -name PURGE_WINDOWS -value FINI
	exit 0
else

# On associe la machine a l environnement maintenance
#vtaddmach /machine="${MACHINE}" /att_env=maintenance

# On passe le job de purge et celui de fin de purge A VENIR
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Purge_WINDOWS /Machine="${MACHINE}" /status=AV
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Re_Init_Purge2 /status=AV
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Err_Purge_WIN /status=AV


# On a termine pour ce job, on sort en exit 0
exit 0

fi