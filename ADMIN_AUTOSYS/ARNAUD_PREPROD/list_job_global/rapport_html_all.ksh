#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>Recapitulatif des jobs Autosys en erreur </title>" >>${_FICHTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML}
        echo "<p><hr><b>" >>${_FICHTML}
        echo "RAPPORT DES JOBS EN ERREUR LE ${_ODATE}" >>${_FICHTML}
        echo "</b><hr></p>" >>${_FICHTML}
        echo "<body>" >>${_FICHTML}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="60%">" >> ${_FICHTML}
        echo "<tr bgcolor="#C0C0C0">" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>JOB</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>STARTDATE</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>STARTTIME</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>ENDDATE</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>ENDTIME</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>STATUS</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>PORT</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>RETCODE</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "</tr>" >>${_FICHTML}
        cat ${FIC} | grep FA | while read line
        do
                TOTO=$(echo ${line} | awk '{print $6}')

                if [ ${TOTO} == "FA" ]
                then
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $1}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $2}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $3}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $4}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $5}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $6}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $7}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" " '{print $8}')" >>${_FICHTML}
                        echo "</td>" >>${_FICHTML}
                        echo "</tr>" >>${_FICHTML}
                fi

        done
        echo "</table>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
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
FIC=${REP}/report.log_PL
_FICHTML=${REP}/rapport_${ODATE}.html


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

> ${_FICHTML}
fonc_rapport_global

if [ $? == 0 ]
then
	uuencode rapport_${ODATE}.html rapport_${ODATE}.html | mailx -s "TESTING" arnaud.lozahic@externe.bnpparibas.com
fi



echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}