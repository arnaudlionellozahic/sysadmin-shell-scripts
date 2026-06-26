#!/bin/ksh
#
# script de compression d'un fichier et envoi par mail via sunopsis
# Auteur: 
# Date creation : 27-07-2010 
# Date MAJ : 27-07-2010 
# Version : 1.0
#
# Parametres:
#		$1 : date à J-1
#		$2 : chemin du fichier de filtre
#		$3 : nom du fichier
#       $4 : adresse destinataire  
#       $5 : adresse emetteur  
#
########################################################################
set -x

DATE=$1

STATS_FILE=$TOM_STATS/$(echo $DATE|sed 's/\(..\)-\(..\)-\(....\)/\3-\2-\1/').csv
echo $STATS_FILE


                if [ $? -eq 0 ]
                then
				gzip -9 $STATS_FILE;
                echo "le fichier $STATS_FILE a bien ete archive";
                exit $?;

                else
			echo "une erreur s'est produite lors de l'archivage du fichier $STATS_FILE";
			exit 1;
		fi
