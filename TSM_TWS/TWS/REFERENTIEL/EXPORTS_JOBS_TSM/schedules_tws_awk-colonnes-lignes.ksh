#!/bin/ksh -x

entete ()
{
echo "SCHEDULE;DESCRIPTION;CALENDAR;BEGIN_SCHED;CARRYFORWARD;LIMIT;JOB;BEGIN_JOB"
}

req ()
{
cat ${FIC} | sed -e 's/\(SCHEDULE.*\)/RECORD_SEP\1/' -e 's/\(FINFIN.*\)/\1RECORD_SEP/' |awk 'BEGIN{ RS="RECORD_SEP" } /SCHEDULE.*FINFIN.*/ { print $0 }' | awk 'BEGIN {deb=""}
  $1 == "SCHEDULE" { printf "\n%-s%-s",$2,";"}
  $1 == "DESCRIPTION" { printf "%-s%-s",$2,";"}
  $1 == "ONRUNCYCLE" { printf "%-s%-s",$2,";"}
  $1 == "BEGINSCHED" { printf "%-s%-s",$2,";"}
  $1 == "CARRYFORWARD" { printf "%-s%-s",$2,";"}
  $1 == "LIMIT" { printf "%-s%-s",$2,";"}
  $1 == "JOB" { printf "%-s%-s",$2,";"}
  $1 == "BEGINJOB" { printf "%-s%-s",$2,";"}
'
}

#Main
REP=/home/crashandro/SHELL/TWS
FIC=${REP}/schedules_all_wk_modele.txt
OUT=${REP}/export_schedule_global.csv

cd ${REP}
perl -pi -e "s/://g" ${FIC}
perl -pi -e "s/END/FINFIN/g" ${FIC}
perl -pi -e "s/ON RUNCYCLE/ONRUNCYCLE/g" ${FIC}
sed -i '/^$/d' ${FIC}
sed -i "s/^ *//g" ${FIC}

#manque un parser => les delimiteurs sont a rajouter a la main
entete > ${OUT}
req >> ${OUT}

#perl -pi -e 's/\"DESCRIPTION \"//g' ${OUT}
#perl -pi -e 's/SCHEDULE //g' ${OUT}
