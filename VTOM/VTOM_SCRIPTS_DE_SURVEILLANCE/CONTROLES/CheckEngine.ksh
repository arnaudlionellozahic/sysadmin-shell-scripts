#!/bin/ksh
export CheckTIMEOUT=90 #Delai en secondes
export RepLog=$TOM_HOME

cd $TOM_BASES

for ListePID in `ls *.pid`
do
#on recupere les valeurs de PID des moteurs stockes dans $TOM_BASES/env.pid
MonEnv=`echo $ListePID | cut -f1 -d"."`
MonIdEnv=`cat $MonEnv.pid`


#On recupere les PID des moteurs actifs
MonID=`ps -ef | grep tengine | grep $MonEnv | awk '{print $2}'`
#echo $MonEnv $MonID $ListePID $MonIdEnv

if [ ${MonIdEnv} == ${MonID} ] ; then
                        Now=`date +%H%M%S`
                        LastExec=`cat $RepLog/$MonEnv`
                        Delta=`expr $Now - $LastExec`
        else
        echo "PAS cool je suis KO"
fi
#Verification du delai entre deux soumissions par environnement
if [ $Delta -gt $CheckTIMEOUT ] ; then
        #Cas problematique
        echo "ALERTE  pour  $MonEnv a $Now"
        echo $MonEnv $MonID $ListePID $MonIdEnv $HOST
else
        # RAS
        echo "Tout va bien pour $MonEnv a $Now!!"
fi

done
