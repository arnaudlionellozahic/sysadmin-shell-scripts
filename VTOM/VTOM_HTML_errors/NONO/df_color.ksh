echo -e "\\033[1;31m " ; df -k | egrep  '9[0-9]%|100%' ; echo -en "\\033[0;39m"
echo -en "\\033[1;35m" ; df -k | grep  8[0-9]% ; echo -en "\\033[0;39m"
echo -en "\\033[1;33m" ; df -k | grep  7[0-9]% ; echo -en "\\033[0;39m"
#
# df -k avec tri decroissant sur le % d'occupation
#
#df -h | grep -v on | grep -v tmpfs | printf "%-30s %+15s %+15s %+15s %+10s %+10s \n" $(cut -f1) $(cut -f2) $(cut -f3) $(cut -f4) $(cut -f5)
#
df -h | awk 'BEGIN {
      deb="" }
       length($0)<35 { deb=$1 ; printf "%-s ",$deb }
       length($0)>35 { printf "%s\n",$0 }
      '|grep -v on | grep -v tmpfs | sort -n | printf "%-30s %+15s %+15s %+15s %+10s %+10s \n" $(cut -f1) $(cut -f2) $(cut -f3) $(cut -f4) $(cut -f5)
echo -e "\\033[1;31m " ; df -k | egrep  '7[0-9]%|100%' ; echo -en "\\033[0;39m" > df_log.txt
echo -e "\\033[1;31m " ; df -k | egrep  '8[0-9]%|100%' ; echo -en "\\033[0;39m" > df_log.txt
echo -e "\\033[1;31m " ; df -k | egrep  '9[0-9]%|100%' ; echo -en "\\033[0;39m" > df_log.txt

