#
# script de surveillance des dates bloquees sous VTOM
# auteur : PORRY Nicolas
# date de creation : 16/08/2010
# modification le 1er juin 2011 AL

set -xv

FIC_LOG=/exploit/systeme/suivi/ps_bloque/surveil_ps_bloque.log

# Recuperation de la date du jour
DATE=`date "+%d %h %H:%M"`

{
  echo ""
  echo "           Verification des processus SUNOPSIS bloques le $DATE sur COQEXPL1"
  echo ""
  ps -edf | grep sunopsis | grep -v java | grep -v grep | awk -F " " '{print $1"  "$2"  "$3"  "$4" "$5" "$6"       "$7" "$8" "$9}' 
} > $FIC_LOG

if [ `/bin/grep sunopsis $FIC_LOG | wc -l` -ne 0 ] 
then
	/bin/mailx -s "PROCESS JAVA EN COURS SUR COQEXPL1" arnaud.lozahic@mondial-assistance.fr < $FIC_LOG
fi
