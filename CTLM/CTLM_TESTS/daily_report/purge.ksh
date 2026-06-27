#!/bin/ksh -x

find /slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS -type f -mtime +0 -exec rm -f {} \;
