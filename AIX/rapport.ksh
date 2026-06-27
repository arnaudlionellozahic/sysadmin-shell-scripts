#!/bin/ksh
#set -x
export TEMP=/tmp/rapport_temp.log
exec 1>$TEMP
exec 2>&1
export DATEVEILLE="$(TZ=MET+24 date +"%Y/%m/%d")"
export DATE=`date "+%Y/%m/%d"`
export DATEJOB=`date "+%Y%m%d"`
export FILE="/tmp/mail.log"
export FILE1="/tmp/mail_bici.log"
export SAUVE_TEMP="/apps/meoatlas2/rapports/autosys/Rapport_job_temp"
export SAUVE="/apps/meoatlas2/rapports/autosys/Rapport_job_$DATEJOB"
#export SAUVE_BICI="/apps/meoatlas2/rapports/autosys/Rapport_job_guinee_$DATEJOB"
export ORACLE_SID=P10973AP10
export ORACLE_BASE=/apps/oracle
export ORACLE_HOME=/apps/oracle/product/11204
#export AUTOSERV=P13
#. /etc/auto.profile
#export ORACLE_SID=$(chk_auto_up | grep -i "Have Connected successfully" | head -1 | cut -d":" -f2 | cut -d"." -f1 |sed 's/ //g')

#Lancement du script perl qui check tous le jobs en cours, running ou failure

/apps/meoatlas2/outils/autosys.pl -j % -f "$DATEVEILLE 08:00:00" -t "$DATE 08:10:00" |tee $SAUVE_TEMP

#SED qui permet de rajouter les control-M pour les sauts a la ligne

if [[ -e $SAUVE_TEMP ]] then
sed '/^ *$/d' $SAUVE_TEMP >$SAUVE
cp -p $SAUVE ${SAUVE}.csv
grep -v "BWAEP01" $SAUVE >${SAUVE_BICI}.csv
fi

export FAIL=$(grep FAILURE $SAUVE_TEMP)
export FAIL_NUM=$(grep FAILURE $SAUVE_TEMP |wc -l)
export RUN=$(grep RUNNING $SAUVE_TEMP)
export RUN_NUM=$(grep RUNNING $SAUVE_TEMP |wc -l)

(echo Subject: "Rapport des Jobs sur 24h PRODUCTION $(hostname) Atlas GUINEE du"  $DATE; uuencode ${SAUVE}.csv ${SAUVE}.csv) >$FILE
print "\n\nBonjour,\n\n" >>$FILE
print "Veuillez trouver ci-joint l'execution et etat des jobs du $DATEVEILLE a 08h au $DATE a 09h59\n" >>$FILE

if [[ -n "$FAIL" ]] then
print "Merci de verifier, il y a $FAIL_NUM jobs en FAILURE\n" >>$FILE
fi
if [[ -n "$RUN" ]] then
print "Merci de verifier, il y a $RUN_NUM jobs en RUNNING\n" >>$FILE
fi

print "Cordialement," >>$FILE
#/usr/sbin/sendmail -f meo_atlas_paris -v frederic.gasnier@bnpparibas.com anis.tarkhani@externe.bnpparibas.com fathi.beddiar@bnpparibas.com <$FILE


#(echo Subject: "Rapport des Jobs sur 24h PRODUCTION $(hostname) Atlas GUINEE du"  $DATE; uuencode ${SAUVE_BICI}.csv ${SAUVE_BICI}.csv ) >$FILE1
#print "\n\nBonjour,\n\n" >>$FILE1
#print "Veuillez trouver ci-joint l'execution et etat des jobs du $DATEVEILLE a 08h au $DATE a 09h59\n" >>$FILE1
#
#print "\nCordialement," >>$FILE1
#/usr/sbin/sendmail -f meo_atlas_paris -v frederic.gasnier@bnpparibas.com mlist_afrique_dsi_ra_ito_suivi_production@bnpparibas.com informatique.bicigui@bnpparibas.com <$FILE1

rm $FILE1
rm $FILE
rm $SAUVE_TEMP
rm $SAUVE_BICI
rm $SAUVE
