#!/bin/sh

typeset -u rep
clear 

LIST=`cat /home/alozahic/SCRIPTS_SHELL/list_workstations`

for u in ${LIST}
do
  echo ${u}
  ssh ${u} ps -ef | egrep "tws85|netman" | grep -v grep
done 

read rep 
[ "${rep}" = 0 ] && echo "toto"
echo "toto"

echo exit $?
exit $?
