#!/bin/ksh -x

req ()
{
for i in ${list_groups}
do
ctmpsm -LISTALL | grep $i && echo $i
done
}


#Main

rep=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS
rep0=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report
list_groups=`cat ${rep0}/liste_AJF_groups.txt`
out_groups_JDAY=${rep}/error_groups_$(date "+%Y%m%d").csv
out_groups_JDAY1=${rep}/error_groups_`TZ=MET+24 date "+%Y%m%d"`.csv
out_groups_JDAY2=${rep}/error_groups_`date --date '2 days ago' "+%Y%m%d"`.csv
out2=${rep}/export_tables_temp.txt
J_DAY=$(date "+%Y%m%d")
J_DAY1=`TZ=MET+24 date "+%Y%m%d"`
J_DAY2=`date --date '2 days ago' "+%Y%m%d"`
ENVI=PREX
export_jobs=${rep0}/export_jobs.ksh

req > $out2
cat $out2 | grep TBL | grep NOTOK | grep ${J_DAY} | awk -F "|" '{print $2}' > ${out_groups_JDAY}
cat $out2 | grep TBL | grep NOTOK | grep ${J_DAY1} | awk -F "|" '{print $2}' > ${out_groups_JDAY1}
cat $out2 | grep TBL | grep NOTOK | grep ${J_DAY2} | awk -F "|" '{print $2}' > ${out_groups_JDAY2}

rm -f $out2

ksh -x ${export_jobs}
