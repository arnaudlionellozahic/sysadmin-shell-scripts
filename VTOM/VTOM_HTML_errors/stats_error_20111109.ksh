#! /bin/ksh

OUTPUT_FILE=/tmp/$(basename $0)-out.$$; touch $OUTPUT_FILE
trap "rm -f $OUTPUT_FILE" 0 1 2 5 15

case $# in
  0) DATE_D=$(date +"%Y-%m-%d"); DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = CURRENT_DATE";;
  1) DATE_D=$1; DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = cast ('$DATE_D' as date)";;
  2) DATE_D=$1; DATE_F=$2; CLAUSE="vtexpdatevalue >= cast ('$DATE_D' as date) AND vtexpdatevalue <= cast ('$DATE_F' as date)";;
  *) echo "Nombre d'arguments incorrect"; exit 1;;
esac

/produit/vtom/v52/sgbd/bin/psql -A -F \; -t -c "SELECT vtenvname, vtapplname, vtjobname, vtbegin, vtend, vtend - vtbegin, vtexpdatevalue, vtnbretry, 'EN-ERREUR', vtretcode, vterrmess FROM vt_stats_job WHERE $CLAUSE AND vtjobname IS NOT NULL  AND vtstatus = 4 ORDER BY vtend ASC" -d vtom -h localhost -p 30009 -U vtom > $OUTPUT_FILE
NB_TEST=$(grep "^T" $OUTPUT_FILE|wc -l)
{
  echo "Statistiques du $DATE_D au $DATE_F extraites le $(date +'%d/%m/%Y a %H:%M')"
  echo ""
  echo "Recette ($NB_TEST jobs)"
  echo "-------"
  echo "ENVIRONNEMENT;APPLICATION;TRAITEMENT;DEBUT;FIN;DUREE;DATE_EXPLOITATION;RELANCE;STATUT;CODE_RETOUR;MESSAGE"
  grep "^T" $OUTPUT_FILE
} | /bin/mailx -s "[VTOM RECETTE] Erreurs ($NB_TEST)" mail_exploit
