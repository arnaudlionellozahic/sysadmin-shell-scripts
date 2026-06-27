#/usr/bin/ksh 
. /usr/bin/EnvironnementTNG

VERIFTIME=$(date +"%Y%m%d%H%M")
export VERIFTIME

MAIL=/usr/sbin/sendmail
from="PARIS_IPS_MEO_IRB@bnpparibas.com"
to="PARIS_BP2I_BSM_IRB@bnpparibas.com"
cc="PARIS_IPS_MEO_IRB@bnpparibas.com"
subject="Urgent $(hostname) Autoscan est incomplet a verifier sur A2 NCAL $VERIFTIME"


##autoscan sur NCAL CAISCHD0011=5
## verif autoscan si ok

cautil status monitor | grep "Autosub status is: On"
if [[ $? -ne 0 ]]
then

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

         Merci de contacter la MEO en urgence en HO ou HNO pour verifier etat de autoscan et Autosub TNG
         
         Cordialement


"

}|$MAIL -t -oi 

fi

cautil select conlog list |grep "Autoscan is complete"
if [ $? -eq 1 ]
then

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

         Merci de contacter la MEO en urgence en HO ou HNO pour verifier etat de autoscan et Autosub TNG

         Cordialement


"

}|$MAIL -t -oi

fi

