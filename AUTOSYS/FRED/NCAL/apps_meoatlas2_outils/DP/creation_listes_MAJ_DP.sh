#!/bin/sh
#
# Auteur     : PETITPRE  (PARIS IPS MEO IRB)
# Date       : 23-12-2013
#
# Principe   : Genere les listes  jobset:job  a supprimer de l'AEL et à ajouter à l'AEL
#            : Lancer, après ce script, le script generate_MAJ_DP.sh pour genere le .htm a soumettre dans l'AEL
#
#
# Prerequis  : Avoir dans le répertoire de lancement les .htm de l'extraction AEL
#            : Ainsi que le fichier de liste de jobs de la machine
#            : Connaitre les lanceurs utilisés sur cette machine
#
#
# Output     : liste des jobset:job a supprimmer
#            : liste des jobsets:job a ajouter
#
# ATTENTION  : Verifier ces listes en output car les extractions AEL peuvent changer d'un site à l'autre
#
#*****************************************************************************************************************

# Variables

#export SITE=$(host $HOST | awk '{print $NF}' | cut -c3-6)
export SITE=cald
export SUFF_LANCEUR=$(echo ${SITE} | awk '{ print toupper(substr($0,0,1)) substr($0,2) }')

# check extraction JOBS

if [[ -z liste_jobs.lst ]] then
echo "ERREUR : fichier liste_jobs.lst absent"
echo "Veuillez générer la liste des jobs en base NSM"
echo "en executant le script creation_liste_jobs.sh\n"
exit 1
fi

echo "liste_jobs.lst présent"


# sauvegarde de l'ancienne liste AEL
export DATE=$(date +"%Y%m%d.%H%M")
mv AEL_list.lst AEL_list.lst.$DATE >/dev/null 2>/dev/null
mv Alertes_a_supprimer.lst Alertes_a_supprimer.lst.$DATE >/dev/null 2>/dev/null
mv Alertes_a_ajouter.lst Alertes_a_ajouter.lst.$DATE >/dev/null 2>/dev/null

# liste des fichiers d'extraction AEL :

echo "Voici la liste des fichiers d'extraction AEL qui seront pris en compte :\n"
ls produit*htm
echo "\nVeuillez confirmer (y/n) :"
read CONFIRM
export LIST_AEL=$(ls produit*htm)

if [[ $CONFIRM != 'y' ]]
then
echo "Sortie du script"
echo "Les fichiers pris en compte sont tous ceux du type \"produit*htm\"\n"
exit 2
fi

# Confirmation des lanceurs utilises sur cette machine

echo "\nATTENTION :"
echo "La liste des lanceurs pris en compte dans ce script est lance_${SUFF_LANCEUR} et lance_Bkof"
echo "Il faut modifier ce script si des lanceurs supplementaires sont a prendre en compte\n"
echo "Souhaitez-vous continuer ? (y/n)\n"
read CONTINUE
if [[ $CONTINUE != 'y' ]]
then
echo "Sortie du script"
echo "Modifiez dans ce script les lignes ou vous trouvez le mot Bkof  (2 lignes)\n"
exit 3
fi

# concaténation des fichiers de l'extraction AEL

cat $LIST_AEL > AEL_actuel

# creation de la liste des jobsets/jobs présents dans l'AEL
echo "Creation de la liste des jobsets/jobs présents dans l'AEL"

awk -F'>|<' '/Alerte:/ {print $0}' AEL_actuel > list_1
awk -F'CASH_I_0062_|</div' '{print $2}' list_1 > list_2
sed -e s/\]\_/:/g -e s/\\\[//g -e s/\]//g list_2 > AEL_list.tmp
cat AEL_list.tmp | tr 'A-Z' 'a-z' |awk -F_ '{print $1":"$2}' | awk -F: '{print $1":"$2}' | sed -e 's/'${SITE}'/'${SUFF_LANCEUR}'/g' -e 's/bkof/Bkof/g' > AEL_list.tmp1

cat AEL_list.tmp1 | grep -v -e jbcv1 -e jbcv2 -e jclone1 -e jclone2 -e j9sa >  AEL_list.lst

rm -f AEL_list.tmp*


# Detection des alertes actuellement dans l'AEL mais absente de la base NSM
echo "Detection des alertes actuellement dans l'AEL mais absente de la base NSM ... "

for i in $(cat AEL_list.lst)
do
grep -q $i liste_jobs.lst

if [[ $? -ne 0 ]] then
echo "${i}" >> Alertes_a_supprimer.lst
fi

done


# Detection des jobs en base NSM mais non présents dans l'AEL
echo "Detection des jobs en base NSM mais non présents dans l'AEL ... "


for i in $(cat liste_jobs.lst)
do
grep -q $i AEL_list.lst

if [[ $? -ne 0 ]] then
echo "${i}" >> Alertes_a_ajouter.lst
fi

done


rm -f liste_1 liste_2 liste_3 AEL_actuel

echo "\n***************************************************************************************************\n"
echo "Les fichiers suivants ont été créés :\nAlertes_a_supprimer.lst Alertes_a_ajouter.lst"
echo "-> Veuillez supprimer de l'AEL les alertes correspondantes au fichier Alertes_a_supprimer.lst"
echo "-> Veuillez exécuter le script generate_MAJ_DP.sh après check rapide du fichier Alertes_a_ajouter.lst"
echo "\n**************************************************************************************************\n"



