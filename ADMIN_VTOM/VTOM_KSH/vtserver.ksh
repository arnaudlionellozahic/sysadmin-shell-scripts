CEDRIC

#bin/ksh
RELEVE_TEMP=/home4/jmletel/mon_top
top -d 1 -n 50 -f $RELEVE_TEMP 
grep $TOM_USER_ADMIN $RELEVE_TEMP | grep vtserver >$TOM_HOME/`date +%y%m%d_%H%M%S`_releve.txt
# PURGE du fichier temporaire de releve
echo >$RELEVE_TEMP

----------------------------------------------------------------------------------------------------
DOMI

if [ -f /root/ALAIN/top_j_tc-intergo.tmp ] 
then 
 echo  "fichier present" 
else 
 touch /root/ALAIN/top_j_tc-intergo.tmp 
 echo  "  PID USER PR NI VIRT RES   SHR S %CPU %MEM TIME+ COMMAND" >>/root/ALAIN/top_j_tc-intergo.tmp 
fi 
ligne=$(ssh  lgqev13 top -b -d 1  -n 1 | grep j_tc-intergeo) 
echo $ligne $dt >>/root/ALAIN/top_j_tc-intergo.tmp 

-----------------------------------------------------------------------------------------------------

ARNAUD

#!/bin/ksh
TOP=/home4/alozahic/exploit/systeme/suivi/ABSYSS/TOP/top.tmp
if [ -f $TOP ]
then
 echo  "fichier present"
else
 touch $TOP
 echo  "  PID USER PR NI VIRT RES   SHR S %CPU %MEM TIME+ COMMAND" >>$TOP
fi
#ligne=$(ssh  savigny top -b -d 1  -n 1 | grep vtserver)
#ligne=top -b -d 1  -n 1 | grep vtserver
top -b -d 1  -n 1 | grep vtserver >> $TOP
#echo $ligne $dt >>$TOP

----------------------------------------------------------------------------------------------------

DOMI


#!/bin/ksh 
TOP=/home4/alozahic/exploit/systeme/suivi/ABSYSS/TOP/top.csv 
if [ -f $TOP ] 
then 
 echo  "fichier present" 
else 
 touch $TOP 
 echo  "PID;USER;PR;NI; VIRT; RES ;  SHR; S ;%CPU ;%MEM ;TIME+ ;COMMAND" >$TOP 
fi 
top -b -d 1 -n 1 | grep vtserver | tr -s " " | sed 's/ /;/g' >> $TOP 

-------------------------------------------------------------------------------------------------------

THE LAST ONE 

#!/bin/ksh
H=`hostname`
TOP=/home4/alozahic/exploit/systeme/suivi/ABSYSS/TOP/top_$H.csv
if [ -f $TOP ]
then
 echo  "fichier present"
else
 touch $TOP
 echo "PID;USER;PR;NI; VIRT; RES ;  SHR; S ;%CPU ;%MEM ;TIME+ ;COMMAND" > $TOP
fi
top -b -d 1 -n 1 | grep vtserver | tr -s " " | sed 's/ /;/g' >> $TOP
tmail -sn TOP -se arnaud.lozahic@absyss.fr -to arnaud.lozahic@absyss.fr -smtp jupiter -sub TOP_$H -att $TOP
