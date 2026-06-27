#!/bin/ksh -x
# ----------------------------------------------------------------------------
# Rapport csv
# ----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
echo "DEBUT JOB ${CTM0} $(date "+%Y%m%d-%H%M%S")"
#----------------------------------------------------------------------------- #

fonc_rapport_global ()
{

        echo "SCHEDULE;SCHEDTIME;JOB;STATUS;PRIORITY;START;ELAPSE;RETCODE;DEPS;ACTION">${_FICCSV}
        cat ${FIC} | egrep "ABEND|rerun" | while read line
        do
                TOTO=$(echo ${line} | awk -F"#" '{print $2}' | awk -F" " '{print $6}')
                ABEND=$(echo ${line} | awk -F" " '{print $2}')
                rerun=$(echo ${line} | awk -F" " '{print $1}')

                if [ ${TOTO} == "ABEND" ]
                then
                        echo "$(echo ${line} | awk -F" " '{print $1,";",$2,$3,";",$4,$5,";",$6,";",$7,";",$8,";",$9,";","",";",$10,";",$11,";",$12}')" >>${_FICCSV}
                fi

                if [ ${ABEND} == "ABEND" ]
                then
                        echo "$(echo ${line} | awk -F" " '{print "",";","",";",$1,";",$2,";",$3,";",$4,";",$5,";",$6,";",$7,";",$8}')" >>${_FICCSV}
                fi

                if [ "${rerun}" == ">>rerun as" ];
                then
                        echo "$(echo ${line} | awk -F" " '{print "",";","",";",$1,";",$2,";",$3,";",$4,";",$5,";",$6,";",$7,";",$8}')" >>${_FICCSV}
                fi
        done
}


fonc_rapport_jobs_win ()
{
        echo "" >>${_FICCSV}
        echo "JOBS WINDOWS" >>${_FICCSV}
        cat ${FIC_INFO} | awk -F "\\" '{print $6}' | awk NF | while read line
        do
                        echo "$(echo ${line} | awk '{print $1}')" >>${_FICCSV}
        done
}


fonc_rapport_jobs_unix ()
{
        echo "" >>${_FICCSV}
        echo "JOBS_UNIX" >>${_FICCSV}
        cat ${FIC_INFO} |  awk -F "/" '{print $6}' | awk NF | while read line
        do
                        echo "$(echo ${line} | awk '{print $1}')" >>${_FICCSV}

        done
}


purge_rapports ()
{
find -name "rapport*csv" -type f -mtime +1 -exec rm -f {} \;
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
FIC_INFO=${REP}/jobs_abend_paging_info.txt
_FICCSV=${REP}/rapport_${ODATE}.csv 
ENTETE=${REP}/entete

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

cd ${REP}
#entete > ${FILE_LOG}
fonc_rapport_global
fonc_rapport_jobs_unix
fonc_rapport_jobs_win

if [ $? == 0 ]
then
    email -s "[PROD][TWS] : Report of the jobs in error le $(date "+%Y%m%d a %H%M%S")" Arnaud_LOZAHIC@europ-assistance.fr -a ${_FICCSV} < ${ENTETE}
fi

purge_rapports

echo ""
echo "#### FIN JOB ${CTM0} $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}
