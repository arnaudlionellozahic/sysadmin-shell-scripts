#! /bin/ksh

set -x 

OUTPUT_FILE=$VTOM_KSH/ENVOI_LOGS/logs.txt 

case $# in
  0) DATE_D=$(date +"%Y-%m-%d"); DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = CURRENT_DATE";;
  1) DATE_D=$1; DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = cast ('$DATE_D' as date)";;
  2) DATE_D=$1; DATE_F=$2; CLAUSE="vtexpdatevalue >= cast ('$DATE_D' as date) AND vtexpdatevalue <= cast ('$DATE_F' as date)";;
  *) echo "Nombre d'arguments incorrect"; exit 1;;
esac

$TOM_HOME/sgbd/bin/psql -A -F \; -t -c "SELECT vtenvname, vtapplname, vtjobname, vtbegin, vtend, vtend - vtbegin, vtexpdatevalue, vtnbretry, vtretcode, vterrmess FROM vt_stats_job WHERE vtexpdatevalue=CURRENT_DATE AND vtjobname IS NOT NULL AND vtstatus=4 ORDER BY vtend ASC" -d vtom -h centos63 -p 33909 -U vtom > $OUTPUT_FILE

#Controle avant modification pour la couleur
NB_TEST=$(grep "erreur" $OUTPUT_FILE|wc -l)
echo $NB_TEST

NB_TEST=$(grep "erreur" $OUTPUT_FILE|wc -l)

#tmail -se "arnaud.lozahic@absyss.com" -to "arnaud.lozahic@absyss.com" -smtp "jupiter" -sub "[ARNAUD_ERREURS_VTOM] ($NB_TEST)" -msg "Statistiques du $DATE_D au $DATE_F extraites le $(date +'%d/%m/%Y a %H:%M')" -att "$OUTPUT_FILE" -msgf "$OUTPUT_FILE"
