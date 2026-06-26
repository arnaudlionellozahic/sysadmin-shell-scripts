#!/usr/bin/ksh

RES=/tmp/cmp_`hostname`.$$
>$RES

for j in `ls /apps|egrep -v "Deploy|ITCM|OmniVision|SCM|Suppression_IP_codees_en_dur|admin|backup_restore|cft|cft_data|cobol|convert|syncsort|amelia|dmexpress|eTAC|getlog|lost+found|mqm|nimsoft|oracle|oradbf|qpasa|savebase|tmp_candle|toolboxes|ua_candle|unicenter|unikix|unl_infoc|work|AccessCon|Deploy|ITCM|SCM|Omni|admin|eTAC|esm|lost|nimsoft|premig|qpasa|candle|tsm"`
do
        find /apps/$j -type d -o -type l
done|grep -v "lost+found"|sort -u >/tmp/tmp_cmp.$$

for i in `cat /tmp/tmp_cmp.$$`
do
        ls -dl $i |awk '{print $1" "$3" "$4}'|read droit util grpe
        echo "$i;$droit;$util;$grpe">>$RES
done

#rm /tmp/tmp_cmp.$$

df |awk '{print $7";"$2}'|grep -v Mounted|sort -d >/tmp/df_`hostname`.$$

