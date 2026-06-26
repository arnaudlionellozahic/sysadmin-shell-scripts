vtaddjob /Nom=SUPERVISIONS/Purge_Log/Init_Purge_UNIX /status=AV


# On efface la premiere ligne du fichier des machines a purger
sed '1d' "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv > "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv.tmp
cp "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv.tmp "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv

