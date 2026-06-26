#!/bin/ksh -x

out=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/export_application.csv
in=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/import_application.csv
out1=/home/alozahic/exploit/systeme/suivi/RANGE/ABSYSS/EXTRACTION_EXPORT/EXPORT_APPLIS_ARNAUD/export_temp.csv

cat $out > $out1
sed -i -e "1d;/^$/d;s/A_VENIR/AV/g;s/EN_COURS/EN/g;s/TERMINE/TE/g;s/EN_ERREUR/EN/g;s/DEPLANIFIE/DE/g;s/NON_PLANIFIE/NP/g" $out1
cat $out1 | awk -F 'FS' 'BEGIN{FS=";"}{for (i=1; i<=NF-1; i++) if((i!=19) && (i!=18) && (i!=15) && (i!=13)) {printf $i FS};{print line}}' > $in

IFS=";"
while read a b c d e f g h i j k l m n o p; do; echo vtaddapp /Nom=$a /Mode=$b /Hdeb=$c /Hfin=$d /TypePer=$e /Cyclique=$f /Cycle=$g /Per=$h /Machine=$i /Queue=$j /status=$k /Retenu=$l /NonDepl=$m /LienVers=$o /LienDe=$p; done < $in

rm -f $out1