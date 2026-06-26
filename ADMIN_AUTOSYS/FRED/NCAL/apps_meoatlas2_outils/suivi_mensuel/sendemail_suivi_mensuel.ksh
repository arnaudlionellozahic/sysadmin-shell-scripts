#!/usr/bin/ksh
DATE=$(date +'%Y%m%d')
HEURE=$(date +'%H:%M')
MAIL=/usr/sbin/sendmail
LOG=/apps/meoatlas2/outils/suivi_mensuel
HOST=$(hostname)
$LOG/job_abort.ksh > $LOG/archive/job_abort.tmp
$LOG/suivi_mensuel.ksh | sort | sort -u > $LOG/archive/suivi_mensuel_${HOST}_${DATE}

from="PARIS_IPS_MEO_IRB"
to="AFRIQUE_DSI_RA_BANKING_SDM@bnpparibas.com"
cc="fathi.beddiar@bnpparibas.com jean-noel.hontarrede@bnpparibas.com Anis.TARKHANI@externe.bnpparibas.com"
subject="A2 NCAL suivi mensuel on $DATE $HEURE $HOST"
abort=$(cat $LOG/archive/job_abort.tmp)
body=$(cat $LOG/archive/suivi_mensuel_${HOST}_${DATE})

# Build headers
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

suivi des traitements mensuel apres msfa: faire attention dans la colonne 3 si 00:00 il faut dire que c est la journee avant
exemple : Jan 10 00:00 # 19.39.04 .CASH_I_0060 mfl99ofma 0900 Completed at 19.39.04, code: 00000000
il faut donc lire le 9 janvier car le fichier a été mis à jour à minuit

$abort

$body
"

}|$MAIL -t -oi

