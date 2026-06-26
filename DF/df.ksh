#!/bin/ksh

percent_fs () {

echo "Surveillance FS extraite le $(date +'%d/%m/%Y a %H:%M')"
# alert on fs > 30%
#df -lh | sed 1d | grep -v tmpfs | awk '{ if( $5+0  >30) printf "ALERT FOR %s at %d%%\n",$1, $5 }'
df -lh | sed 1d | grep -v tmpfs | awk '{ if( $5+0  >30) printf "ALERT: Low disk space for %s at %d%%\n",$1, $5 }'

}

#MAIN

percent_fs