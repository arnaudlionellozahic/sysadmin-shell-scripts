#!/bin/ksh
req () 
{ 
./psql -A -F \; -t -c "SELECT vtenvname, vtapplname, vtjobname,vtend - vtbegin, vtexpdatevalue, vtretcode, vterrmess,vtbegin, vtend FROM vt_stats_job WHERE $CLAUSE AND vtretcode !=0 AND vtjobname IS NOT NULL AND  vtenvname = 'Callisto2' ORDER BY vtbegin " -d vtom -h localhost -p 30109 -U vtom 

} 

DATE_D=`date --date '0 days ago' +%y%m%d`; DATE_F=$DATE_D; CLAUSE="vtexpdatevalue = cast ('$DATE_D' as date)" 
aaaa=`date +%Y` 
aa=`date +%y` 

liste=`req | awk -F ";" '{printf "%s_%s_%s_%s\n" ,$1,$2,$3,$8}'| sed -e "s/$aaaa/$aa/g;s/-//g;s/ /-/g;s/://g"` 
echo $liste 
