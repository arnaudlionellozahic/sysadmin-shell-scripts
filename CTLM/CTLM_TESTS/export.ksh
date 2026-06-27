#!/bin/ksh -x

entete ()
{
echo "ORDERID;JOBNAME;TYPE;ODATE;STATE;STATUS;FROMTIME;UNTIL"
}

req ()
{
for i in $list
do
ctmpsm -LISTALL | grep $i
done
}

#Main
list=`cat /tmp/liste_AJF.txt`
out=/tmp/export.csv
out2=/tmp/export_temp.txt
entete > $out
req >> $out2
cat $out2 | sed 's/|/;/g' >> $out
