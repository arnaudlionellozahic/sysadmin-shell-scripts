#!/bin/ksh

#Script qui permet de voir la prochaine execution des BOXs et Jobs
#

###########################################################################################
##Liste des jobs ON_ICE a exclure

sqlplus -s <<EOF1 |sort -u |grep -v BWAEP01-Q0BOX-MAINTENANCE | while read a
    atsreader/atsreader@X10844AP10
    set VERIFY OFF
    SET ECHO OFF
    SET NEWPAGE 0
    SET PAGESIZE 0
    SET FEEDBACK OFF
    SET HEADING OFF
    SET TRIMSPOOL ON
    SET TAB OFF
    SET LINESIZE 3000
    SET LONG 3000
    SET LONGC 3000
    SELECT UJO_JOBST.JOB_NAME||' '
  FROM AEDBADMIN.UJO_JOBST, AEDBADMIN.UJO_INTCODES
 WHERE (UJO_JOBST.START_TIMES IS NOT NULL)
       AND (UJO_JOBST.DATE_CONDITIONS = '1')
AND (UJO_JOBST.STATUS = '7');
EOF1
do
        print $a
done >/tmp/listtemp.log

for i in $(cat /tmp/listtemp.log)
do
j="$i|$j"
done
job_ice=$(print "$j" |sed 's/|$//')

###########################################################################################
#Liste des BOX et jobs avec un calendrier

sqlplus -s <<EOF1 |sort -u |grep -v BWAEP01-Q0BOX-MAINTENANCE | while read a b c d e
    atsreader/atsreader@X10844AP10
    set VERIFY OFF
    SET ECHO OFF
    SET NEWPAGE 0
    SET PAGESIZE 0
    SET FEEDBACK OFF
    SET HEADING OFF
    SET TRIMSPOOL ON
    SET TAB OFF
    SET LINESIZE 3000
    SET LONG 3000
    SET LONGC 3000
    SELECT UJO_JOBST.JOB_NAME||' '||
       UJO_JOBST.START_TIMES||' '||
       UJO_JOBST.DATE_CONDITIONS||' '||
       UJO_JOBST.DAYS_OF_WEEK||' '||
       UJO_JOBST.RUN_CALENDAR||' '
  FROM AEDBADMIN.UJO_JOBST, AEDBADMIN.UJO_INTCODES
 WHERE (UJO_JOBST.START_TIMES IS NOT NULL)
       AND (UJO_JOBST.DATE_CONDITIONS = '1');
EOF1
do
        printf "%-30s|%+11s|%14d|%10s|%11s\n" $a $b $c $d $e |egrep -v $job_ice
done >/tmp/liststart.log

###########################################################################################
##Liste des jobs RUNNING a exclure

sqlplus -s <<EOF1 |sort -u |grep -v BWAEP01-Q0BOX-MAINTENANCE | while read a
    atsreader/atsreader@X10844AP10
    set VERIFY OFF
    SET ECHO OFF
    SET NEWPAGE 0
    SET PAGESIZE 0
    SET FEEDBACK OFF
    SET HEADING OFF
    SET TRIMSPOOL ON
    SET TAB OFF
    SET LINESIZE 3000
    SET LONG 3000
    SET LONGC 3000
    SELECT UJO_JOBST.JOB_NAME||' '
  FROM AEDBADMIN.UJO_JOBST, AEDBADMIN.UJO_INTCODES
 WHERE (UJO_JOBST.START_TIMES IS NOT NULL)
       AND (UJO_JOBST.DATE_CONDITIONS = '1')
AND (UJO_JOBST.STATUS = '1');
EOF1
do
        print $a
done >/tmp/listrunning.log


###########################################################################################
#Vérification du demarrage
autorep -J % -d >/tmp/test.fred
jour=$(date "+%Y/%m/%d")
for a in $(cat /tmp/liststart.log |awk 'NR>3 {print $1}')
do
  if ! grep -q $a /tmp/listrunning.log
  then
  echo "cat /tmp/test.fred | awk '\$1 ~ /^$a$/,/STARTJOB/ {print \$0}'" >test.fred
  chmod 755 test.fred
  job=$(./test.fred |grep STARTJOB |grep -w "UP" |awk '{print $2,$3}')
  jourjobaut=$(echo $job |awk '{print $1}')
  heurejob=$(echo $job |awk '{print $2}')
  jourjob=$(echo $jourjobaut |awk -F"/" '{print $3"/"$2"/"$1}')

        if [[ $jourjobaut = $jour ]]
        then
        printf "Prochain demarrage de %-30s%-30s%-30s\n" $a $jourjob $heurejob >> /tmp/fred.test.logA
        elif [[ $jourjobaut = [0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9] ]]
        then
        printf "Prochain demarrage de %-30s%-30s%-30s\n" $a $jourjob $heurejob >>/tmp/fred.test.log
        fi
  else
  printf "Job $a en running\n" >>/tmp/fred.test.logB
  fi
done
print "\nPlanif des Jobs en date d'aujourd'hui\n"
cat /tmp/fred.test.logA |sort -rk 4
print "\nListe des jobs qui tourneront prochainement\n"
cat /tmp/fred.test.log |sort -rk 4
print "\nJob en running\n"
cat /tmp/fred.test.logB
print
rm /tmp/fred.test.log*
rm /tmp/test.fred /tmp/liststart.log /tmp/listtemp.log test.fred 
