#!/bin/bash
#
#=========================================================================================================
# script : script exploit applis SOLIS (demarrage appserver OE)
# qui : quand : quoi
# OPA : 21/09/2016 : création
#=========================================================================================================

nompgm='startup-app-PROD.sh'
dateexec=`date +"%Y%m%d"`                    
heureexec=`date +"%T"`
dateheure=${dateexec}-${heureexec}
erreur=0
pathlog='/opt/solis/scripts/log'
pathpgm='/opt/solis/progress/OpenEdge/bin'


echo >> ${pathlog}/${nompgm}.log
echo ========================================== >> ${pathlog}/${nompgm}.log
${pathpgm}/asbman -i oapp_prod -x >> ${pathlog}/${nompgm}.log
echo FIN - ${dateheure} >> ${pathlog}/${nompgm}.log
echo ========================================== >>${pathlog}/${nompgm}.log
echo >> ${pathlog}/${nompgm}.log
 
exit ${erreur}
