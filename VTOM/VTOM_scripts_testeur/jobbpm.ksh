#!/bin/ksh

if [ $# -eq 0 ] ; then
	duree=30
	ctrl_name="ctrl_name_inconnu"
	ctrl_title=""
	ctrl_indice=$$
else
	if [ $# -eq 1 ] ; then
		duree=$1
		ctrl_name="ctrl_name_inconnu"
		ctrl_title=""
		ctrl_indice=$$
	else

		duree=$1
		ctrl_name=$2
		ctrl_title=$3
		ctrl_indice=$4
	fi
fi

fic_resul=/home4/plair/SOLARIS/bpm/resultats/${ctrl_name}_${ctrl_indice}.txt

echo $duree > $fic_resul


i=0

while true
do
date '+%T'|tee -a $fic_resul
sleep 1
i=`expr $i + 1`
if [ $i -eq $duree ] ; then
	break
fi

done


