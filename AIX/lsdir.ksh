#!/usr/bin/ksh

for i in `lsvg -o|grep -v rootvg`
do
        File=/tmp/${i}.lst
        > $File
        for j in `lsvg -l $i|egrep -v "N/A|MOUNT POINT"|awk '{print $7}'|grep -v "^$"`
        do
                LV=`df $j|tail -1|awk '{print $1}'`
                echo "LV : $LV Mount Point : $j" >> $File
                find $j -type d >> $File
        done
done
