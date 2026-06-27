#!/bin/ksh
exec 1>/apps/atlas/atlas2v0/uf1/data1/imp/JCHBOX.j9cb.$(date "+%Y%m%d").$(date "+%H%M%S")
exec 2>&1

echo "Ce script check les SB eod et Batch, si une des deux ou les deux est en état RUNNING ou FAILURE, rechercher le ou les jobs qui peuvent être en FAILURE.
Une fois le ou les Jobs en Failure trouvé, contacter l'équipe adéquate\n\n"

nb=0
>/tmp/tmp_box

for i in sb_wday01_eodCald sb_wday01_jtp1Cald sb_wday01_editCald sb_wday01_batchCald sb_wdcb01_batchCald
do
nb=$((nb + 1))

BOX_[$nb]=$(autorep -j $i -L0 |egrep -v "Job Name|^$|___________" |awk '{print $1}')
STAT_[$nb]=$(autorep -j $i -L0 |egrep -v "Job Name|^$|_____________" |awk '{print $6}')
        if [[ ${STAT_[$nb]} != SU ]]
        then
        echo "La box ${BOX_[$nb]} n'est pas dans un etat attendu" >>/tmp/tmp_box
        RC=5
        else
        echo "La BOX ${BOX_[$nb]} est Success"
        fi
done

a=$(cat /tmp/tmp_box |awk '{printf $3}')

if [[ $RC -eq 5 ]]
then
echo Envoie du mail
MAIL=/usr/sbin/sendmail
from="PARIS_IPS_MEO_IRB@bnpparibas.com"
#to="paris_bp2i_bsm_irb@bnpparibas.com"
to="frederic.gasnier@bnpparibas.com"
#cc="PARIS_IPS_MEO_IRB@bnpparibas.com,frederic.gasnier@bnpparibas.com"
subject="Check des SB eod et batch sur $(hostname)"

{

printf '%s\n' "From: $from
To: $to
Cc: $cc
Subject: $subject
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=\"$boundary\"

--${boundary}
Content-Type: text/plain; charset=\"US-ASCII\"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

         Bonjour

         Merci de vérifier les Super-BOXs suivantes, une de ces SB est en Running : $a

         En HO, merci d'appeler la MEO IRB et en HNO, merci d'appeler l'astreinte MEO

         Cordialement


"

}|$MAIL -t -oi
rm /tmp/tmp_box
exit $RC
fi