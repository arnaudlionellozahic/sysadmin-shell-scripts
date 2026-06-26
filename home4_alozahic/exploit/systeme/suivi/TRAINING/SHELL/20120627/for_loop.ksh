#!/bin/ksh

export LIST="athis lisses"

export LOG=/home4/alozahic/exploit/systeme/suivi/TRAINING/SHELL/20120627/throw_away.log

for SERVER in ${LIST}
do
  # each loop has a different value for ${SERVER}
  echo "#------- values from ${SERVER}" >> ${LOG}
#  ssh  ${SERVER} 
  rsh  ${SERVER} 
  "ps -fu alozahic" >> ${LOG}
done

# say goodnight, Gracie
exit $? 
