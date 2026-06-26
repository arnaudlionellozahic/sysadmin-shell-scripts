#!/bin/ksh -x

entete ()
{
echo "applis;mode;heure_debut;heure_fin;type_periodicite;cyclique;cycle;periodicite;machine;queue;status;retenu;demande;ne_pas_deplanifier;attendre_avant_deplanification;liens_vers;liens_de;planning;ressources;jobs;position"
}

req1 ()
{
for j in $list_app
do
 vtexport -f "$j" | sed -e 's/\(app\&.*\)/RECORD_SEP\1/' -e 's/\(position\&.*\)/\1RECORD_SEP/' | awk 'BEGIN{ RS="RECORD_SEP" } /app\&.*position\&.*/ { print $0 }' | perl -pi -e 's/\[app:/app\&/g;s/mode=/mode\&/g;s/heure_debut=/heure_debut\&/g;s/heure_fin=/heure_fin\&/g;s/type_periodicite=/type_periodicite\&/g;s/cyclique=/cyclique\&/g;s/cycle=/cycle\&/g;s/periodicite=/periodicite\&/g;s/machine=/machine\&/g;s/queue=/queue\&/g;s/utilisateur=/utilisateur&/g;s/status=/status\&/g;s/retenu=/retenu\&/g;s/demande=/demande\&/g;s/ne_pas_deplanifier=/ne_pas_deplanifier\&/g;s/attendre_avant_deplanification=/attendre_avant_deplanification\&/g;s/liens_vers=/liens_vers\&/g;s/liens_de=/liens_de\&/g;s/planning=/planning\&/g;s/ressources=/ressources\&/g;s/jobs=/jobs\&/g;s/position=/position\&/g'
done
}


rajout_champ_1 ()
{
for u in `cat $list_toto`
do
if [ `/bin/grep utilisateur $list_toto | wc -l` -ne 1 ]
then
perl -pi -e 'print "utilisateur&\n" if ($.==11)' $list_toto
fi
done
}

rajout_champ_2 ()
{
for u in `cat $list_toto`
do
if [ `/bin/grep ressources $list_toto | wc -l` -ne 1 ]
then
perl -pi -e 'print "ressource&=\n" if ($.==20)' $list_toto 
fi
done
}

req2 ()
{
cat $out1 | sed 's/#//g;s/;/ /g' | awk -F "&" 'BEGIN {deb=""}
  $1 == "app" { printf "\n%-s%-s",$2,";"}
  $1 == "mode" { printf "%-s%-s",$2,";"}
  $1 == "heure_debut" { printf "%-s%-s",$2,";"}
  $1 == "heure_fin" { printf "%-s%-s",$2,";"}
  $1 == "type_periodicite" { printf "%-s%-s",$2,";"}
  $1 == "cyclique" { printf "%-s%-s",$2,";"}
  $1 == "cycle" { printf "%-s%-s",$2,";"}
  $1 == "periodicite" { printf "%-s%-s",$2,";"}
  $1 == "machine" { printf "%-s%-s",$2,";"}
  $1 == "queue" { printf "%-s%-s",$2,";"}
  $1 == "utilisateur" { printf "%-s%-s",$2,";"}
  $1 == "status" { printf "%-s%-s",$2,";"}
  $1 == "retenu" { printf "%-s%-s",$2,";"}
  $1 == "demande" { printf "%-s%-s",$2,";"}
  $1 == "ne_pas_deplanifier" { printf "%-s%-s",$2,";"}
  $1 == "attendre_avant_deplanification" { printf "%-s%-s",$2,";"}
  $1 == "liens_vers" { printf "%-s%-s",$2,";"}
  $1 == "liens_de" { printf "%-s%-s",$2,";"}
  $1 == "planning" { printf "%-s%-s",$2,";"}
  $1 == "ressources" { printf "%-s%-s",$2,";"}
  $1 == "jobs" { printf "%-s%-s",$2,";"}
  $1 == "position" { printf "%-s%-s\n",$2,";"}
' > $out2

}


# Main
out=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/export_application.csv
entete > $out

#env=$1
env=SOUMISSION_ORIGI
out1=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/export_tmp.txt
out2=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/export_tmp2.txt
rep=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD

list_app=$(vtexport -f $env | grep "\[app:" | sed 's/\]//g;s/app://g;s/\[//g')
list_toto=$(vtexport -f $env | grep "\[app:" | sed 's/\]//g;s/app://g;s/\[//g' | awk -F "/" '{print $2}'

for i in $list_toto
do
req1 > $rep/$i
done

cd $rep
rajout_champ_1
rajout_champ_2

cat $list_toto > $out1

req2
cat $out2 | sed 's/\];/;/' >> $out 

rm -f $out1
rm -f $out2

tmail -se "arnaud.lozahic@absyss.fr" -to "arnaud.lozahic@absyss.fr" -smtp "jupiter" -sub "export_applications" -att "$out" -msgf "$out"

