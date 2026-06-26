#!/bin/ksh

#df output, sorted by Use% and correctly maintaining header row
#
#-----------------------------------------------------------
#
#df -h | egrep -v "Use|tmpfs" | sort -rn -k 5
#/dev/sda2               1014M  237M  778M  24% /boot
#/dev/mapper/centos-var   1.9G  227M  1.7G  12% /var
#/dev/mapper/centos-root   14G  1.6G   13G  12% /
#/dev/sda1                599M  7.5M  592M   2% /boot/efi
#
#-----------------------------------------------------------
#
#df -h | awk 'BEGIN {
#      deb="" }
#       length($0)<35 { deb=$1 ; printf "%-s ",$deb }
#       length($0)>35 { printf "%s\n",$0 }
#      '| egrep -v "Use|tmpfs" | sort -rn -k 5 | printf "%-30s %+15s %+15s %+15s %+10s %+10s \n" $(cut -f1) $(cut -f2) $(cut -f3) $(cut -f4) $(cut -f5)
#/dev/sda2                                1014M            237M            778M        24%      /boot
#/dev/mapper/centos-var                    1.9G            227M            1.7G        12%       /var
#/dev/mapper/centos-root                    14G            1.6G             13G        12%          /
#/dev/sda1                                 599M            7.5M            592M         2%  /boot/efi
#
#-----------------------------------------------------------

df -hP | awk '{ print $0 | " grep -v on | grep -v tmpfs | sort -rn -k 5 "}'