sleep 10

set +x

DATE=`date '+%d/%m/%y %H:%M:%S'`

# On recupere la premiere ligne du fichier des machines a purger
MACHINE=`sed -n '1p' "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv`

echo " $DATE : $MACHINE " >> "${REP_PURGE_LOG}"/donnee/horaires.csv

#On test si on est a la fin du fichier
if [ "${MACHINE}" = "fin" ]
then
/usr/users/pbytela/vtom_client/abm/bin/tval -name PURGE_UNIX -value FINI
	exit 0
else

# On associe la machine a l environnement SUPERVISIONS
#vtaddmach /machine="${MACHINE}" /att_env=SUPERVISIONS

# On passe le job de purge et celui de fin de purge A VENIR
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Purge_UNIX /Machine="${MACHINE}" /status=AV
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Re_Init_Purge1 /status=AV
vtaddjob /Nom=SUPERVISIONS/Purge_Log/Err_Purge_UNIX /status=AV


# On a termine pour ce job, on sort en exit 0
exit 0

fi

