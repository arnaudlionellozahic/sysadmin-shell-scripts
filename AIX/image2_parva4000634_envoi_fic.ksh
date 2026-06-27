#!/usr/bin/ksh

function sysstat
{

echo "

####################################################################

0. Health Check Report (CPU,Process,Disk Usage, Memory)

####################################################################

=====================================
===== Server Name, Date, UPtime =====
=====================================

****************************************

Hostname : `hostname`
Hostname : `uname -a`

****************************************

Kernel Version : `ls -l /unix | awk '{print $11}'`
Kernel Version : `getconf -a | grep -i kernel`
Kernel Version : `getconf -a | grep -i hard`

****************************************

****************************************

OS Version
Fileset                                 Actual Level        Maintenance Level
-----------------------------------------------------------------------------
`oslevel -g`

****************************************

Known Service Packs
-------------------
`oslevel -sq|head`

****************************************

Run level : `who -r`

****************************************


=====================================
======== CPU and Memory Info ========
=====================================

**************************************************************************************
**************************************************************************************

          CPU :- `lsdev | grep Processor | wc -l`

       Memory :- `lsattr -El mem0 | tail -1`

**************************************************************************************
**************************************************************************************

Lists details on the LPAR configuration : lparstat -i
-----------------------------------------------------

`lparstat -i`

****************************************


=====================================
===== Important Kernel Params =======
=====================================

lsattr : Displays attribute characteristics and possible values of attributes for devices in the system

****************************************

`lsattr -El sys0`

****************************************

****************************************

ulimit
------
`ulimit -a`

****************************************


=====================================
====== CPU Usage Information ========
=====================================

VMSTAT : CPU USED : `vmstat -wI 3 3 | tail -1 | awk '{print ($15+$16)"%"}'`

**************************************************************************************

MPSTAT : CPU USED : display per-processor statistics; 12 seconds apart; 5 times
`mpstat 12 2`

**************************************************************************************

SAR : CPU USED
--------------
"
#Generate the CPU utilization stats with 5 lines /every 2 seconds.
#Needs sysstat package to be installed prior to use sar
#sar -u 2 5
sar -u 5 10

#topas -c 4 -i 2
echo "

=====================================
===== Memory Usage Information ======
=====================================

RAM SERVER (EN MB) : `svmon -O unit=MB | awk '$0 ~ /memory/ {print $2}'`
RAM USED (EN MB) : `svmon -O unit=MB | awk '$0 ~ /memory/ {print $3}'`
RAM FREE (EN MB) : `svmon -O unit=MB | awk '$0 ~ /memory/ {print $4}'`
"

um=`svmon -G | head -2|tail -1| awk {'print $3'}`
um=`expr $um / 256`
tm=`lsattr -El sys0 -a realmem | awk {'print $2'}`
tm=`expr $tm / 1024`
fm=`expr $tm - $um`
ump=`expr $um \* 100`
ump=`expr $ump / $tm`

echo "

****************************************

Memory Used :- $ump"%"

total memory = $tm MB
free memory = $fm MB
used memory = $um MB
"
#VMO parameters
#vmo -a | grep -Ei "maxperm|minperm|maxcli"
echo "

****************************************

=====================================
=====   Page file usage info.   =====
=====================================

`lsps -s`


=====================================
=====   Bases Oracle on line    =====
=====================================

"
ps -ef -o args | grep pmon | grep -v grep | cut -d_ -f3

echo "

=====================================
=====       Oracle version      =====
=====================================

The version of Oracle is `grep A2_ORAVER /apps/exploit/tng/lance_Maro | awk -F"=" '{print $2}'`"

echo "

=====================================
==== FS Mount Point Information  ====
=====================================
"
# List fs : lsfs or df or mount
df -g | head -1 | awk '{printf("%-38s %-9s %-9s %-7s %-7s %-4s\n",$1,$2,$4,$5,$7,$8)}' ; df -g | sed "1d;\$d" | sort -rn +3 | awk '{printf("%-38s %-9s %-9s %-7s %-7s %-4s\n",$1,$2,$3,$4,$6,$7)}'

echo "

=====================================
=====     Network statistics    =====
=====================================
"
netstat -rni | head -1 | awk '{printf("%-5s %-6s %-12s %-17s %-10s %-5s %-10s %-5s %-4s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' ; netstat -rni | sed "1d;\$d" | awk '{printf("%-5s %-6s %-12s %-17s %-10s %-5s %-10s %-5s %-4s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}'


#cp -p /etc/filesystems /etc/filesystems_${DATE}

echo "

=====================================
=====      Syncsort version     =====
=====================================
"
if [ -d "/apps/syncsort" ]; then
cd /apps/syncsort
echo "The version of syncsort is : `ls | grep -v lost | head -1`"
   else
   cd /apps/dmexpress
   echo "The version of syncsort is : `ls | grep -v lost | head -1`"
fi

echo ""

}


function envoi_cft
{
if [ -s ${TRACE} ]; then
   echo "Le fichier ${TRACE} existe et n'est pas vide"
   scp -p /tmp/Photo_${HOST}_${DATE} root@s00va9949995:/tmp
       else
       echo "Le fichier ${TRACE} est vide ou n'existe pas"
       echo "exit 1"
       exit 1
fi
}


# Main

#DATE=$(date +"%Y%m%d.%H%M%S")
DATE=$(date +"%Y%m%d")
HOST=`uname -n`
REP=/tmp
TRACE=${REP}/Photo_${HOST}_${DATE}
LOG=${REP}/image_cft_log.txt

cd $REP
find /tmp -name "Photo_${HOST}*" -type f -mtime +10 -exec rm -f {} \;
sysstat > ${TRACE}

# Envoi du rapport par cft
envoi_cft > $LOG
