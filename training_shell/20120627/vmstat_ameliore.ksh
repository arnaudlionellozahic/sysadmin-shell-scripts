#!/bin/ksh
# ----------------------------------------------------
# capture_vmstat.sh	<INTERVAL> <COUNT>
#	<INTERVAL> vmstat interval
#	<COUNT>	vmstat count
# run vmstat and capture output to a log file
#-----------------------------------------------------

# indicate defaults for how often and for how long 
# to run vmstat
export INTERVAL=2		# every 2 seconds
export COUNT=5		# do it 5 times

# obtain command line arguments, if present
if [ "${1}" != "" ]
then
	INTERVAL=${1}
	# if there is one command line argument, 
	# maybe there's two
	if [ "${2}" != "" ]
	then
	COUNT=${2}
	fi
fi

# directories where scripts and logs are stored
export PROGDIR=/home4/alozahic/exploit/systeme/suivi/TRAINING/SHELL/20120627
export LOGDIR=/home4/alozahic/exploit/systeme/suivi/TRAINING/SHELL/20120627

# define logfile name and location
export LOG_FILE=${LOGDIR}/capture_vmstat.${LOGNAME}.log

# write current date/time to log file
echo "#--- $(date)"		>> ${LOG_FILE}
vmstat  ${INTERVAL}  ${COUNT}	>> ${LOG_FILE}

# say goodnight, Gracie
exit $?
