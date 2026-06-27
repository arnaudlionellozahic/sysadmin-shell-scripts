#!/bin/ksh -x

entete ()
{
echo "adjust_cond;application;author;confirm;critical;datacenter;description;group;jobname;owner;table_name;table_userdaily;timefrom;user_by_code;maxwait;calendar_name"
}

req()
{
for j in $list_group
do
cat ${j} | sed -e 's/\(ADJUST_COND=.*\)/RECORD_SEP\1/' -e 's/\(SHIFTNUM=.*\)/\1RECORD_SEP/' |awk 'BEGIN{ RS="RECORD_SEP" } /ADJUST_COND=.*SHIFTNUM=.*/ { print $0 }' | sed 's/   //g;s/"//g;s/ //g;s/;/|/g' | awk -F "=" 'BEGIN {deb=""}
  $1 == "ADJUST_COND" { printf "\n%-s%-s",$2,";"}
  $1 == "APPLICATION" { printf "%-s%-s",$2,";"}
  $1 == "AUTHOR" { printf "%-s%-s",$2,";"}
  $1 == "CONFIRM" { printf "%-s%-s",$2,";"}
  $1 == "CRITICAL" { printf "%-s%-s",$2,";"}
  $1 == "DATACENTER" { printf "%-s%-s",$2,";"}
  $1 == "DESCRIPTION" { printf "%-s%-s",$2,";"}
  $1 == "GROUP" { printf "%-s%-s",$2,";"}
  $1 == "JOBNAME" { printf "%-s%-s",$2,";"}
  $1 == "OWNER" { printf "%-s%-s",$2,";"}
  $1 == "TABLE_NAME" { printf "%-s%-s",$2,";"}
  $1 == "TABLE_USERDAILY" { printf "%-s%-s",$2,";"}
  $1 == "TIMEFROM" { printf "%-s%-s",$2,";"}
  $1 == "USED_BY_CODE" { printf "%-s%-s",$2,";"}
  $1 == "MAXWAIT" { printf "%-s%-s",$2,";"}
  $1 == "NAME" { printf "%-s\n",$2}
'
done
}

#Main
out=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_GROUPS/export_group_global.csv
entete > $out

rep1=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_GROUPS
rep2=/home/alozahic/exploit/systeme/suivi/RANGE/CONTROL-M/EXTRACTION_EXPORT/EXPORT_GROUPS/LISTE_XML
#head=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/MAIL/header_gmail.info

list_group=`ls -1 ${rep2}`

cd $rep2
req >> $out
sed -i -e "2d;/^$/d" $out
#rajout_champ_1

#cat $head  | cat - $out | /usr/sbin/sendmail -t arnaud.lozahic@gmail.com
