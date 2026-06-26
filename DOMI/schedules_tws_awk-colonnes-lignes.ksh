#!/bin/ksh -x

entete ()
{
echo "application;groupname;memname;jobname;priority;message;description;time;controlm;nodeid"
}

req()
{
for j in $list_job
do
cat ${j} | sed -e 's/\(Application=.*\)/RECORD_SEP\1/' -e 's/\(NodeID=.*\)/\1RECORD_SEP/' |awk 'BEGIN{ RS="RECORD_SEP" } /Application=.*NodeID=.*/ { print $0 }' | sed 's/;/=/g;s/Group Name/Group/g' | awk -F "=" 'BEGIN {deb=""}
  $1 == "Application" { printf "\n%-s%-s",$2,";"}
  $1 == "Group" { printf "%-s%-s",$2,";"}
  $1 == "MemName" { printf "%-s%-s",$2,";"}
  $1 == "JobName" { printf "%-s%-s",$2,";"}
  $1 == "Priority" { printf "%-s%-s",$2,";"}
  $1 == "Message" { printf "%-s%-s",$2,";"}
  $1 == "Description" { printf "%-s%-s",$2,";"}
  $1 == "Time" { printf "%-s%-s",$2,";"}
  $1 == "ControlM Server" { printf "%-s%-s",$2,";"}
  $1 == "NodeID" {  printf "%-s\n",$2}
'
done
}

#Main
out=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_JOBS_ARNAUD/export_traitement_global.csv
entete > $out

f=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_JOBS_ARNAUD
rep2=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_JOBS_ARNAUD/LISTE_XML
#head=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/MAIL/header_gmail.info

list_job=`ls -1 ${rep2}`

cd $rep2
req >> $out
sed -i -e "2d;/^$/d" $out
#rajout_champ_1

#cat $head  | cat - $out | /usr/sbin/sendmail -t arnaud.lozahic@gmail.com
