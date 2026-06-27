#! /bin/ksh

set -x


OUTPUT_FILE=$VTOM_KSH/ENVOI_LOGS/logs.txt
OUTPUT_FILE2=$VTOM_KSH/ENVOI_LOGS/step1.txt
OUTPUT_FILE3=/tmp/logs.txt

> $OUTPUT_FILE2
> $OUTPUT_FILE3

#Suppression des espaces par caractere = et transformation du format de la date 2012-10-25 en 121025
perl -pi -e "s/ /=/g" $OUTPUT_FILE | sed -i -e 's%[0-9][0-9]\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)%\1\2\3%' $OUTPUT_FILE
#Suppression des : de l'heure et remplacement de = par - pour avoir le format de la date de la log
perl -pi -e "s/://g" $OUTPUT_FILE | perl -pi -e "s/=/-/g" $OUTPUT_FILE

#Extraction de ENV APP TRAITEMENT et la date et heure de l'erreur
awk -F";" '{print $1,$2,$3,$4}' $OUTPUT_FILE > $OUTPUT_FILE2
perl -pi -e "s/ /_/g" $OUTPUT_FILE2
#Rajout de .o a la fin de chaque ligne
sed -i -e 's/$/.o/' $OUTPUT_FILE2
\cp $OUTPUT_FILE2 $OUTPUT_FILE3

for toto in `cat $OUTPUT_FILE3`
do
tmail -se "arnaud.lozahic@absyss.com" -to "arnaud.lozahic@absyss.com" -smtp "jupiter" -sub "[Envoi des logs erreur]" -att "$ABM_LOGS/$toto" -msgf "$ABM_LOGS/$toto"
done
