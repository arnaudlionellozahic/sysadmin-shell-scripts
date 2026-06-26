#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global_FA ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML_FA}
        echo "<html><head><title>jobs erreur</title>" >>${_FICHTML_FA}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML_FA}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML_FA}
        echo "<p><hr><b>" >>${_FICHTML_FA}
        echo "RAPPORT DES ${toto} JOBS EN ERREUR LE ${_ODATE}" >>${_FICHTML_FA}
        echo "</b><hr></p>" >>${_FICHTML_FA}
        echo "<body>" >>${_FICHTML_FA}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="60%">" >> ${_FICHTML_FA}
        echo "<tr bgcolor="#C0C0C0">" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>JOB</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>STARTDATE</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>STARTTIME</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>ENDDATE</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>ENDTIME</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>STATUS</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>PORT</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "<td>" >>${_FICHTML_FA}
        echo "<b>RETCODE</b>" >>${_FICHTML_FA}
        echo "</td>" >>${_FICHTML_FA}
        echo "</tr>" >>${_FICHTML_FA}
        cat ${FIC} | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $1}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $2}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $3}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $4}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $5}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $6}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $7}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "<td>" >>${_FICHTML_FA}
                        echo "$(echo ${line} | awk -F" " '{print $8}')" >>${_FICHTML_FA}
                        echo "</td>" >>${_FICHTML_FA}
                        echo "</tr>" >>${_FICHTML_FA}

        done
        echo "</table>" >>${_FICHTML_FA}
        echo "<br>" >>${_FICHTML_FA}
        echo "</body>" >>${_FICHTML_FA}
        echo "</html>" >>${_FICHTML_FA}
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
FIC=${REP}/jobs_error.txt_PL
_FICHTML_FA=${REP}/rapport_FA_${ODATE}.html
toto=`grep -w FA $FIC | wc -l`

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

> ${_FICHTML_FA}
fonc_rapport_global_FA

if [ $? == 0 ]
then
        uuencode rapport_FA_${ODATE}.html rapport_FA_${ODATE}.html | mailx -s "Rapport Jobs en Erreur ${ODATE}" arnaud.lozahic@externe.bnpparibas.com
fi


echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
