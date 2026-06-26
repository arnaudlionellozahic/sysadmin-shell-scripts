#!/bin/ksh -x

req ()
{
for i in ${list_jobs}
do
ctmpsm -LISTALL | grep $i && echo $i
done
}


#Main

rep=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS
rep0=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report
list_jobs=`cat ${rep0}/liste_AJF_jobs.txt`
out_jobs_JDAY=${rep}/error_jobs_$(date "+%Y%m%d").csv
out_jobs_JDAY1=${rep}/error_jobs_`TZ=MET+24 date "+%Y%m%d"`.csv
out_jobs_JDAY2=${rep}/error_jobs_`date --date '2 days ago' "+%Y%m%d"`.csv
out2=${rep}/export_jobs_temp.txt
J_DAY=$(date "+%Y%m%d")
J_DAY1=`TZ=MET+24 date "+%Y%m%d"`
J_DAY2=`date --date '2 days ago' "+%Y%m%d"`
ENVI=PREX
rapport_htlm=${rep0}/gen_rapport_html.ksh

req > $out2
cat $out2 | grep CMD | grep NOTOK | grep ${J_DAY} | awk -F "|" '{print $2}' > ${out_jobs_JDAY}
cat $out2 | grep CMD | grep NOTOK | grep ${J_DAY1} | awk -F "|" '{print $2}' > ${out_jobs_JDAY1}
cat $out2 | grep CMD | grep NOTOK | grep ${J_DAY2} | awk -F "|" '{print $2}' > ${out_jobs_JDAY2}

rm -f $out2

ksh -x $rapport_htlm
