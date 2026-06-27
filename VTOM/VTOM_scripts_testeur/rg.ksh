#!/bin/ksh

sortie=`cat /home2/plair/scripts/bidule.txt|wc -l`
echo $sortie > /home2/plair/scripts/rgr.txt
exit $sortie

