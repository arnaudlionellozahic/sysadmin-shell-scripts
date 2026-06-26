#!/bin/ksh -x

mail_sendmail ()
{
if [ `/bin/grep P ${FIC_HTML} | wc -l` -lt 1 ]
        then
                echo -e "\033[31mPas de groupes en erreur\033[00m"
                echo "Pas de groupes en erreur"
                FROM="bal-dsi-r2c-rpa-prr-pr2@natixis.com"
                MAILTO="arnaud.lozahic-ext@natixis.com"
                OBJET="[${ENVI}] : Liste des traitements et groupes en erreur entre le ${J_DAY2} et le ${J_DAY} sur pctrr"
(
 echo "FROM: $FROM"
 echo "To: $MAILTO"
 echo "Subject: $OBJET"
 echo "MIME-Version: 1.0"
 echo "Importance: High"
 echo "Content-Type: text/plain"
 cat << EOF
Bonjour,

Il n'y a pas de traitements ni groupes en erreur sur pctrr entre le ${J_DAY2} et le ${J_DAY}.

Cordialement,
L'equipe Integration Resultats et Risques
EOF
) | /usr/sbin/sendmail -fbal-dsi-r2c-rpa-prr-pr2@natixis.com $MAILTO

        else

                FROM="bal-dsi-r2c-rpa-prr-pr2@natixis.com"
                MAILTO="arnaud.lozahic-ext@natixis.com"
                OBJET="[${ENVI}] : Liste des traitements et groupes en erreur entre le ${J_DAY2} et le ${J_DAY} sur pctrr"
                export ATTACH="${FIC_HTML}"
(
 echo "FROM: $FROM"
 echo "To: $MAILTO"
 echo "Subject: $OBJET"
 echo "MIME-Version: 1.0"
 echo "Importance: High"
 echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'
) | cat - ${ATTACH} | /usr/sbin/sendmail -fbal-dsi-r2c-rpa-prr-pr2@natixis.com -t $MAILTO

fi
}


fonc_groupe_JDAY ()
{
        

	echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
	echo "<hr></hr></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        echo "<tr bgcolor="#CD5C5C">" >> ${FIC_HTML}
        echo "<td>" >> ${FIC_HTML}
        echo "<b><center>EXPORT DES ERREURS DU JOUR</center></b>" >> ${FIC_HTML}
        echo "</td>" >> ${FIC_HTML}
        echo "</tr>" >> ${FIC_HTML}
	echo "</table>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des groupes en erreur sur le plan du ${J_DAY}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_groups_JDAY} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done

        echo "</table>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}
}


fonc_job_JDAY ()
{


        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des jobs en erreur sur le plan du ${J_DAY}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_jobs_JDAY} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done

        echo "</table>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}
}


fonc_groupe_JDAY1 ()
{

	echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
	echo "<br>" >> ${FIC_HTML}
        echo "<p><hr></hr></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        echo "<tr bgcolor="#CD5C5C">" >> ${FIC_HTML}
        echo "<td>" >> ${FIC_HTML}
        echo "<b><center>EXPORT DES ERREURS DE LA VEILLE</center></b>" >> ${FIC_HTML}
        echo "</td>" >> ${FIC_HTML}
        echo "</tr>" >> ${FIC_HTML}
        echo "</table>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des groupes en erreur sur le plan du ${J_DAY1}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_groups_JDAY1} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done

        echo "</table>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}

}


fonc_job_JDAY1 ()
{

        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des jobs en erreur sur le plan du ${J_DAY1}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_jobs_JDAY1} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done

        echo "</table>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}

}


fonc_groupe_JDAY2 ()
{


        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
        echo "<br>" >> ${FIC_HTML}
        echo "<p><hr></hr></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        echo "<tr bgcolor="#CD5C5C">" >> ${FIC_HTML}
        echo "<td>" >> ${FIC_HTML}
        echo "<b><center>EXPORT DES ERREURS DE L'AVANT-VEILLE</center></b>" >> ${FIC_HTML}
        echo "</td>" >> ${FIC_HTML}
        echo "</tr>" >> ${FIC_HTML}
        echo "</table>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des groupes en erreur sur le plan du ${J_DAY2}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_groups_JDAY2} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done

        echo "</table>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}
}


fonc_job_JDAY2 ()
{


        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >> ${FIC_HTML}
        echo "<html><head>" >> ${FIC_HTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >> ${FIC_HTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >> ${FIC_HTML}
        echo "<body>" >> ${FIC_HTML}
        echo "<p><b>" >> ${FIC_HTML}
        echo "Vous trouverez ci-dessous la liste des jobs en erreur sur le plan du ${J_DAY2}" >>${FIC_HTML}
        echo "</b></p>" >> ${FIC_HTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="50%">" >> ${FIC_HTML}
        cat ${out_jobs_JDAY2} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >> ${FIC_HTML}
                        echo "<td>" >> ${FIC_HTML}
                        echo "$(echo ${line} | awk -F";" '{print $1}')" >> ${FIC_HTML}
                        echo "</td>" >> ${FIC_HTML}
                        echo "</tr>" >> ${FIC_HTML}
        done
	
	echo "</table>" >> ${FIC_HTML}
	echo "<br>" >> ${FIC_HTML}
        echo "<p><hr><b> Statistiques extraites le $(date "+%d-%m-%Y a %Hh%M") </b><hr></p>" >> ${FIC_HTML}
        echo "<br>" >> ${FIC_HTML}
        echo "</body>" >> ${FIC_HTML}
        echo "</html>" >> ${FIC_HTML}
}


entete ()
{

echo '<html>
     <head>
  <title>ERREURS CONTROL-M></title>
  <style type="text/css">
  #ctlm {
   color:red;
   }
   body {
    color:blue;
        background:#DCDCDC
        }
  </style>
</head>
<body>
<div id="ctlm"><h1>ERREURS CONTROL-M</h1></div>
</body>
</html> '

}


#Main
rep=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS
rep0=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report
out_groups_JDAY=${rep}/error_groups_$(date "+%Y%m%d").csv
out_groups_JDAY1=${rep}/error_groups_`TZ=MET+24 date "+%Y%m%d"`.csv
out_groups_JDAY2=${rep}/error_groups_`date --date '2 days ago' "+%Y%m%d"`.csv
out_jobs_JDAY=${rep}/error_jobs_$(date "+%Y%m%d").csv
out_jobs_JDAY1=${rep}/error_jobs_`TZ=MET+24 date "+%Y%m%d"`.csv
out_jobs_JDAY2=${rep}/error_jobs_`date --date '2 days ago' "+%Y%m%d"`.csv
J_DAY=$(date "+%Y%m%d")
J_DAY1=`TZ=MET+24 date "+%Y%m%d"`
J_DAY2=`date --date '2 days ago' "+%Y%m%d"`
ENVI=PREX
FIC_HTML=/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS/rapport_$(date "+%Y%m%d").html


entete > ${FIC_HTML}
fonc_groupe_JDAY >> ${FIC_HTML}
fonc_job_JDAY >> ${FIC_HTML}
fonc_groupe_JDAY1 >> ${FIC_HTML}
fonc_job_JDAY1 >> ${FIC_HTML}
fonc_groupe_JDAY2 >> ${FIC_HTML}
fonc_job_JDAY2 >> ${FIC_HTML}
mail_sendmail

