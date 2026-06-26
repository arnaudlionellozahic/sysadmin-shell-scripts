#!/bin/ksh

_CODE=0
DATE=`date +"%Y%m%d_%H%M%S"`
rep_source="/slqdl7bdd01/appli/dl7/sp/scripts"

if [ ${_CODE} -eq 0 ]; then
cd ${rep_source}
	for u in `ls -1 *csv`
		do	
		cp ${u} done/${u}_${DATE}
		done	
	_CODE=$?
	echo "exit ${_CODE}"
	exit ${_CODE}
fi
