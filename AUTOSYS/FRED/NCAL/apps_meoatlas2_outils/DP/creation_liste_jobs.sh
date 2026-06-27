#!/bin/sh
#
# CREATION DE LA LISTE Jobset:Jobs
#
# Auteur : PETITPRE
#
# Date : 14-09-2012
#
# Principe : cree la liste de jobsets:Jobs dans le fichier liste_jobs.lst
#          : sauvegarde l'ancienne
#
#

export DATE=$(date +"%d-%m-%Y")
mv liste_jobs.lst liste_jobs.lst_${DATE}

echo "\n CREATION DE LA LISTE DES JOBSETS ET JOBS ... \n"

for i in $(echo $(cautil li jobset id=* | grep -e Jobset: | awk '{print $NF}' | grep -v DYNAMIC ))
do
 for j in $(cautil li job id=${i},*,01 | grep Job: | grep -v Cyc | awk ' {print $NF}')
 do
 echo "${i}:${j}" >> liste_jobs.lst
 done
done

echo "FICHIER liste_jobs.lst CREE ..."

#-----------------------------------------------------------------------------------------------------
# split de la liste en plusieurs parties pour pouvoir creer des DP de taille acceptable 
#-----------------------------------------------------------------------------------------------------

split liste_jobs.lst liste_jobs.lst_

echo "Le fichier liste_jobs.lst a ete splite en $(ls -1 liste_jobs.lst_a* | wc -l) fichiers : "
echo "$(ls liste_jobs.lst_a*)"


