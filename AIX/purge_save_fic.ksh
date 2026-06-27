#!/bin/ksh

DATE=$(date "+%Y%m%d%H%M%S")
REP="/savrecv/apps/atlas/atlas2v0/uf1/data1/fic"

cd $REP

find ./ ! -type d -mtime +90 -ls |sed -e 's/\.\///' |awk '{printf "%-75s %2d %3s%6s\n",$NF,$9,$8,$10}' |sort -k 3b,3 -k 2n,2 >/apps/meoatlas2/log/purge.log_$DATE
while read line
do
date=$(echo $line |awk '{print $2,$3}')
job=$(echo $line |awk '{print $1}')
echo "Le fichier $job du $date sera supprime"
rm $REP/$job
done</apps/meoatlas2/log/purge.log_$DATE >/tmp/purge.log_$DATE
