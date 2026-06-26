#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport html
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global_RU ()
{
        echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">" >>${_FICHTML_RU}
        echo "<html><head><title>jobs running</title>" >>${_FICHTML_RU}
        echo "<meta http-equiv="Content-Type" content="text/html\;charset=windows-1252">" >>${_FICHTML_RU}
        echo "<meta content="MSHTML 6.00.2900.3157" name="GENERATOR"></head>" >>${_FICHTML_RU}
        echo "<p><hr><b>" >>${_FICHTML_RU}
        echo "RAPPORT DES ${toto} JOBS EN RUNNING LE ${_ODATE}" >>${_FICHTML_RU}
        echo "</b><hr></p>" >>${_FICHTML_RU}
        echo "<body>" >>${_FICHTML_RU}
        echo "<table border=0 align="middle" bgcolor="#CCFFFF" width="60%">" >> ${_FICHTML_RU}
        echo "<tr bgcolor="#C0C0C0">" >>${_FICHTML_RU}
        echo "<td>" >>${_FICHTML_RU}
        echo "<b>JOB</b>" >>${_FICHTML_RU}
        echo "</td>" >>${_FICHTML_RU}
        echo "<td>" >>${_FICHTML_RU}
        echo "<b>STARTDATE</b>" >>${_FICHTML_RU}
        echo "</td>" >>${_FICHTML_RU}
        echo "<td>" >>${_FICHTML_RU}
        echo "<b>STARTTIME</b>" >>${_FICHTML_RU}
        echo "</td>" >>${_FICHTML_RU}
        echo "<td>" >>${_FICHTML_RU}
        echo "<b>STATUS</b>" >>${_FICHTML_RU}
        echo "</td>" >>${_FICHTML_RU}
        echo "<td>" >>${_FICHTML_RU}
        echo "<b>PORT</b>" >>${_FICHTML_RU}
        echo "</td>" >>${_FICHTML_RU}
        echo "</tr>" >>${_FICHTML_RU}
        cat ${FIC} | awk '{print $1,$2,$3,$5,$6}' | while read line
        do
                        echo "<tr bgcolor="#FFFFFF">" >>${_FICHTML_RU}
                        echo "<td>" >>${_FICHTML_RU}
                        echo "$(echo ${line} | awk -F" " '{print $1}')" >>${_FICHTML_RU}
                        echo "</td>" >>${_FICHTML_RU}
                        echo "<td>" >>${_FICHTML_RU}
                        echo "$(echo ${line} | awk -F" " '{print $2}')" >>${_FICHTML_RU}
                        echo "</td>" >>${_FICHTML_RU}
                        echo "<td>" >>${_FICHTML_RU}
                        echo "$(echo ${line} | awk -F" " '{print $3}')" >>${_FICHTML_RU}
                        echo "</td>" >>${_FICHTML_RU}
                        echo "<td>" >>${_FICHTML_RU}
                        echo "$(echo ${line} | awk -F" " '{print $4}')" >>${_FICHTML_RU}
                        echo "</td>" >>${_FICHTML_RU}
                        echo "<td>" >>${_FICHTML_RU}
                        echo "$(echo ${line} | awk -F" " '{print $5}')" >>${_FICHTML_RU}
                        echo "</td>" >>${_FICHTML_RU}
                        echo "</tr>" >>${_FICHTML_RU}

        done
        echo "</table>" >>${_FICHTML_RU}
        echo "<br>" >>${_FICHTML_RU}
        echo "</body>" >>${_FICHTML_RU}
        echo "</html>" >>${_FICHTML_RU}
}


# Main
#############################################################
# Initialisation des variables n ayant pas a etre modifiees #
#############################################################

DATE=`date +"%y%m%d_%H%M%S"`
ODATE=`date +"%Y%m%d"`
_ODATE=`date +"%d/%m/%Y"`
#DATE=$(date "+%Y%m%d a %H%M%S")
REP=/ficsav/EQUIPE_MEO/arnaud
FIC=${REP}/jobs_RU.txt_PY
_FICHTML_RU=${REP}/rapport_RU_${ODATE}.html
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

> ${_FICHTML_RU}
fonc_rapport_global_RU

if [ $? == 0 ]
then
        uuencode rapport_RU_${ODATE}.html rapport_RU_${ODATE}.html | mailx -s "Rapport Jobs en Running ${ODATE}" arnaud.lozahic@externe.bnpparibas.com
fi


echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
