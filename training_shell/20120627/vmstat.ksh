#!/bin/ksh

echo "#--- $(date)" >> vmstat.log
vmstat  2  5	>> vmstat.log

exit $?
