#!/bin/ksh
#################################################
# But:
# cree des exports a distance
#-----------------------------------------------
# Usage:
# $1 = Serveur qui contient la base a sauvegarder
# $2 = Repertoire cible sur le client
#-----------------------------------------------
# Date de Modification:
# Creation ??/??/????
# Modif
#
#
#-----------------------------------------------
# Gestion des fichiers
# Fichier Entree :
# Fichier Sortie :
# Fichiers Temporaires :
#
################################################

#set -x
#env
# Initialisation

serveur_cible=$1
rep_cible=$2
code_retour=0
TOM_REMOTE_SERVER=${serveur_cible}
NOW=`date +"%d%m%Y_%H%M%S"`
export TOM_REMOTE_SERVER

echo "serveur cible : "${serveur_cible}

# Sauvegarde complete la base VTOM par vtexport

fichier_export=${rep_cible}/VTOM_BASE_${serveur_cible}_$NOW.exp

vtexport > $fichier_export
if [ ! "$?" = 0 ]
then
        code_retour=1
        echo "l export de la base ou un environnement est nok"
else
        print "vtexport $fichier_export\t [OK]"
        chmod 700 $fichier_export
fi

# Sauvegarde par environnement

for i in `tlist env`
do
echo    "fichier_export=${rep_cible}/${i}_${serveur_cible}_`date +"%Y%m%d_%H%M%S"`.exp"
        fichier_export=${rep_cible}/${i}_${serveur_cible}_`date +"%d%m%Y_%H%M%S"`.exp
        vtexport -f $i > $fichier_export
        if [ ! "$?" = 0 ]
        then
                code_retour=1
                echo "l export de l environnement $i est nok"
        else
                print "vtexport $fichier_export\t [OK]"
                chmod 700 $fichier_export
        fi
done

exit $code_retour
