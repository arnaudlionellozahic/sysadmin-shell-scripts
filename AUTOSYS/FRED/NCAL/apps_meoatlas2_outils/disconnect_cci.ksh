#!/usr/bin/ksh
. /usr/bin/EnvironnementEM
ccinet status
for i in $(ccinet status | grep -ie PARW -ie BDSW -ie PARX -ie BDSL -ie NOUW | awk '{print $1}')
do
ccinet disconnect $i
done
ccinet status
ps -ef | grep staruserpgm | grep -v grep
RC=$?
if [[ $RC -ne 0 ]]
then
        echo "rien a faire au niveau de staruserpgm"
else
        echo "kill des staruserpgm"
        ps -ef | grep staruserpgm | grep -v grep | awk '{print $2}' | xargs kill -9
fi


