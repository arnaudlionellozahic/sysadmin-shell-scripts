#!/bin/sh
#
# Auteur        : ALOZAHIC
# Date          : 28/10/2015
#
# Principe      : envoi du fichier /apps/arch/imp-0/parva*_stat vers les gens demandeurs
#
#
# Fréquence     : lancé en crontab tous les jours même fériés
#
#
#************************************************************************

function envoi_cft
{
if [ -s ${FICHIER_RAPPORT} ]; then
   echo "Le fichier ${FICHIER_RAPPORT} existe et n'est pas vide"
   su - cft -c cftutil send part=MF247000, fname=${FICHIER_RAPPORT}, idf=CALREP01, parm=${FICHIER}
       else 
       echo "Le fichier ${FICHIER_RAPPORT} est vide ou n'existe pas" 
       echo "exit 1"
       exit 1 	
fi
}

####### Main #######
export LANG=C
machine=$(hostname)
DATE=$(date +"%Y%m%d")
export FICHIER_RAPPORT=$(ls -ltr /apps/arch/imp-0/${machine}_stat* | grep -v txt|tail -1|awk '{print $NF}')
export FICHIER=$(ls -1 /apps/arch/imp-0/${machine}_stat* | grep -v txt|tail -1|awk -F"/" '{print $5}')
export LOG="/apps/meoatlas2/outils/ASPOM/log.txt"

# Envoi du rapport par cft
envoi_cft > $LOG

