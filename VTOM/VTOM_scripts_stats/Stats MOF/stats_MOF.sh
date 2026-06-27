echo "ENV/APP/JOB;MACHINE;USER;BEGIN;END;ELAPSE;STATUS"
vtstools -local -f MIDDLE_OFFICE -export $1 $1 \
| awk -F\; '{printf("%s/%s/%s;%s;%s;%s;%s;%s;%s\n",$1,$2,$3,$7,$9,$10,$11,$12,$18)}' \
| grep -v "^.JOB_STAT." \
| grep -v "^ENV/APP/JOB;MACHINE" > /tmp/stat_$$.csv
while read app; do
  grep "MIDDLE_OFFICE/$app" /tmp/stat_$$.csv
done < MOF.txt
