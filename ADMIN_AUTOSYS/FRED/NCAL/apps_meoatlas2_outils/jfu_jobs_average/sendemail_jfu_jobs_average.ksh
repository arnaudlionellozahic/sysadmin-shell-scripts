#!/usr/bin/ksh
DATE=$(date +'%Y%m%d')
HEURE=$(date +'%H:%M')
MAIL=/usr/sbin/sendmail
LOG=/apps/meoatlas2/outils/jfu_jobs_average
HOST=$(hostname)
$LOG/dump_jfu_jobs_average.ksh

from="PARIS_IPS_MEO_IRB"
to="mlist.paris.sfdi.meo.sdm@bnpparibas.com mlist.paris.rbis.me.csp@bnpparibas.com ronan.pouliquen.a@bnpparibas.com emmanuel.bosselut@externe.bnpparibas.com khalid.hallouli@bnpparibas.com benjamin.kalfon@bnpparibas.com fathi.beddiar@bnpparibas.com"
subject="A2 NC : history of jfu jobset on $DATE on $HOST"
boundary="ZZ_/afg6432dfgkl.94531q"
body="This is the body of our email"
#gzip ${LOG}/archive/${HOST}_history_jfu.${DATE}.csv
attachments="${LOG}/archive/${HOST}_history_jfu.${DATE}.csv.gz"

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
uuencode $file $file

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

#gzip -d $attachments

