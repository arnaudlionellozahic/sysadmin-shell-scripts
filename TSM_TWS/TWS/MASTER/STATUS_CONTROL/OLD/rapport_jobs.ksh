#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>Recapitulatif des jobs TWS en erreur </title>" >>${_FICHTML}
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
        echo "<b>STATUS</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>PRIORITY</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>START</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>ELAPSE</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>RETCODE</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>DEPS</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "<td>" >>${_FICHTML}
        echo "<b>ACTION</b>" >>${_FICHTML}
        echo "</td>" >>${_FICHTML}
        echo "</tr>" >>${_FICHTML}
        cat ${FIC} | egrep "ABEND|rerun" | while read line
        do
                ABEND=$(echo ${line} | awk -F" " '{print $2}')
                rerun=$(echo ${line} | awk -F" " '{print $1}')

                if [ ${ABEND} == "ABEND" ]
                then
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" "  '{print $1}')" >>${_FICHTML}
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
                if [ "${rerun}" == ">>rerun as" ];
                then
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML}
                        echo "<td>" >>${_FICHTML}
                        echo "$(echo ${line} | awk -F" "  '{print $1}')" >>${_FICHTML}
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
        echo "<p><hr><b>" >>${_FICHTML}
        echo "TEST" >>${_FICHTML}
        echo "</b><hr></p>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
}


# Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
ODATE=`date +"%Y%m%d"`
_ODATE=`date +"%d/%m/%Y"`
REP=/home/alozahic/SCRIPTS_SHELL/TWS/MASTER/STATUS_CONTROL
FIC=${REP}/jobs_abend_paging.txt
_FICHTML=${REP}/rapport_${ODATE}.html
>${_FICHTML}

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

#entete > ${FILE_LOG}
fonc_rapport

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
