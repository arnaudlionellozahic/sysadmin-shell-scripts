#!/bin/ksh

############################################################################
#        Initialisation des variables + export profile                     #
############################################################################

export TEMP=/tmp/arnaud.log
exec 1>$TEMP
exec 2>&1
export HEURE=`date "+%k:%m"`
export DATEVEILLE=`date "+%Y/%m/%d" --date "today -1day"`
export DATE=`date "+%Y/%m/%d"`
export DATEJOB=`date "+%Y%m%d"`
export FILE="/tmp/mail.log"
export SAUVE_TEMP="/apps/meoatlas2/arnaud/Rapport_job_temp"
export SAUVE="/apps/meoatlas2/arnaud/Rapport_job_${DATEJOB}"
export AUTOSERV=QI1
. /etc/auto.profile

#Lancement du script perl qui check tous le jobs en cours, running ou failure

perl -w /apps/meoatlas2/arnaud/autosys5.pl -j % -f "$DATEVEILLE 06:00:00" -t "$DATE 08:59:59" |tee $SAUVE_TEMP #>$FILE

#SED qui permet de rajouter les control-M pour les sauts a la ligne

if [[ -e $SAUVE_TEMP ]] then
sed '/^ *$/d' $SAUVE_TEMP >$SAUVE
mv $SAUVE ${SAUVE}.csv
fi

export FAIL=$(grep FAILURE $SAUVE_TEMP)
export FAIL_NUM=$(grep FAILURE $SAUVE_TEMP |wc -l)
export RUN=$(grep RUNNING $SAUVE_TEMP)
export RUN_NUM=$(grep RUNNING $SAUVE_TEMP |wc -l)

(echo Subject: "Rapport des Jobs sur 24h PRODUCTION Client AUTOSYS $(hostname) du"  $DATE ; uuencode ${SAUVE}.csv ${SAUVE}.csv) >$FILE
print "\n\nBonjour,\n\n" >>$FILE
print "Veuillez trouver ci-joint l'execution et etat des jobs du $DATEVEILLE 06h au $DATE 08h59\n" >>$FILE

if [[ -n "$FAIL" ]] then
print "Merci de verifier, il y a $FAIL_NUM jobs en FAILURE\n" >>$FILE
fi
if [[ -n "$RUN" ]] then
print "Merci de verifier, il y a $RUN_NUM jobs en RUNNING\n" >>$FILE
fi

print "Cordialement," >>$FILE

/usr/sbin/sendmail -f meo_atlas_paris -v arnaud.lozahic@externe.bnpparibas.com <$FILE

#rm $FILE
#rm $SAUVE_TEMP

