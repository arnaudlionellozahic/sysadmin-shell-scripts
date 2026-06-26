#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global_FA ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>statut des jobs</title>" >>${_FICHTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML}
        echo "<p><hr><b>" >>${_FICHTML}
        if [ ${toto} -lt 1 ]; then
        echo "PAS DE JOBS EN ERREURS LE ${_ODATE}" >>${_FICHTML}
        echo "<hr><br />" >>${_FICHTML}
        echo "<br />" >>${_FICHTML}
        fonc_rapport_global_RU
        fonc_mail
        echo $?
        exit $?
             else
             echo "RAPPORT DES ${toto} JOBS EN ERREUR LE ${_ODATE}" >>${_FICHTML}
        fi
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
        grep -w FA ${FIC} | while read line
        do
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

        done
        echo "</table>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
}


fonc_rapport_global_RU ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>jobs erreur</title>" >>${_FICHTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML}
        echo "<p><hr><b>" >>${_FICHTML}
        if [ ${titi} -lt 1 ]; then
        echo "PAS DE JOBS EN RUNNING LE ${_ODATE}" >>${_FICHTML}
             else
             echo "RAPPORT DES ${titi} JOBS EN RUNNING LE ${_ODATE}" >>${_FICHTML}
        fi
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
        grep -w RU ${FIC} | while read line
        do
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

        done
        echo "</table>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
}


fonc_rapport_global_OH ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>jobs erreur</title>" >>${_FICHTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML}
        echo "<p><hr><b>" >>${_FICHTML}
        if [ ${hold} -lt 1 ]; then
        echo "PAS DE JOBS EN HOLD LE ${_ODATE}" >>${_FICHTML}
             else
             echo "RAPPORT DES ${hold} JOBS ON HOLD LE ${_ODATE}" >>${_FICHTML}
        fi
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
        grep -w OH ${FIC} | while read line
        do
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
						
        done
        echo "</table>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
}


fonc_rapport_global_OI ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML}
        echo "<html><head><title>jobs erreur</title>" >>${_FICHTML}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML}
        echo "<p><hr><b>" >>${_FICHTML}
        if [ ${ice} -lt 1 ]; then
        echo "PAS DE JOBS EN RUNNING LE ${_ODATE}" >>${_FICHTML}
             else
             echo "RAPPORT DES ${ice} JOBS ON ICE LE ${_ODATE}" >>${_FICHTML}
        fi
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
        grep -w OI ${FIC} | while read line
        do
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

        done
        echo "</table>" >>${_FICHTML}
        echo "<br>" >>${_FICHTML}
        echo "</body>" >>${_FICHTML}
        echo "</html>" >>${_FICHTML}
}


fonc_mail ()
{
if [ $? == 0 ]
then
        uuencode rapport_${ODATE}.html rapport_${ODATE}.html | mailx -r "480076" -s "Rapport des Jobs Autosys en FA,RU,OH,OI le ${_ODATE}" arnaud.lozahic@externe.bnpparibas.com
fi
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
#FIC_FA=${REP}/jobs_error.txt_KSH
FIC=${REP}/report.log_KSH
#FIC_RU=${REP}/jobs_running.txt_KSH
_FICHTML=${REP}/rapport_${ODATE}.html
toto=`awk '$0 ~/\<FA\>/' ${FIC} | wc -l`
titi=`awk '$0 ~/\<RU\>/' ${FIC} | wc -l`
hold=`awk '$0 ~/\<OH\>/' ${FIC} | wc -l`
ice=`awk '$0 ~/\<OI\>/' ${FIC} | wc -l`

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
fonc_rapport_global_FA
fonc_rapport_global_RU
fonc_rapport_global_OH
fonc_rapport_global_OI
fonc_mail


echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
