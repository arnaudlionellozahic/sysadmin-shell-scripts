echo "ENV/APP/JOB;MACHINE;USER;BEGIN;END;ELAPSE;STATUS"
vtstools -local -f FIDELIO_LOT2 -export $1 $1 \
| awk -F\; '{printf("%s/%s/%s;%s;%s;%s;%s;%s;%s\n",$1,$2,$3,$7,$9,$10,$11,$12,$18)}' \
| grep -v "^.JOB_STAT." \
| grep -v "^ENV/APP/JOB;MACHINE" > /tmp/stat_$$.csv
while read app; do
  grep "FIDELIO_LOT2/$app" /tmp/stat_$$.csv
done < FIDELIO.txt
