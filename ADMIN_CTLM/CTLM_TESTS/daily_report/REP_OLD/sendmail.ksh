#!/bin/ksh -x

mail ()
{
if [ `/bin/grep P $out | wc -l` -lt 1 ]
        then
                echo -e "\033[31mPas de traitements et groupes en erreur, holdes ou en attente de ressources\033[00m"
                echo "Pas de traitements et groupes en erreur, holdes ou en attente de ressources"
		FROM="bal-dsi-r2c-rpa-prr-pr2@natixis.com"
		MAILTO="arnaud.lozahic-ext@natixis.com"
		OBJET="[${ENVI}] : Liste des traitements et groupes en erreur ou en hold entre le ${J_DAY} et le ${J_DAY2}"
(
 echo "FROM: $FROM"
 echo "To: $MAILTO"
 echo "Subject: $OBJET"
 echo "MIME-Version: 1.0"
 echo "Importance: High"
 echo "Content-Type: text/plain"
 cat << EOF
Bonjour,

Il n'y a pas de traitements et groupes en erreur, holdes ou en attente de ressources sur pctrr.

Cordialement,
L'equipe Integration Resultats et Risques
EOF
) | /usr/sbin/sendmail -fbal-dsi-r2c-rpa-prr-pr2@natixis.com $MAILTO

        else

                FROM="bal-dsi-r2c-rpa-prr-pr2@natixis.com"
                MAILTO="arnaud.lozahic-ext@natixis.com"
                OBJET="[${ENVI}] : Liste des traitements et groupes en erreur ou en hold entre le ${J_DAY} et le ${J_DAY2}"
		#export BODY="${rep}/email_body.htm"
		export ATTACH="${out}"
(
 echo "FROM: $FROM"
 echo "To: $MAILTO"
 echo "Subject: $OBJET"
 echo "MIME-Version: 1.0"
 echo "Importance: High"
 #export BODY="${rep}/email_body.htm"
 #export BODY="${out}"
 #export ATTACH="${out}"
 #echo "Content-Type: text/html; charset="UTF-8""
 #echo "Content-Type: text/plain; charset="us-ascii""
 #echo 'Content-Disposition: inline'
 echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'
) | cat - ${ATTACH} | /usr/sbin/sendmail -fbal-dsi-r2c-rpa-prr-pr2@natixis.com -t $MAILTO

fi
}


#Main
rep=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report
list=`cat ${rep}/liste_AJF.txt`
out=${rep}/rapport_20140204_SAVE.html
out2=${rep}/export_temp.txt
J_DAY=$(date "+%Y%m%d")
J_DAY1=`TZ=MET+24 date "+%Y%m%d"`
J_DAY2=`date --date '2 days ago' "+%Y%m%d"`
ENVI=PREX

mail

