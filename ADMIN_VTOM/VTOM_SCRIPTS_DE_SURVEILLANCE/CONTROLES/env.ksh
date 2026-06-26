#! /bin/ksh

echo "mes environnements actifs sont"
#On recupere la liste des environnements actifs
cd $TOM_BASES
for env in `ls *.pid`
do
actif=`echo $env | cut -f1 -d"."`

#On recupere les PID des moteurs actifs
pid=`ps -ef | grep tengine | grep $actif | awk '{print $2}'`
echo $actif $pid
done

