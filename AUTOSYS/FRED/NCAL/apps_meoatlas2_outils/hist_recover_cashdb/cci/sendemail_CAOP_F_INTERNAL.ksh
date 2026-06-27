#!/usr/bin/ksh
DATE=$(date +'%Y%m%d')
HEURE=$(date +'%H:%M')
MAIL=/usr/sbin/sendmail
LOG=/apps/meoatlas2/outils/hist_recover_cashdb/cci
HOST=$(hostname)

from="PARIS_IPS_MEO_IRB"
to="yuthay.yean@bnpparibas.com paris.ips.meo.irb@bnpparibas.com fathi.beddiar@bnpparibas.com paris.bp2i.bsm.irb@bnpparibas.com"
#to="yuthay.yean@bnpparibas.com fathi.beddiar@bnpparibas.com paris.ips.meo.irb@bnpparibas.com"
subject="Urgent: A2 NCAL : TNG Error in received CCI block  $DATE on $HOST"
boundary="ZZ_/afg6432dfgkl.94531q"
body="Probleme OPR, merci de contacter IPS MEO IRP en HO ou astreinte IPS MEO IRB en HNO pour verification et controle si lenteur du produit"

# Build headers
{

printf '%s\n' "From: $from
To: $to
Subject: $subject
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=\"$boundary\"

--${boundary}
Content-Type: text/plain; charset=\"US-ASCII\"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

$body

"

# now loop over the attachments, guess the type
# and produce the corresponding part, encoded base64
for file in "${attachments[@]}"; do

  [ ! -f "$file" ] && echo "Warning: attachment $file not found, skipping" && continue

  #mimetype=$(#txt)

  printf '%s\n' "--${boundary}
Content-Type: multipart/mixed
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$file\"
"

#  base64 "$file"
  echo
done

# print last boundary with closing --
printf '%s\n' "--${boundary}--"



}|$MAIL -t -oi


