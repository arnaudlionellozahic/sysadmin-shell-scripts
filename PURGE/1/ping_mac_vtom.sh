# MAJ Projet Palier VTOM 5
# MAANDJIS - 27/06/2011
# MAJ commande vtping par vtmachine
#

# purge/sauvegarde des fichiers temporaires
cp "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt.sav
>"${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
cp "${REP_PURGE_LOG}"/donnee/horaires.csv "${REP_PURGE_LOG}"/donnee/horaires.csv.sav
>"${REP_PURGE_LOG}"/donnee/horaires.csv

# creation du fichier vtmachine
# on supprime les lignes inutiles du vtmachine + on trie le fichier sortant pour eliminer les doublons en se basant sur l'adresse IP
echo "creation du fichier ++++++ result_vtmachine.txt"
vtmachine | grep -v "+-----" | grep -v "Logical Name" | grep -v "client on." | awk -F"|" ' { gsub(/ /,"",$2); gsub(/ /,"",$4); gsub(/ /,"",$6); print $4";"$2";"$5";"$6 } ' | sort > result_vtmachine.txt.tmp

# on elimine les doublons
awk -F";" ' {
	if ( $1 != IP ) { IP=$1; print $0 }
	if ( $4 == "" ) { print $0"unknown" }
	} ' result_vtmachine.txt.tmp > result_vtmachine.txt

# on liste les doublons dans un fichier pour la maintenance
echo "Liste des serveurs en doublons :" > "${REP_PURGE_LOG}"/donnee/doublons_retires_de_la_purge.txt
awk -F";" ' {
	if ( $1 == IP ) { print $2 }
	if ( $1 != IP ) { IP=$1 }
	} ' result_vtmachine.txt.tmp > "${REP_PURGE_LOG}"/donnee/doublons_retires_de_la_purge.txt

#-------------------------------------------------------
#  On recupere la liste des machines UNIX actives
#-------------------------------------------------------
#La variable REP_PURGE_LOG est difinie dans le .profile
#-------------------------------------------------------

cat result_vtmachine.txt | grep Running | egrep -i "Linux|SunOS|AIX|HP-UX|OSF1" | sort -u | cut -d ";" -f 2 > mac_actif_unix.csv

#-------------------------------------------------------
# En cas d'exception, rajouter la machine ci-dessous
#-------------------------------------------------------
# Serveurs a supprimer :
egrep -v "bt1shs03v11" mac_actif_unix.csv > mac_actif_unix.tmp; mv mac_actif_unix.tmp mac_actif_unix.csv
#egrep -v "bt1svky2|bt1svky3" mac_actif_unix.csv > mac_actif_unix.tmp; mv mac_actif_unix.tmp mac_actif_unix.csv
# Serveurs a ajouter :
echo "bt1sia1fv2" >> mac_actif_unix.csv
#echo "bt1shl2u" >> mac_actif_unix.csv

echo "fin" >> mac_actif_unix.csv

mv mac_actif_unix.csv "${REP_PURGE_LOG}"/donnee/

#------------------------------------------------------
#  On recupere la liste des machines Windows actives
#------------------------------------------------------

cat result_vtmachine.txt | grep Running | grep -i Win | sort -u | cut -d ";" -f 2 > mac_actif_win.csv

#-------------------------------------------------------
# En cas d'exception, rajouter la machine ci-dessous
#-------------------------------------------------------
# Serveurs a supprimer :
#egrep -v "bt1shl2u" mac_actif_win.csv > mac_actif_win.tmp; mv mac_actif_win.tmp mac_actif_win.csv
egrep -v "bt1sqkpr" mac_actif_win.csv > mac_actif_win.tmp; mv mac_actif_win.tmp mac_actif_win.csv
# Serveurs a ajouter :
echo "bt1sqkps"  >> mac_actif_win.csv
# echo "bt1fstedi01"  >> mac_actif_win.csv

echo "fin" >> mac_actif_win.csv

mv mac_actif_win.csv "${REP_PURGE_LOG}"/donnee/

#-----------------------------------------------------
# On purge et supprime les fichiers temporaires
#-----------------------------------------------------

#rm result_vtmachine.csv result_vtmachine.csv 
rm result_vtmachine.txt.tmp

#-----------------------------------------------------
# On cree le fichier de rapport envoye par mail
#-----------------------------------------------------
echo "Pour information, liste des serveurs dans les exceptions :" > "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
echo "UNIX : (-)bt1shs03v11 (+)bt1sia1fv2" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
echo "Windows : (-)bt1sqkpr (+)bt1sqkps" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
echo "" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt

echo "Liste des serveurs qui ne repondent pas :" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
cat result_vtmachine.txt | egrep -v "Running|------|client on|Logical Name|bt1tmp|bt1poub" | sort -u | cut -d ";" --output-delimiter=": " -f 2,3 >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
echo "" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt

echo "Liste des serveurs avec un OS inconnu :" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
cat result_vtmachine.txt | grep -i unknown | grep -v bt1poub | grep -v bt1tmp | cut -d ";" --output-delimiter=": " -f 2,4 >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt

echo "" >> "${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt
echo "Liste des serveurs sur lesquels la purge applicative n'a pas fonctionne :" >>"${REP_PURGE_LOG}"/donnee/machine_en_erreur.txt

#rm result_vtmachine.txt

exit 0
