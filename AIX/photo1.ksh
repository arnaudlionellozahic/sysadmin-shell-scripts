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

Date :- `date`

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

Service Pack version
`oslevel -s`

****************************************

"oslevel -r" : `oslevel -r`

****************************************

"oslevel -sq|head" : `oslevel -sq|head`

****************************************

Run level : `who -r`

****************************************

UPTIME :- `uptime`

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

lparstat -l
-----------

`lparstat -l`

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

`lsattr -El aio0`

****************************************

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
=====No. of processes on SERVER =====
=====================================

Total processes on server :- `ps -ef | wc -l`

****************************************

Processes pmon on server / Bases on line
----------------------------------------

"
for i in `ps -ef -o args | grep pmon | grep -v grep | cut -d_ -f3`
 do
  echo "Processes for $i :- `ps -ef | grep $i | grep -v grep | wc -l`"
 done

echo "

=====================================
=====  Oldest oracle processes  =====
=====================================

Should ideally be DBWR, PMON

`ps -A -o user,pid,etime,group,args | grep oracle | grep - | sort -rn +2 | head -20`

=====================================
=====      Mail queue size      =====
=====================================

"
echo "x *" |mailx -u oracle | grep messages |awk '{print $2}'

echo "

=====================================
=====    <defunct> processes   ======
=====================================

`ps -el | grep 'Z'`


=====================================
===== Top CPU, Memory, IO pro.  =====
=====================================

Top 10 CPU processes
--------------------

`ps auxgw |head -1; ps auxgw |sort -rn +2 | head -10`

****************************************

Top 10 MEMORY processes
-----------------------

`svmon -Pt10 | perl -e 'while(<>){print if($.==2||$&&&!$s++);$.=0 if(/^-+$/)}'`

"
#ps aux | head -1; ps aux | sort -rn +4 | head -10`

echo "
****************************************

Top 10 DISKS by I/O
-------------------
"
iostat | head -7; iostat | sed "1d;2d;3d;4d;5d;6d;7d;\$d" | sort -rn +1 | head -10

echo "


=====================================
=====  Mount Point Information  =====
=====================================
"
df -g | head -1 | awk '{printf("%-38s %-9s %-9s %-7s %-7s %-4s\n",$1,$2,$4,$5,$7,$8)}' ; df -g | sed "1d;\$d" | sort -rn +3 | awk '{printf("%-38s %-9s %-9s %-7s %-7s %-4s\n",$1,$2,$3,$4,$6,$7)}'

echo "

=====================================
=====     Network statistics    =====
=====================================
"
netstat -rni | head -1 | awk '{printf("%-5s %-6s %-12s %-17s %-10s %-5s %-10s %-5s %-4s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' ; netstat -rni | sed "1d;\$d" | awk '{printf("%-5s %-6s %-12s %-17s %-10s %-5s %-10s %-5s %-4s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}'


#cp -p /etc/filesystems /etc/filesystems_${DATE}

}


# Main

#DATE=$(date +"%Y%m%d.%H%M%S")
DATE=$(date +"%Y%m%d")
HOST=`uname -n`
TRACE=Photo_${HOST}_${DATE}

sysstat > ${TRACE}

#clear
#menu


# LEXIQUE AIX
# -----------
# who -r : Indicates the current run-level of the process
# lparstat : Reports logical partition ( LPAR ) related information and statistics.
# lsdev : Displays devices in the system and their characteristics
# lsattr : Displays attribute characteristics and possible values of attributes for devices in the system
# getconf : Writes system configuration variable values to standard output
# vmo : Manages Virtual Memory Manager tunable parameters
# ulimit : Sets or reports user resource limits
# lsps : Displays the characteristics of a paging space
# iostat : Reports Central Processing Unit (CPU) statistics, asynchronous input/output (AIO) and input/output statistics for the entire system, adapters, TTY devices, disks and CD-ROMs
# mpstat : Collects and displays performance statistics for all logical CPUs in the system.


# Service Pack dispo
# `oslevel -sq`
