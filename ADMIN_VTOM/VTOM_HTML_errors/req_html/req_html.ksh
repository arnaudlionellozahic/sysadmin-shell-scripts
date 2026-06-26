#!/bin/ksh

debut_h ()
{

echo '<html>
     <head>
  <title>ERREURS VTOM</title>
  <style type="text/css">
  #vtom {
   color:red;
   }
  #logo_haut {
    background:url("file:///C:/Exploit_Absyss/www/vtom.png") no-repeat center top ;
	width: 100px;
    height: 100px;
	}
   body {
    color:blue;
	background:#DCDCDC
	}	
  </style>
</head>
<body>
<div id="vtom"><h1 style="text-align:left;">ERREURS VTOM</h1></div>
<div id="logo_haut"></div>
</body>
</html> '

print "\n <p><B> $(date "+%d-%m-%Y %Hh%M") </B><br /> \n"
}


warning_date ()
{
[ "$(date "+%d-%m-%Y")" != "$(tgetdate -name=$ENV)" ] && echo '<p> <B> <font color="#FF1493">' "Attention date d'exploit $ENV desynchronisee </font> </B><br />"
print "<p><B><u> valeur de date d'exploit $ENV :</u> <i> `tgetdate -name=$ENV`  </i><br /> \n"
echo "</p>"
}

req_count ()
{
./psql -A -t -c "SELECT COUNT(*) FROM vt_stats_job WHERE vtexpdatevalue=CURRENT_DATE AND vtretcode!=0 AND vtjobname IS NOT NULL " -d vtom -h centos63 -p 33909 -U vtom
}

req ()
{
./psql -A -H -c "SELECT vtenvname, vtapplname, vtjobname,vtend - vtbegin, vtexpdatevalue, vtretcode, vterrmess,vtbegin, vtend FROM vt_stats_job WHERE vtexpdatevalue=CURRENT_DATE AND vtretcode!=0 AND vtjobname IS NOT NULL ORDER BY vtbegin " -d vtom -h centos63 -p 33909 -U vtom | sed -e 's/vt//g;s/?column?/time/g;s/<table border="1"/<table border="1" bgcolor="FFFF66">/g;s/valign="top">/valign=top bgcolor="FF9900">/g'

echo '<html>
     <head>
  <title>ERREURS VTOM</title>
  <style type="text/css">
  #logo_bas {
    color:blue;
    background:url("file:///C:/Exploit_Absyss/www/logo_absyss.png") no-repeat center top ;
	width: 250px;
    height: 120px;
	}
  </style>
</head>
<body>
<div id="logo_bas"></div>
</body>
</html> '

}


# Main
ENV=SOUMISSION

err=`req_count`
err2=`warning_date | grep Attention | grep -v grep | wc -l`
nb_err=`expr $err + $err2`
echo "nb_err $nb_err"

out=/home/alozahic/Linux/centos63/Ver551d/sgbd/bin/res.html
rm -f $out
debut_h > $out
warning_date >> $out

[ $err -ne 0 ] && req >> $out

NB_TEST=$(grep row $out | cut -c5-6)

tmail -se "arnaud.lozahic@absyss.fr" -to "arnaud.lozahic@absyss.fr" -smtp "jupiter" -sub "[ERRORS_COLOR] ($NB_TEST)" -msg "Statistiques du $DATE_D au $DATE_F extraites le $(date +'%d/%m/%Y a %H:%M')" -att "$out" -msgf "$out"