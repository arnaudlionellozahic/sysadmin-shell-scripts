#!/bin/ksh

export INTERVAL=10
export COUNT=720

export LOG=/home4/alozahic/exploit/systeme/suivi/TRAINING/SHELL/20120627/while_loop_test.log

export CTR=0
while [ true ]
do
	if [ ${CTR} -ge ${COUNT} ]
	then
		exit
	fi
	echo "#------- $(date)" >> ${LOG}
	ps -fu alozahic | grep -v while_loop >> ${LOG}
	CTR=$(expr ${CTR} + 1)
	sleep ${INTERVAL}
done
exit $?
