#!/bin/ksh

#Ce script verifie les BOX et jobs bases sur des calendriers

print "\nFichier de log dans /tmp/start_times_jobautosys_base.log\n\n"
printf "%-30s|%-11s|%2s|%10s|%11s\n" "BOX ou JOB" Start_times Date_condition Calendrier |tee /tmp/start_times_jobautosys_base.log
print "_____________________________________________________________________\n" |tee -a /tmp/start_times_jobautosys_base.log
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
        printf "%-30s|%+11s|%14d|%10s|%11s\n" $a $b $c $d $e
done |tee -a /tmp/start_times_jobautosys_base.log

