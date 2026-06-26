#!/bin/ksh
exec 1>/tmp/fred.log 2>&1
###############################################
#Creation d'un rapport Atlas                  #
#                                             #
#Date 3/4/2001                              #
#                                             #
#auteur JCM                                   #
###############################################

#Creation d'un rapport Atlas
jour1=`date +"%d%m%y.%H%M%S"`
rep2=/apps/sys/shell/exploit/log
rep1=/apps/sys/shell/exploit/
rep3=/apps/sys/shell/exploit/Guinee/file

file=rap_autosys_atlas.ksh
file1=resultat_$jour1
log=logmail



#===> date dans le fichier logmail
date >> $rep2/$log

#Creation du fichier resultat


$rep1/$file > $rep2/$file1

#Envoye  par mail

echo "Subject: Rapport Atlas quotidien Guinee" >/tmp/rapporteur
cat $rep2/$file1 >>/tmp/rapporteur

#sendmail -f meo_atlas_paris -v abdoulgoudouss.camara@bnpparibas.com,mlist_afrique_dsi_ra_banking_sdm@bnpparibas.com,MLIST_PARIS_RBIS_ME_CSP@bnpparibas.com,PARIS_ITPS_SDM_RB_EM@bnpparibas.com,conakry_sfdi_informatique@bnpparibas.com,didier.fourdrinier@bnpparibas.com,hakim.benmansour@bnpparibas.com,mlist_afrique_dsi_ra_orit_suivi_production@bnpparibas.com,PARIS_BP2I_BSM_IRB@bnpparibas.com,philippe.de.oliveira@bnpparibas.com,yuthay.yean@bnpparibas.com,frederic.gasnier@bnpparibas.com,benjamin.kalfon@bnpparibas.com  </tmp/rapporteur  1>>$rep2/$log 2>>$rep2/$log
sendmail -f meo_atlas_paris -v frederic.gasnier@bnpparibas.com </tmp/rapporteur  1>>$rep2/$log 2>>$rep2/$log

echo "Subject:ETAT DES TABLESPACES Guinée " >/tmp/testfy0
cat /tmp/testfy >> /tmp/testfy0

cat $rep2/$file1 |head -24 |tail -20 >$rep2/rapsite$jour1.xls

#(echo "Subject : Rapport quotidien Guinée";uuencode $rep2/rapsite$jour1.xls $rep2/rapsite$jour1.xls)|sendmail -f paris_ips_meo_irb@bnpparibas.com -v mlist_paris_sfdi_meo_sdm@bnpparibas.com,mlist_afrique_dsi_ra_banking_sdm@bnpparibas.com,PARIS_BP2I_BSM_IRB@bnpparibas.com 1>>$rep2/$log 2>>$rep2/$log

(echo "Subject : Rapport quotidien Guinée";uuencode $rep2/rapsite$jour1.xls $rep2/rapsite$jour1.xls)|sendmail -f paris_ips_meo_irb@bnpparibas.com -v frederic.gasnier@bnpparibas.com 1>>$rep2/$log 2>>$rep2/$log

#sendmail -f paris_bp2i_pilotage_bficb_sfdi@bnpparibas.com -v paris_itp_pilotage_sfdi-ma@bnpparibas.com,paris_itp_meo_sfdi-ma@bnpparibas.com,khalid.hilmy@bn
#pparibas.com  < /tmp/testfy0 1>>$rep2/$log 2>>$rep2/$log
#sendmail -f paris_bp2i_pilotage_bficb_sfdi@bnpparibas.com -v PARIS_ITP_PILOTAGE_SFDI-MA@bnpparibas.com,PARIS_ITP_MEO_SFDI-MA@bnpparibas.com,khalid.hilmy@bnpparibas.com <  /tmp/testfy0  1>>$rep2/$log 2>>$rep2/$log
#########balise stat ############
#. /apps/sys/shell/exploit/rap/stat_balises
#. /apps/sys/shell/exploit/rap/stat_balises_bis

