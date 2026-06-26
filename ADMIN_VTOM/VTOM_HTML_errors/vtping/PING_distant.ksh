#!/bin/ksh

set -xv

cd /exploit/systeme/suivi/vtping

tlist machines | grep -v k5* | grep -v aid2* | grep -v siebel* > liste_machine.lis

list=`cat liste_machine.lis`
for i in $list
do
tremote /machine=$i vtping
done

list2=`cat list_machine.lis`
for u in $list2
do
cat $u | grep bdaemon | grep arret > $u
done

cat $list2 > count

rm *.out
rm *.err

vt_bdaemon=$(cat count)

if [ "$vt_bdaemon" != "" ]
then
  /bin/mailx -s "Surveillance des process bdaemon" arnaud.lozahic@mondial-assistance.fr < count
else
 echo "process vt_bdaemon OK"
fi
