#!/bin/ksh

if [ "$1" = "" ] ; then
        echo "ressource en parametre"
        exit 1
fi

if [ "$2" = "" ] ; then
        echo "suffixe obligatoire"
        exit 1
fi

Suff=$2

USER=atsreader
PASS=atsreader
INSTANCE=$AUTOSERV
DS=`grep "^EventServer" $AUTOUSER/config.$AUTOSERV| head -1 |cut -d"=" -f2 `
#cat >/tmp/a.sql <<EOF
$ORACLE_HOME/bin/sqlplus -s <<EOF
$USER/$PASS@$DS
set lines 300;
set linesize 132
set newpage 0
set pagesize 0
set feedback off
COL JO for a20;
COL MA for a14;
COL RES for a07;
COL ST for a12;
COL TI for a45;
select
        j.job_name JO,
      r.res_name RES,
        j.run_machine MA ,
          substr(c.text,1,20) ST ,
          substr(to_char(to_date('01011970','DDMMYYYY')+(j.status_time-M.int_val)/86400,'DD/MM/YYYY HH24:MI:SS'),1,45) TI
from
        aedbadmin.ujo_jobst j,
       aedbadmin.ujo_intcodes c,
       aedbadmin.ujo_alamode M,
        aedbadmin.ujo_virt_resource_lookup r,
        aedbadmin.ujo_job_resource_dep d
where
       j.is_currver=1
        and j.job_ver=d.job_ver
        and j.joid=d.joid
        and d.roid=r.roid
       and M.TYPE='gmt_offset'
       and j.status=c.code
        and r.res_name like '$1'
         and j.job_name like '%${Suff}%'
order by 1
;
exit
EOF

