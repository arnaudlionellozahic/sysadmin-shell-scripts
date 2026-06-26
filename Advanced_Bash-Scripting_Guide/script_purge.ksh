#!/bin/ksh
# Cas du lundi
if [ "$(date +%a)" == "Mon" ] || [ "$(date +%a)" == "Tue" ] ; then
        echo "TOTO à 3 jours"
else
	echo "TOTO à 1 jour" 
fi

