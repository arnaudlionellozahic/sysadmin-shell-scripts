#!/usr/bin/ksh

[ $# -ne 1 ] && echo "usage: `basename $0` <env atlas a scanner>" && exit
env=$1

RES=/tmp/cmp_`hostname`.$$
>$RES

for j in `ls /apps|egrep -v "Deploy|ITCM|OmniVision|SCM|Suppression_IP_codees_en_dur|admin|backup_restore|cft|cft_data|cobol|convert|syncsort|
amelia|dmexpress|eTAC|getlog|lost+found|mqm|nimsoft|oracle|oradbf|qpasa|savebase|tmp_candle|toolboxes|ua_candle|unicenter|unikix|unl_infoc|wor
k|AccessCon|Deploy|ITCM|SCM|Omni|admin|eTAC|esm|lost|nimsoft|premig|qpasa|candle|tsm"`
do
        rep=$j
        [ "$j" == "atlas" ] && rep="atlas/atlas2v0/$env" && echo "Scanning $rep"
        find /apps/$rep -type d -o -type l
done|grep -v "lost+found"|sort -u >/tmp/tmp_cmp.$$

for i in `cat /tmp/tmp_cmp.$$`
do
        ls -dl $i |awk '{print $1" "$3" "$4}'|read droit util grpe
        echo "$i;$droit;$util;$grpe">>$RES
done

#rm /tmp/tmp_cmp.$$

df |awk '{print $7";"$2}'|grep -v Mounted|sort -d >/tmp/df_`hostname`.$$
