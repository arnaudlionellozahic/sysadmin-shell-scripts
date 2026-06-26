# MAJ Projet VTOM 5
#
# MAANDJIS 27/06/2011
# commande vtaddjob
#
#####################"

vtaddjob /Nom=SUPERVISIONS/Purge_Log/Init_Purge_WIN /status=AV

#----------------------------------------------------------------
# On efface la premiere ligne du fichier des machines a purger
#----------------------------------------------------------------

sed '1d' "${REP_PURGE_LOG}"/donnee/mac_actif_win.csv > "${REP_PURGE_LOG}"/donnee/mac_actif_win.csv.tmp
cp "${REP_PURGE_LOG}"/donnee/mac_actif_win.csv.tmp "${REP_PURGE_LOG}"/donnee/mac_actif_win.csv