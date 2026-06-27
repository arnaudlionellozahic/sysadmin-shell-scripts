#!/bin/ksh
#set -v
#################################################
# But:
# cree des sauvegardes de la bases VTOM
#-----------------------------------------------
# Usage:
# $1 = Serveur qui contient la base a sauvegarder
# $2 = Repertoire cible sur le client
#-----------------------------------------------
# 
#-----------------------------------------------
# Gestion des fichiers
# Fichier Entree : $TOM_BASES/*
# Fichier Sortie : $rep_cible/*

#set -x

# Initialisation
rep_source=/opt/vtom
serveur_cible=$1
rep_cible=$2
TOM_REMOTE_SERVER=${serveur_cible}

echo "serveur cible : "${serveur_cible}
echo "lancement de la sauvegarde la base - vtbackup "

cmd_tbackup=`vtbackup -d -p $rep_cible /excludeHisto /excludeStats`
if [ "$?" -eq "0" ]
  then
    echo " lancement de la sauvegarde la base - vtbackup -> OK "
fi

rep_backup=`echo $cmd_tbackup | awk ' BEGIN { FS= " "} { print $4} ' | sed "s/'//g"  `
date=`echo $rep_backup | awk 'BEGIN { FS="/" } { print $NF}' `
base_backup=bases_${serveur_cible}_$date

cd $rep_backup
echo " repertoire : $rep_backup"
ls stat*
rm stat*
ls mess*
rm mess*
#ls hist*
#rm hist*

cd $rep_cible
mv $rep_backup $base_backup
echo "lancement du tar de la sauvegarde la base et compression $base_backup "
tar czf $base_backup.tar.gz $base_backup
if [ "$?" -eq "0" ]
  then
    #echo "suppression du repertoire $rep_cible/$base_backup"
    rm -r "$base_backup"
fi
