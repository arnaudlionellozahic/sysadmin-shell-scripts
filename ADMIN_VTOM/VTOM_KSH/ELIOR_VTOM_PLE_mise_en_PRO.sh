#**********************************************************************************************
#nom:			ELIOR_VTOM_mise_en_PRO.sh
#description:	Mise en production d'une application ou d'un groupe d'application
#version:		1.1
#date MAJ:		16/05/2007
#createur:		Francois FURSTOSS
#modifie par           Alexandre AUDOUX 
#modifie par           Farid FOUGHAR (correction application en simu au lieu des jobs)
#date MAJ:		13/09/2007
#modifie par           Farid FOUGHAR (remplacement du nom d'environnement recette PLEREC par PLEREC)
#date MAJ:              18/02/2009
#modifie par            O.WALCH (retire l'option -f car vtimport ne l'accepte plus)
#
#parametres:	application ou groupe d'application
#codes retour:	0: OK
#				1: ERREUR
#fichiers créés:	Fichier mep_APPLI_DATE.imp dans le répertoire /vtom/import/
#
#                                      
#**********************************************************************************************

#set -x

NB_APPLIS=$#

if [ ${NB_APPLIS} -eq "" ] ; then
   echo "ATTENTION : il n y a pas de nom d application ou traitement VTOM en parametre ; Veuillez verifier avant de relancer"
   exit 1
fi

LIST_APPLIS=$*

for NOM_APPLI in $LIST_APPLIS
do
	echo "Application mise en production: $1" 
	DATE_MEP=`date +%y%m%d%H%M%S`   
	TOM_REMOTE_SERVER=sipp1ple ; export TOM_REMOTE_SERVER 

	# Construction de la liste des applications récupérée dans l'environnement correspondant au paramètre entré
	# exemple : tlist app | grep PLEREC | grep MEPFMR | awk -F" " '{print $1"/"$2;}'

	APPLIS_MEP=$(tlist app | grep PLEREC | grep "$NOM_APPLI " | awk -F" " '{print $1"/"$2;}' )

	# Construction de la liste des resources utilisées par les applications de la liste précédente
	# exemple : tlist apps_res | grep PLEREC | grep MEPFMR | awk -F" " '{print $5}' | uniq 
	# exemple : tlist jobs_res | grep PLEREC | grep MEPFMR | awk -F" " '{print $5}' | uniq

	RES_APPLIS_MEP=$(tlist apps_res | grep PLEREC | grep "$NOM_APPLI " | awk -F" " '{print $5}' | uniq)

	RES_JOBS_APPLIS=$(tlist jobs_res | grep PLEREC | grep "$NOM_APPLI " | awk -F" " '{print $5}' | uniq)

	echo "*****************RESOURCES***APPLIS***UTILISEES"
	echo $RES_APPLIS_MEP 
	print "*****************RESOURCES***JOBS***UTILISEES"
	echo $RES_JOBS_APPLIS 

	###### SUR LE SERVEUR DE PRODUCTION
	TOM_REMOTE_SERVER=localhost ; export TOM_REMOTE_SERVER

	# Status des applications à mettre à jour dans PRO

	APPLIS_STATUS=$(tlist apps_status | grep PLEPRO | grep "$NOM_APPLI " | awk -F" " '{print $3}')

	# Test si une APPLI est en cours dans PRO

	for I in $APPLIS_STATUS
	do
		if [ "$I" = "EN_COURS" ]
		then
			echo "ERREUR: au moins une application est en cours d'execution"
			exit 1
		fi
	done
	 
	# MISE EN PROD DES APPLICATION

	for I in $APPLIS_MEP
	do
		APPLI=$(print $I | awk -F"/" '{print $2}')

                # alimentation log specifique
		date "+%Y%m%d %H%M%S PLEPRO $APPLI" >>/vtom/ADMPRO_MEP.log

		###### SUR LE SERVEUR DE RECETTE
		TOM_REMOTE_SERVER=sipp1ple ; export TOM_REMOTE_SERVER

		# Export de l'application $I
		echo " export de l'application $APPLI "
		vtexport -f $I > /tmp/vtom_export_$APPLI.tmp

		# Transformation du fichier

		#sed s/PLEREC/PLEPRO/g /tmp/vtom_export_$APPLI.tmp | sed s/CALREC/CALPRO/g | sed s/RREC/RPRO/g | sed s/pngrec/pngpro/g | sed s/\\/pngrec\\/gta/\\/gtapro/g |  sed s/gtarec/gtapro/g | sed s/QPL/PPL/g | sed s/mode=simu/mode=exec/g | sed s/SAPREC/SAPPRO/g | sed s/WINREC/WINPRO/g | sed s/DECREC/DECPRO/g  > /vtom/import/mep_${APPLI}_${DATE_MEP}.imp

		## AJOUT sed pour dedoublement caractere \
		sed s/PLEREC/PLEPRO/g /tmp/vtom_export_$APPLI.tmp | sed s/CALREC/CALPRO/g | sed s/RREC/RPRO/g | sed s/pngrec/pngpro/g | sed s/\\/pngrec\\/gta/\\/gtapro/g |  sed s/gtarec/gtapro/g | sed s/QPL/PPL/g | sed s/mode=simu/mode=exec/g | sed s/SAPREC/SAPPRO/g | sed s/WINREC/WINPRO/g | sed s/DECREC/DECPRO/g  > /vtom/import/mep_${APPLI}_${DATE_MEP}.imp

		# Suppression du fichier export        

		rm -f /tmp/vtom_export_$APPLI.tmp;




		###### SUR LE SERVEUR DE PRODUCTION
		TOM_REMOTE_SERVER=localhost ; export TOM_REMOTE_SERVER

		# Sauvegarde et suppression de l'application en PRO

		if [ ! -d  /vtom/backup/mep ]
		then
		mkdir -p  /vtom/backup/mep
		fi

		vtexport -f PLEPRO/$APPLI > /vtom/backup/mep/save_mep_${APPLI}_${DATE_MEP}.exp

		vtdelapp -a $APPLI -e PLEPRO

		# Importation du fichier transformé

		vtimport -f /vtom/import/mep_${APPLI}_${DATE_MEP}.imp
		vtaddapp /Nom=PLEPRO/$APPLI /Mode=simu


	done

done

vtaddmach /machine=PLEIADES-PTA /nom_reel=pr3ple
vtaddmach /machine=PLEIADES-NG /nom_reel=pr2ple
vtaddmach /machine=PLEIADES-BD /nom_reel=pr1ple
vtaddmach /machine=SERV-CLONE /nom_reel=pr1bck
vtaddmach /machine=SERV-BCK /nom_reel=sipr2bck
vtaddmach /machine=PLEWEB1 /nom_reel=si-pr1-ple-tom
vtaddmach /machine=PLEWEB2 /nom_reel=si-pr2-ple-tom
vtaddmach /machine=PLEWEB3 /nom_reel=si-pr3-ple-tom
vtaddmach /machine=PLEWEB4 /nom_reel=si-pr4-ple-tom
vtaddmach /machine=PLEWEB5 /nom_reel=si-pr5-ple-tom
vtaddmach /machine=PLEWEB6 /nom_reel=si-pr6-ple-tom
vtaddmach /machine=PLEWEB7 /nom_reel=si-pr7-ple-tom
vtaddmach /machine=PLEWEB8 /nom_reel=si-pr8-ple-tom

exit 0

