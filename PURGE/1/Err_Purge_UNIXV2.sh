#on recupere la premiere ligne du fichier des machines a purger

MACHINE=`sed -n '1p' "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv`


echo "$MACHINE (Unix)" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt

vtaddjob /Nom=SUPERVISIONS/Purge_Log/Init_Purge_UNIX /status=AV


# On efface la premiere ligne du fichier des machines a purger
sed '1d' "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv > "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv.tmp
cp "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv.tmp "${REP_PURGE_LOG}"/donnee/mac_actif_unix.csv
