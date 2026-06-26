#!/bin/ksh

set -xv

cd /exploit/systeme/suivi/tremote_surveildf

rm -f *.out 

tlist machines | grep -v k5* | grep -v aid2* | grep -v siebel* > liste_machine.lis

list=`cat liste_machine.lis`
for i in $list
do
tremote /machine=$i tlist env 
done

#rm -f *.out
rm -f *.err

cat *.out >/exploit/systeme/suivi/tremote_surveildf/toto

#if [ "$vt_bdaemon" != "" ]
#then
#  /bin/mailx -s "Surveillance des process bdaemon" arnaud.lozahic@mondial-assistance.fr < count
#else
# echo "process vt_bdaemon OK"
#fi
