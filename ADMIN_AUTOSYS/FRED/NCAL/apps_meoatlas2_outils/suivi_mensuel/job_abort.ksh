#/usr/bin/ksh
rm /tmp/suivi_mensuel_abort.txt
. /usr/bin/EnvironnementTNG

cautil select tjob id=*,*,* runstat=ABORT list 2>/tmp/mensuel.err.lst |grep -E "Jobset:|Job:|Status|Jno:" |grep -vE  "Ac|Calendar" > /tmp/suivi_mensuel_abort.txt

ligne=''
j=0
echo Jobs en Abort
echo "============================================="
for i in `cat /tmp/suivi_mensuel_abort.txt`
do
jobset=`echo $i |cut -c1-7`
if [[ $jobset = 'Jobset:' && $j != '0' ]] then
echo $ligne
ligne=''
ligne=$ligne"    "$i
else
j=1
ligne=$ligne"    "$i
fi
done
echo $ligne
echo ''

echo Jobs en Start
echo "============================================="
cautil select tjob  runstat=START list 2>/tmp/mensuel.err.lst |grep -E "Jobset:|Job:|Jno:" |grep -v Actual >/tmp/suivi_mensuel_abort.txt
ligne=''
k=0
for i in `cat /tmp/suivi_mensuel_abort.txt`
do
jobset=`echo $i |cut -c1-7`
if [[ $jobset = 'Jobset:' && $k != '0' ]] then
echo $ligne
ligne=''
ligne=$ligne"    "$i
else
k=1
ligne=$ligne"    "$i
fi
done
echo $ligne
echo ''

