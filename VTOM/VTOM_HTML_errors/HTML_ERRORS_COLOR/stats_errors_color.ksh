#! /bin/ksh

set -x 

OUTPUT_FILE=/home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html 

case $# in
  0) DATE_D=$(date +"%Y-%m-%d"); DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = CURRENT_DATE";;
  1) DATE_D=$1; DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = cast ('$DATE_D' as date)";;
  2) DATE_D=$1; DATE_F=$2; CLAUSE="vtexpdatevalue >= cast ('$DATE_D' as date) AND vtexpdatevalue <= cast ('$DATE_F' as date)";;
  *) echo "Nombre d'arguments incorrect"; exit 1;;
esac

echo ' <html>
     <head>
  <title></title>
  <style type="text/css">
  body {
    color: black;
    background-color: #000000}
  </style>
</head> 
<table border="1">
  <tr bgcolor="#00BFFF"> ' > $OUTPUT_FILE 

$TOM_HOME/sgbd/bin/psql -A -H -c "SELECT vtenvname, vtapplname, vtjobname, vtbegin, vtend, vtend - vtbegin, vtexpdatevalue, vtnbretry, 'EN-ERREUR', vtretcode, vterrmess FROM vt_stats_job WHERE $CLAUSE AND vtjobname IS NOT NULL AND vtstatus = 4 ORDER BY vtend ASC" -d vtom -h localhost -p 33909 -U vtom >> $OUTPUT_FILE

#cat $OUTPUT_FILE | sed 12d | sed 's/<tr valign="top"/<tr valign="top" bgcolor=yellow/g' |  grep -v "<tr>" > $OUTPUT_FILE
cat $OUTPUT_FILE | sed 12d | sed '/<tr valign="top"/d' |  grep -v "<tr>" > $OUTPUT_FILE

if [ `/bin/grep TEST_COMMANDES $OUTPUT_FILE | wc -l` -ne 0 ] 
then 
sed -i "/TEST_COMMANDES/i <tr valign="top" bgcolor=deeppink>" $OUTPUT_FILE 
	else 
		if [ `/bin/grep TEST_MOF $OUTPUT_FILE | wc -l` -ne 0 ] 
		then
		sed -i "/TEST_MOF/i <tr valign="top" bgcolor=#FFFF00>" $OUTPUT_FILE 
			else
				if [ `/bin/grep TEST_SFDS $OUTPUT_FILE | wc -l` -ne 0 ]
				then
				sed -i "/TEST_SFDS/i <tr valign="top" bgcolor=#FF0000>" $OUTPUT_FILE 
else 
if [ `/bin/grep TEST_AIDA_LOT2 $OUTPUT_FILE | wc -l` -ne 0 ]
then
sed -i "/TEST_AIDA_LOT2/i <tr valign="top" bgcolor=#0000FF>" $OUTPUT_FILE 
	else
		if [ `/bin/grep TEST_COMMERCIAL $OUTPUT_FILE | wc -l` -ne 0 ]
		then
		sed -i "/TEST_COMMERCIAL/i <tr valign="top" bgcolor=#FFA500>" $OUTPUT_FILE 
			else
				if [ `/bin/grep TEST_STAT $OUTPUT_FILE | wc -l` -ne 0 ]
				then
				sed -i "/TEST_STAT/i <tr valign="top" bgcolor=#8A2BE2>" $OUTPUT_FILE 
fi
		fi
				fi
fi
		fi
				fi

NB_TEST=$(grep "EN-ERREUR" $OUTPUT_FILE|wc -l)

tmail -se "arnaud.lozahic@absyss.com" -to "arnaud.lozahic@absyss.com" -smtp "jupiter" -sub "[VTOM RECETTE] Erreurs ($NB_TEST)" -msg "Statistiques du $DATE_D au $DATE_F extraites le $(date +'%d/%m/%Y a %H:%M')" -att "$OUTPUT_FILE"
