#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global_OH ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML_OH}
        echo "<html><head><title>jobs hold</title>" >>${_FICHTML_OH}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML_OH}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML_OH}
        echo "<p><hr><b>" >>${_FICHTML_OH}
        echo "RAPPORT DES ${toto} JOBS EN HOLD LE ${_ODATE}" >>${_FICHTML_OH}
        echo "</b><hr></p>" >>${_FICHTML_OH}
        echo "<body>" >>${_FICHTML_OH}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="60%">" >> ${_FICHTML_OH}
        echo "<tr bgcolor="#C0C0C0">" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>JOB</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>STARTDATE</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>STARTTIME</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>ENDDATE</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>ENDTIME</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>STATUS</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>PORT</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "<td>" >>${_FICHTML_OH}
        echo "<b>RETCODE</b>" >>${_FICHTML_OH}
        echo "</td>" >>${_FICHTML_OH}
        echo "</tr>" >>${_FICHTML_OH}
        cat ${FIC} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $1}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $2}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $3}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $4}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $5}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $6}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $7}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "<td>" >>${_FICHTML_OH}
                        echo "$(echo ${line} | awk -F" " '{print $8}')" >>${_FICHTML_OH}
                        echo "</td>" >>${_FICHTML_OH}
                        echo "</tr>" >>${_FICHTML_OH}

        done
        echo "</table>" >>${_FICHTML_OH}
        echo "<br>" >>${_FICHTML_OH}
        echo "</body>" >>${_FICHTML_OH}
        echo "</html>" >>${_FICHTML_OH}
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
FIC=${REP}/jobs_hold.txt_KSH
_FICHTML_OH=${REP}/rapport_OH_${ODATE}.html
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

> ${_FICHTML_OH}
fonc_rapport_global_OH

if [ $? == 0 ]
then
        uuencode rapport_OH_${ODATE}.html rapport_OH_${ODATE}.html | mailx -s "Rapport Jobs en Hold ${ODATE}" arnaud.lozahic@externe.bnpparibas.com
fi


echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
