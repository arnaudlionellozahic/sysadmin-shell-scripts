#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global_OI ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML_OI}
        echo "<html><head><title>jobs ice</title>" >>${_FICHTML_OI}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML_OI}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML_OI}
        echo "<p><hr><b>" >>${_FICHTML_OI}
        echo "RAPPORT DES ${toto} JOBS EN ICE LE ${_ODATE}" >>${_FICHTML_OI}
        echo "</b><hr></p>" >>${_FICHTML_OI}
        echo "<body>" >>${_FICHTML_OI}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="60%">" >> ${_FICHTML_OI}
        echo "<tr bgcolor="#C0C0C0">" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>JOB</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>STARTDATE</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>STARTTIME</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>ENDDATE</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>ENDTIME</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>STATUS</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>PORT</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "<td>" >>${_FICHTML_OI}
        echo "<b>RETCODE</b>" >>${_FICHTML_OI}
        echo "</td>" >>${_FICHTML_OI}
        echo "</tr>" >>${_FICHTML_OI}
        cat ${FIC} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $1}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $2}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $3}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $4}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $5}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $6}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $7}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "<td>" >>${_FICHTML_OI}
                        echo "$(echo ${line} | awk -F" " '{print $8}')" >>${_FICHTML_OI}
                        echo "</td>" >>${_FICHTML_OI}
                        echo "</tr>" >>${_FICHTML_OI}

        done
        echo "</table>" >>${_FICHTML_OI}
        echo "<br>" >>${_FICHTML_OI}
        echo "</body>" >>${_FICHTML_OI}
        echo "</html>" >>${_FICHTML_OI}
}


# Main
#############################################################
# Initialisation des variables n ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
ODATE=`date +"%Y%m%d"`
_ODATE=`date +"%d/%m/%Y"`
#DATE=$(date "+%Y%m%d a %H%M%S")
REP=/apps/meoatlas2/arnaud
FIC=${REP}/jobs_ice.txt_PL
_FICHTML_OI=${REP}/rapport_OI_${ODATE}.html
toto=`cat $FIC | wc -l`

#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------
echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo ""
echo "#### DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
echo ""

> ${_FICHTML_OI}
fonc_rapport_global_OI

if [ $? == 0 ]
then
        uuencode rapport_OI_${ODATE}.html rapport_OI_${ODATE}.html | mailx -s "Rapport Jobs en Ice ${ODATE}" arnaud.lozahic@externe.bnpparibas.com
fi


echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
