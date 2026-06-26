#!/bin/bash
#
#=========================================================================================================
# script : script exploit applis SOLIS (demarrage appserver OE)
#=========================================================================================================

nompgm='start-app-test.sh'
dateexec=`date +"%Y%m%d"`
heureexec=`date +"%T"`
dateheure=${dateexec}-${heureexec}
erreur=0
pathlog='/data/solis/scripts'
pathpgm='/data/programmes/progress/OpenEdge/bin'
pathWRK='/data/solis/travail'
env=TEST
action=$2

echo >> ${pathlog}/${nompgm}${env}.log
echo ========================================== >> ${pathlog}/${nompgm}${env}.log
echo broker : START  - ${env} - ${dateheure} >> ${pathlog}/${nompgm}${env}.log

${pathpgm}/asbman -i oapp_${env} -start >> ${pathlog}/${nompgm}${env}.log

if [ "${action}" = "stop" ]; then
        mv ${pathWRK}/oapp_${env}.broker.log ${pathWRK}/${dateexec}.oapp_${env}.broker.log
        mv ${pathWRK}/oapp_${env}.server.log ${pathWRK}/${dateexec}.oapp_${env}.server.log
        rm ${pathWRK}/dataserv.lg
        find ${pathWRK} -name "*.log" -mtime +15 -exec rm -f {} \;
fi

echo FIN - ${dateheure} >> ${pathlog}/${nompgm}${env}.log
echo ========================================== >> ${pathlog}/${nompgm}${env}.log
echo >> ${pathlog}/${nompgm}${env}.log

exit ${erreur}
