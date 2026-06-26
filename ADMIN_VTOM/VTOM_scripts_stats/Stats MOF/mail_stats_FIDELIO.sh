#!/bin/ksh
#
# script de compression d'un fichier et envoi par mail via sunopsis
# Auteur: 
# Date creation : 27-07-2010 
# Date MAJ : 27-07-2010 
# Version : 1.0
#
# Parametres:
#		$1 : chemin du fichier a compresser et envoyer
#		$2 : adresse destinataire
#		$3 : adresse emetteur
#
########################################################################
set -x

DATE=`date +"%d-%m-%Y"`;
EXT_FICHIER="/produit/vtom/v46/stats/FIDELIO_$DATE.csv";
EXT_MAIL_TO="arnaud.lozahic@mondial-assistance.fr,svc-exploit@mondial-assistance.fr";
EXT_MAIL_FROM="svc-exploit@mondial-assistance.fr"

cd /produit/vtom/v46/scripts/exploitation

if [ "$EXT_FICHIER" != "" ]
then
#	. $ENV_APPLI/param/.env_stats_$1;

	stats_FIDELIO.sh $DATE > /produit/vtom/v46/stats/FIDELIO_$DATE.csv";
	NB_LIGNES=`cat ${EXT_FICHIER} | wc -l | awk '{print( substr ( $1,0,5 ));}'`;
 
	if [ $? -eq 0 ]
	then
		/usr/local/bin/sendmime.sh -s "Statistiques FIDELIO" -t "Bonjour, nous somme le $DATE. Vous trouverez ci joint la liste des statistiques d'exécutions des traitements de la chaîne FIDELIO du $DATE. Le fichier contient $NB_LIGNES lignes. En cas de probleme, contacter svc-exploit@mondial-assistance.fr. Bonne reception." -f $EXT_MAIL_FROM $EXT_MAIL_TO $EXT_FICHIER

                if [ $? -eq 0 ]
                then
                echo "le fichier $EXT_FICHIER a bien ete envoye a ${EXT_MAIL_TO}";
		gzip -9 $EXT_FICHIER;
                exit ;

                else
			echo "pas de fichier passe en parametre";
			exit1;
		fi
	fi

fi

