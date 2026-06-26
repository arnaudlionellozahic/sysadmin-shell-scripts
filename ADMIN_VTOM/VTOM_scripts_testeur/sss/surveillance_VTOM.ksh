#!/bin/ksh

#set -x

# ---------------------------------------------------------------------------------------------- #
# Objet         : Controle de l environnement VTOM 
# Auteur        : PL
# Date          : 27/10/2009
# Remarques     : 
#                
# Parametres	: 1=cycle en secondes
#		  2=repertoire destination 
# ---------------------------------------------------------------------------------------------- #


if [ $# -lt 2 ] ; then

	echo "Usage :"
	echo 
	echo "	Parametre 1 : cycle en secondes de collecte des informations du contexte"
	echo "	Parametre 2 : repertoire ou sont stockes les fichiers de collecte"
	echo 
	echo "Exemple : $0 300 /home2/vtom/traces &"
	echo 
	echo 
	exit 1
fi

Cycle=$1
DirDest=$2

if [ ! -d $DirDest ] ; then
	echo "Repertoire destination inexistant pour les fichiers de log"
	exit 1
fi


echo "___________________________________"
echo
echo "Surveillance de l'environnement VTOM sur `uname -n`"
echo "	Cycle de $Cycle secondes"
echo "	Repertoire destination des fichiers de collecte : $DirDest"
echo "___________________________________"
echo
echo "Ctrl C pour arreter ou Kill -9 du processus correspondant"

SquelNomFic=`basename $0|cut -d"." -f1`

Heure=0

FicTemp=${DirDest}/${SquelNomFic}.tmp

while true
do

echo 
echo "Cycle a `date '+%H:%M:%S'`"

if [ $Heure -eq 0 ] ; then
	Jour=`date '+%Y%m%d'`
	FicDest=${DirDest}/${Jour}_${SquelNomFic}
	echo "Surveillance environnement VTOM" > $FicDest

	echo >> $FicDest
	echo "##### Machine" >> $FicDest	
	uname -a >> $FicDest

	echo >> $FicDest
	echo "##### uptime" >> $FicDest
	echo >> $FicDest
	uptime >> $FicDest

	echo >> $FicDest
	echo "##### user connecte" >> $FicDest
	id >> $FicDest
	
fi

echo >> $FicDest
vtping >> $FicDest
echo >> $FicDest

ps -efo args,user,vsz > ${FicTemp} 2>/dev/null

if [ $? -eq 0 ] ; then
	echo "##### ps -efo args,user,vsz" >> $FicDest
	echo >> $FicDest	
	cat ${FicTemp} >> ${FicDest}
else

	echo "##### UNIX95= ps -o comm,sz,vsz,time,user,uid" >> $FicDest
	echo  >> $FicDest
	UNIX95= ps -o comm,sz,vsz,time,user,uid >> $FicDest
fi	

echo >> $FicDest

sleep $Cycle

Heure=`date '+%H'`

done

