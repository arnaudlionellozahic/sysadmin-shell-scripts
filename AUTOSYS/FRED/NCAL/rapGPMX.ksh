#!/bin/ksh

#set -x
export DATEJOB=`date "+%Y%m%d.%H%M%S"`
export TEMP=/apps/meoatlas2/outils/Rapport_GPMX/rapGPMX/rapport_rapeur${DATEJOB}.log
exec 1>$TEMP
exec 2>&1
export DATEMAIL=`date "+%d/%m/%Y à %H:%M"`
export STAT="$(hostname)_stat.vacation.${DATEJOB}"
export SAUVE_TEMP="/apps/meoatlas2/outils/Rapport_GPMX/rapGPMX/Rapport_job_temp_$DATEJOB"
export SAUVE="/apps/meoatlas2/outils/Rapport_GPMX/rapGPMX/$STAT"
export AUTOSERV=P13
. /etc/auto.profile
export ORACLE_SID=$(chk_auto_up | grep -i "Have Connected successfully" | head -1 | cut -d":" -f2 | cut -d"." -f1 |sed 's/ //g')
export DATE=$(date +"%Y/%m/%d %T")
export DATEVEILLE="$(TZ=CET+24 date +"%Y/%m/%d %T")"
export FILE=/apps/meoatlas2/outils/Rapport_GPMX/rapGPMX/envoiemail.ma

#Lancement du script perl qui check tous le jobs en cours, running ou failure

/apps/meoatlas2/autosys/autosys_rapjour.pl -j % -f "$DATEVEILLE" -t "$DATE" |grep -v BWAEP01 >$SAUVE_TEMP

#SED qui permet de rajouter les control-M pour les sauts a la ligne
if [[ -e $SAUVE_TEMP ]] then
sed '/^ *$/d' $SAUVE_TEMP >$SAUVE
fi

#Purge des fichiers de logs de plus de 7 jours
cd /apps/meoatlas2/outils/Rapport_GPMX/rapGPMX/
#find . -mtime +1 -exec rm {} \;


rm $SAUVE_TEMP
