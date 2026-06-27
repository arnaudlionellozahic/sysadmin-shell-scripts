#!/usr/bin/ksh
. /usr/bin/EnvironnementTNG
#DATE=$(date +'%Y%m%d%H%M')
DATE=$(date +'%Y%m%d')
HEURE=$(date +'%H:%M')
LOG=/apps/meoatlas2/outils/jfu_jobs_average
ARCHIVE=/apps/meoatlas2/outils/jfu_jobs_average/archive
HOST=$(hostname)
#FILE="$LOG/${HOST}_history_jfu_${DATE}"
FILE="$LOG/${HOST}_history_jfu"

$CAIGLBL0000/sche/scripts/schdhist "*" "jfu*" > $FILE 2>$1

awk -f $LOG/filter.awk $FILE >> ${FILE}.csv
FILE2="${FILE}.csv"

#gzip -f $FILE2
rm -f $FILE
grep "Date job available" ${FILE}.csv | head -1 > ${FILE}.csv.head
grep -v "Date job available" ${FILE}.csv > ${FILE}.csv.body
sort -u ${FILE}.csv.body | grep 2017 > ${FILE}.csv.tmp
cat ${FILE}.csv.tmp >> ${FILE}.csv.head
mv ${FILE}.csv.head ${FILE}.csv
rm -f ${FILE}.csv.head ${FILE}.csv.body ${FILE}.csv.tmp
cp -p ${FILE}.csv ${ARCHIVE}/${HOST}_history_jfu.${DATE}.csv
gzip -f ${LOG}/archive/${HOST}_history_jfu.${DATE}.csv

