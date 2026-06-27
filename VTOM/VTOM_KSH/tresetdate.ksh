#!/bin/ksh

datejour=`date '+%d-%m-%Y'`
for d in `tlist date`
     do
	echo "vtadddate /name=$d /valeur=${datejour}"
	vtadddate /name=$d /valeur=${datejour}
done

>trace_tresetout.txt
for Envs in `tlist env/date | cut -f1 -d " "| sort -u`
do
	echo "Environnement : "$Envs 
	for Dates in `tlist env/date | grep $Envs | cut -b18-36`
	do
		echo "treset $Envs $Dates"
		resultat=`treset $Envs $Dates`
		echo $resultat
		if [ `echo $resultat | grep -c inexistante` -eq 0 ]
		then
			statut=`echo $resultat|awk -F":" '{print $2}'`
			echo "treset $e $d => $statut" >> trace_tresetout.txt
		fi
	done
done

echo " "
echo " "

echo "Presence de KO : "

grep "KO" trace_tresetout.txt
echo " "
