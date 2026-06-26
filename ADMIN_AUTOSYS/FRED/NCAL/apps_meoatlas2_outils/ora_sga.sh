#!/bin/ksh

#set -xv

###################################################################
# Fichier     : ora_sga_pga_use_ram.sh                            #
#                                                                 #
# Objet       : analyse de la memory traget avec la RAM sous AIX  #
#                                                                 #
#                                                                 #
# Création    : HAMMADI Choukri       01/05/2015 - version :1.00  #
#                                                                 #
###################################################################

#//////////////////////////
# DECLARATION DES FONCTIONS
#//////////////////////////



REP_DATA="/tmp"
#REP_DATA="/ficsav/EQUIPE_MEO/choukri/tmp"
SERVEUR_NAME=`hostname|tr 'a-z' 'A-Z'`
FILE_CURRENT_SESSION="${REP_DATA}/ora_sga_use_ram.lst"
LST_SIZE_SGA_SQL="${REP_DATA}/SQL_BUILD_ora_sga_use_ram.lst"
SPOOL_SIZE_SGA_SQL="${REP_DATA}/SPOOL_SQL_BUILD_ora_sga_use_ram.lst"
DATE_T=`date +%d/%m/%Y`
OSLEVEL=`oslevel -s |awk -F"-" '{print $1}'`
USER_ID=`whoami`
ROUGE=`echo "\033[1;31m"`
JAUNE=`echo "\033[1;33m"`
NORMAL=`echo "\033[0;39m"`
VERT=`echo "\033[1;32m"`
BLANC=`echo "\033[1;37m"`
BLUE=`echo "\033[1;34m"`




rm -f ${FILE_CURRENT_SESSION}_* 2>/dev/null
rm -f ${LST_SIZE_SGA_SQL}       2>/dev/null
rm -f ${SPOOL_SIZE_SGA_SQL}     2>/dev/null
rm -f /tmp/poubelle             2>/dev/null

#----------------------------------------------------------------------
# FONCTION    : RESULT ( )
#----------------------------------------------------------------------
# DESCRIPTION : TEST LE CODE RETOUR ET RENVOI LE MESSAGE D'ERREUR
#----------------------------------------------------------------------
RESULT ()
{
RET=$1
        if [ ${RET} -ne 0 ]
        then
                print "\t\t\tFATAL   :  $2"
                exit ${RET}
        fi
}


#----------------------------------------------------------------------
# FONCTION    : SQL_BUILD ( )
#----------------------------------------------------------------------
# DESCRIPTION : PERMET l'EXECUTION DU SCRIPT SQL
#----------------------------------------------------------------------

SQL_BUILD ()
{
echo "-- Extrait la taille de la SGA de l'Instance ORACLE  "                                            >   ${LST_SIZE_SGA_SQL}
echo "set head off"                                                                                     >>  ${LST_SIZE_SGA_SQL}
echo "set feedback off"                                                                                 >>  ${LST_SIZE_SGA_SQL}
echo "set linesize 120"                                                                                 >>  ${LST_SIZE_SGA_SQL}
echo "set spa 0"                                                                                        >>  ${LST_SIZE_SGA_SQL}
echo "set heading off"                                                                                  >>  ${LST_SIZE_SGA_SQL}
echo "set verify off"                                                                                   >>  ${LST_SIZE_SGA_SQL}
echo "set pagesize 0"                                                                                   >>  ${LST_SIZE_SGA_SQL}
echo "set feed off"                                                                                     >>  ${LST_SIZE_SGA_SQL}
echo "set trimspool on "                                                                                >>  ${LST_SIZE_SGA_SQL}
echo "column SGA_TOT format 99,999 "                                                                    >>  ${LST_SIZE_SGA_SQL}
echo "column instance format a16"                                                                       >>  ${LST_SIZE_SGA_SQL}
echo "column appli format a16"                                                                          >>  ${LST_SIZE_SGA_SQL}
echo "spool ${FILE_CURRENT_SESSION} ;"                                                                  >>  ${LST_SIZE_SGA_SQL}
echo "select"                                                                                           >>  ${LST_SIZE_SGA_SQL}
echo "            TO_CHAR(sysdate,'DD/MM/YYYY')                        ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            TRIM('${ORACLE_SID}')                                ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            TRIM(b.name)                                         ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            TRIM(e.host_name)                                    ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            s.sga_size                                           ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            p.pga_alloc_mem_MB                                   ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            m.MAX_PGA_MB                                         ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
#echo "           TRIM(a.sessions_current -(select count(*)  from v\$session where username in ('SYSMAN','DBSNMP')))      ||';'||"    >>  ${LST_SIZE_SGA_SQL}
echo "            TRIM(a.sessions_current)      ||';'||"    >>  ${LST_SIZE_SGA_SQL}
#echo "           TRIM(a.sessions_highwater  -(select count(*) from v\$session  where username in ('SYSMAN','DBSNMP')))   ||';'||"    >>  ${LST_SIZE_SGA_SQL}
echo "            TRIM(a.sessions_highwater)    ||';'||"    >>  ${LST_SIZE_SGA_SQL}
echo "            z.PROCESS_LIMIT                                      ||';'||"                         >>  ${LST_SIZE_SGA_SQL}
echo "            l.active_session                                            "                         >>  ${LST_SIZE_SGA_SQL}
echo "  from v\$license a, v\$database b, v\$sysstat c, v\$instance e,                                                           "    >>  ${LST_SIZE_SGA_SQL}
echo "        (select sum(ROUND(value/1024/1024)) sga_size from v\$sga ) s,                                                      "    >>  ${LST_SIZE_SGA_SQL}
echo "        (select sum(ROUND(pga_alloc_mem/1024/1024)) pga_alloc_mem_MB from v\$process z,v\$session t where  t.paddr = z.addr ) p, " >> ${LST_SIZE_SGA_SQL}
echo "        (SELECT round(VALUE/1048576) MAX_PGA_MB FROM v\$pgastat WHERE NAME='maximum PGA allocated' ) m,                    "    >>  ${LST_SIZE_SGA_SQL}
echo "        (SELECT VALUE PROCESS_LIMIT from v\$parameter where NAME='processes') z,                                           "    >>  ${LST_SIZE_SGA_SQL}
echo "        (select count(*) active_session  from v\$session where status='ACTIVE' and username IS NOT NULL) l                 "    >>  ${LST_SIZE_SGA_SQL}
echo "        Where c.name = 'logons cumulative' ;"                                                     >>  ${LST_SIZE_SGA_SQL}
echo "spool off;"                                                                                       >>  ${LST_SIZE_SGA_SQL}
echo "exit;"                                                                                            >>  ${LST_SIZE_SGA_SQL}
}



#----------------------------------------------------------------------
# FONCTION    : SQL_RQT ( )
#----------------------------------------------------------------------
# DESCRIPTION : PERMET l'EXECUTION DU SCRIPT SQL
#----------------------------------------------------------------------

SQL_RQT ()
{

INST_HOME=`cat /etc/oratab | awk -F":" '$1 ~ /^'${ORACLE_SID}'$/ {print $2}' |uniq`

export ORACLE_HOME=${INST_HOME}
export ORACLE_SID=${ORACLE_SID}

if [ "${USER_ID}" = "oracle" ];
then
        export ORACLE_SID=${ORACLE_SID}; sqlplus -s  '/ as sysdba' @${LST_SIZE_SGA_SQL}  > /tmp/poubelle
else
        su - oracle -c "unset NLS_LANG ;export ORACLE_HOME=${INST_HOME};export PATH=${ORACLE_HOME}/bin:$PATH; export ORACLE_SID=${ORACLE_SID}; sqlplus -s  '/ as sysdba' @${LST_SIZE_SGA_SQL}"  > /tmp/poubelle

fi

        TEST_DB=`cat  ${FILE_CURRENT_SESSION} | grep ";${ORACLE_SID};" | wc -l `

        if [ ${TEST_DB} -eq 1  ];
        then
                cat ${FILE_CURRENT_SESSION} >> ${FILE_CURRENT_SESSION}_${SERVEUR_NAME}
        fi
}

#----------------------------------------------------------------------
# FONCTION    : AFF_SGA_RAM ( )
#----------------------------------------------------------------------
# DESCRIPTION :
#----------------------------------------------------------------------

AFF_SGA_RAM ()
{
         print
         print "${JAUNE}ETAT SGA :${NORMAL}"
         echo "${JAUNE}----------${NORMAL}"

        SGA_TOT_MO=0
        PGA_TOT_MO=0
        MPGA_TOT_MO=0
        SESSION_TOT_RST=0
        MAX_SESSION_TOT_RST=0
        SESSION_ACTIVE_TOT_RST=0
        COMPTEUR=1

        printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "-------" "----------" "------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------"
        printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "NUM" "INSTANCE" "SERVEUR" "SGA (Mo)" "PGA (Mo)" "MAX PGA (Mo)" "NBR SESSION" "SESSION ACTIF" "PIC SESSION" "LIMIT SESSION"
        printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "-------" "----------" "------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------"

        for RESULT_SQL in `cat ${FILE_CURRENT_SESSION}_${SERVEUR_NAME} `
        do
                DATE_RST=`echo ${RESULT_SQL} | awk -F";" '{print $1}'`
                INST_RST=`echo ${RESULT_SQL} | awk -F";" '{print $2}'`
                SERV_RST=`echo ${RESULT_SQL} | awk -F";" '{print $4}'`
                #SGA_RST=`echo ${RESULT_SQL} | awk -F";" '{print $5}'| awk -F"\." '{print $1}'| awk -F"," '{print $1}'`
                SGA_RST=`echo ${RESULT_SQL} | awk -F";" '{print $5}'`
                PGA_RST=`echo ${RESULT_SQL} | awk -F";" '{print $6}'`
                MAX_PGA_RST=`echo ${RESULT_SQL} | awk -F";" '{print $7}'`
                SESSION_RST=`echo ${RESULT_SQL} | awk -F";" '{print $8}'`
                MAX_SESSION_RST=`echo ${RESULT_SQL} | awk -F";" '{print $9}'`
                PROCESS_RST=`echo ${RESULT_SQL} | awk -F";" '{print $10}'`
                SESSION_ACTIVE_RST=`echo ${RESULT_SQL} | awk -F";" '{print $11}'`


               printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "${COMPTEUR}" "${INST_RST}" "${SERV_RST}" "${SGA_RST}" "${PGA_RST}" "${MAX_PGA_RST}" "${SESSION_RST}" "${SESSION_ACTIVE_RST}" "${MAX_SESSION_RST}" "${PROCESS_RST}"

               COMPTEUR=`expr ${COMPTEUR} + 1`

                if [ "${SGA_RST}" != "ND" ];
                then

                        SGA_TOT_MO=` expr ${SGA_TOT_MO} + ${SGA_RST} `
                fi


                if [ "${PGA_RST}" != "ND" ];
                then
                        PGA_TOT_MO=` expr ${PGA_TOT_MO} + ${PGA_RST} `
                fi

                if [ "${MAX_PGA_RST}" != "ND" ];
                then
                        MPGA_TOT_MO=` expr ${MPGA_TOT_MO} + ${MAX_PGA_RST} `
                fi

                if [ "${SESSION_RST}" != "ND" ];
                then
                        SESSION_TOT_RST=` expr ${SESSION_TOT_RST} + ${SESSION_RST} `
                fi

                if [ "${MAX_SESSION_RST}" != "ND" ];
                then
                        MAX_SESSION_TOT_RST=` expr ${MAX_SESSION_TOT_RST} + ${MAX_SESSION_RST} `
                fi

                if [ "${SESSION_ACTIVE_RST}" != "ND" ];
                then
                        SESSION_ACTIVE_TOT_RST=` expr ${SESSION_ACTIVE_TOT_RST} + ${SESSION_ACTIVE_RST} `
                fi




        done

        printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "-------" "----------" "------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------"


        printf "|%7s|%10s|%12s|${BLANC}%13s|%13s|%13s|%13s|%13s|%13s|${NORMAL}%13s|\n" "TOTAL" "----------" "------------" "${SGA_TOT_MO}" "${PGA_TOT_MO}" "${MPGA_TOT_MO}" "${SESSION_TOT_RST}" "${SESSION_ACTIVE_TOT_RST}" "${MAX_SESSION_TOT_RST}" "-------------"
        printf "|%7s|%10s|%12s|%13s|%13s|%13s|%13s|%13s|%13s|%13s|\n" "-------" "----------" "------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------" "-------------"
        echo  "${BLUE}(ND): Non Disponible${NORMAL}"
}

#----------------------------------------------------------------------
# FONCTION    : DELTA_RAM_SGA ( )
#----------------------------------------------------------------------
# DESCRIPTION : SOUSTRACTION DE LA TAILLE DE LA SGA EN REFERENCE DE LA RAM
#               PHYSIQUE DU SERVEUR ET DONNE LE DELTA
#----------------------------------------------------------------------


DELTA_RAM_SGA ()
{
#######################
# ETAT RAM PHYSIQUE  ##
#######################

        print
        print "${JAUNE}ETAT RAM :${NORMAL}"
        echo "${JAUNE}----------${NORMAL}"

                printf "|%12s|%16s|%20s|%20s|\n" "------------" "----------------" "--------------------" "--------------------"
                printf "|%12s|%16s|%20s|%20s|\n" "SERVEUR" "RAM SERVEUR (MB)" "RAM PHYS USED (MB)" "RAM PHY FREE (MB)"
                printf "|%12s|%16s|%20s|%20s|\n" "------------" "----------------" "--------------------" "--------------------"

                RAM_SERV=`svmon -G | awk '$0 ~ /memory/ {print $2*4/1024}'`
                RAM_USED=`svmon -G | awk '$0 ~ /in use/ {printf "%.f \n", $3*4/1024}'`
                DELTA_RAM=` expr ${RAM_SERV} - ${RAM_USED} `

                printf "|%12s|${BLANC}%16s|%20s|%20s|${NORMAL}\n" "${SERVEUR_NAME}" "${RAM_SERV}" "${RAM_USED}" "${DELTA_RAM}"
                printf "|%12s|%16s|%20s|%20s|\n" "------------" "----------------" "--------------------" "--------------------"


}

DELTA_SGA_PGA ()
{
#######################
# ETAT SGA + PGA     ##
#######################

        print
        print "${JAUNE}ETAT SGA + PGA :${NORMAL}"
        echo "${JAUNE}----------------${NORMAL}"

                printf "|%12s|%12s|%12s|%20s|%20s|\n" "------------" "------------" "------------" "--------------------" "--------------------"
                printf "|%12s|%12s|%12s|%20s|%20s|\n" "SERVEUR"  "SGA RAM (MB)" "PGA RAM (MB)" "TOTAL SGA+PGA (MB)" "TOTAL SGA+MAX_PGA"
                printf "|%12s|%12s|%12s|%20s|%20s|\n" "------------" "------------" "------------" "--------------------" "--------------------"

                RAM_SERV=`svmon -G | awk '$0 ~ /memory/ {print $2*4/1024}'`
                RAM_USED=`svmon -G | awk '$0 ~ /in use/ {printf "%.f \n", $3*4/1024}'`

                #DELTA_RAM=` expr ${RAM_SERV} - ${SGA_TOT_MO} `
                TOTAL_SGAPGA=` expr ${SGA_TOT_MO} + ${PGA_TOT_MO} `
                TOTAL_SGAMAXPGA=` expr ${SGA_TOT_MO} + ${MPGA_TOT_MO} `

                printf "|%12s|${BLANC}%12s|%12s|%20s|%20s|${NORMAL}\n" "${SERVEUR_NAME}" "${SGA_TOT_MO}" "${PGA_TOT_MO}"  "${TOTAL_SGAPGA}" "${TOTAL_SGAMAXPGA}"
                printf "|%12s|%12s|%12s|%20s|%20s|\n" "------------" "------------" "------------" "--------------------" "--------------------"

}

DELTA_SESSION ()
{
#######################
# ETAT SESSION       ##
#######################

        print
        print "${JAUNE}ETAT SESSION :${NORMAL}"
        echo "${JAUNE}--------------${NORMAL}"

                printf "|%12s|%20s|%20s|\n" "------------" "--------------------" "--------------------"
                printf "|%12s|%20s|%20s|\n" "SERVEUR"  "NBR SESSION" "MAX NBR SESSION"
                printf "|%12s|%20s|%20s|\n" "------------" "--------------------" "--------------------"

                printf "|%12s|${BLANC}%20s|%20s|${NORMAL}\n" "${SERVEUR_NAME}" "${SESSION_TOT_RST}" "${MAX_SESSION_TOT_RST}"
                printf "|%12s|%20s|%20s|\n" "------------" "--------------------" "--------------------"
}



#----------------------------------------------------------------------
# FONCTION    : ETAT_SWAP ( )
#----------------------------------------------------------------------
# DESCRIPTION : INDICATION DE l'UTILISATION DE L'ESPACE DE SWAP
#----------------------------------------------------------------------

ETAT_SWAP ()
{
#######################
# ETAT SWAP          ##
#######################


                print
                print "${JAUNE}ETAT SWAP :${NORMAL}"
                echo "${JAUNE}-----------${NORMAL}"

                printf "|%11s|%12s|%12s|%12s|\n"  "-----------" "-------------" "-------------" "-------------"
                printf "|%11s|%12s |%12s |%12s |\n"  "Page Space" "SIZE " "%Used" "PRECO"
                printf "|%11s|%12s|%12s|%12s|\n"  "-----------" "-------------" "-------------" "-------------"

                for SWAP_RESULT in `/usr/sbin/lsps -a  | awk 'NR>1 {print $1";"$4";"$5}' `
                do

                        LV_SWAP=`echo ${SWAP_RESULT} | awk -F";" '{print $1}' `
                        SIZE_SWAP=`echo ${SWAP_RESULT} | awk -F";" '{print $2}' `
                        USE_SWAP=`echo ${SWAP_RESULT} | awk -F";" '{print $3}' `


                        if [ ${USE_SWAP} -gt 40 ];

                        then
                                PRECO="KO"
                        else
                                PRECO=${VERT}"          OK"${NORMAL}
                        fi

                        printf "|%11s|${BLANC}%12s |%12s${NORMAL} |%12s |\n"  "${LV_SWAP}" "${SIZE_SWAP}" "${USE_SWAP}" "${PRECO}"

                done
                printf "|%11s|%12s|%12s|%12s|\n"  "-----------" "-------------" "-------------" "-------------"



}

#----------------------------------------------------------------------
# FONCTION    : TOP_15_SWAP ( )
#----------------------------------------------------------------------
# DESCRIPTION : SI L'ESPACE DE SWAP DEPASSE LES 40%
#               PERMET DE VISUALISER LES 15 PROCESSUS LES PLUS CONSOMMATEURS
#               DANS L'ESPACE DE SWAP
#----------------------------------------------------------------------


TOP_15_SWAP ()
{
#######################
# TOP 15 SWAP        ##
#######################

print
print "${ROUGE}TOP 15 DES PROCESSUS QUI UTILISE LA SWAP${NORMAL}"
echo "${ROUGE}------------------------------------------${NORMAL}"
                printf "|%5s|%11s|%12s|%12s|%50s |\n" "-----" "-----------" "-------------" "-------------" "--------------------------------------------------"
                printf "|%5s|%11s|%12s |%12s |%50s |\n" "NUM" "PID" "COMMAND" "TAILLE (Mo)" "PROCESS"
                printf "|%5s|%11s|%12s|%12s|%50s |\n"  "-----" "-----------" "-------------" "-------------" "--------------------------------------------------"


COMPTEUR2=1


for TOP_SWAP in `svmon -P -O sortseg=pgsp| grep -v "\----" | grep -v "Pid Command" |awk ' $0 !~ /^$/' |sort -rk5 |awk 'NR<15 {print $1";"$2";"$5}'`
#for TOP_SWAP in `svmon -gP -t 15 |grep -p Pid|grep '^.*[0-9]' |  grep -v Pid |awk '{print $1";"$2";"$5}'`
do
        COMPTEUR2=`expr ${COMPTEUR2} + 1`
        PID_SWAP=`echo ${TOP_SWAP} | awk -F";" '{print $1}'`
        CMD_SWAP=`echo ${TOP_SWAP} | awk -F";" '{print $2}'`
        SIZE_SWAP=`echo ${TOP_SWAP} | awk -F";" '{print $3*4/1024}' | awk -F"\." '{print $1}'`
        NAME_PROC=`ps -ef | grep ${PID_SWAP} |grep -v grep | awk '{print $9}'`

        printf "|%5s|%11s|%12s |%12s |%50s |\n"  "${COMPTEUR2}" "${PID_SWAP}" "${CMD_SWAP}" "${SIZE_SWAP}" "${NAME_PROC}"
done
                printf "|%5s|%11s|%12s|%12s|%50s |\n" "-----" "-----------" "-------------" "-------------" "--------------------------------------------------"

}


#---------------------------------------------------------------------------------------------------
# FONCTION    : FCT_TRAIT ( )
#---------------------------------------------------------------------------------------------------
# DESCRIPTION : Fonction Principale qui fait appel à toute les autres
#              Permet d'Extraire la Liste des Bases de données à partir du fichier /etc/oratab
#---------------------------------------------------------------------------------------------------

FCT_TRAIT ()
{
for NAME_INSTANCE in `cat /etc/oratab | awk -F":"  '$0 !~ /^$/ && $1 !~ /^#/ && $1 !~ /^\*/ {print $1}'`
do

                export ORACLE_HOME=`cat /etc/oratab | awk  -F":" '$1 ~ /^'${NAME_INSTANCE}'$/ {print $2}'`

                if [ "${ORACLE_HOME}" = "/apps/oracle" ]
                then
                      case ${SERVEUR_NAME} in
                            1) export ORACLE_HOME="/home/oracle" ;;
                                    *) export ORACLE_HOME="/apps/oracle/product/9.2.0"

                        esac

                fi

                export PATH="${ORACLE_HOME}/bin:$PATH"
                export ORACLE_SID="${NAME_INSTANCE}"
                export APPLI="${NAME_INSTANCE}"

                TEST_INSTANCE=`ps -ef |  grep ora_smon_ |awk '$NF  ~ /^ora_smon_'${NAME_INSTANCE}'$/' | wc -l `

                RECUP_ENV_BASE=` cat /etc/oratab | awk -F":" '$1 ~ /^'${ORACLE_SID}'$/ {print $2}'`

        if [ ! -z "${RECUP_ENV_BASE}" ];
        then
                export  LIBPATH=${RECUP_ENV_BASE}/lib:${LIBPATH}
                export  PATH=${RECUP_ENV_BASE}/bin:${PATH}
        fi


        #//////////////////////////
        # PROGRAMME PRINCIPAL
        #//////////////////////////

        if [ ${TEST_INSTANCE} -eq 1 ];
        then

                SQL_BUILD

                if [ -s  ${LST_SIZE_SGA_SQL} ];
                then
                        SQL_RQT

                        if [ ${TEST_DB} -eq 0 ];
                        then
                                echo "${DATE_T};${ORACLE_SID};${APPLI};${SERVEUR_NAME};ND;ND;ND;ND;ND;ND;ND;ND;ND" >> ${FILE_CURRENT_SESSION}_${SERVEUR_NAME}
                        fi
                fi
        else
                echo "${DATE_T};${ORACLE_SID};${APPLI};${SERVEUR_NAME};ND;ND;ND;ND;ND;ND;ND;ND;ND" >> ${FILE_CURRENT_SESSION}_${SERVEUR_NAME}

        fi


done

#######################
# AFFICHAGE SGA RAM  ##
#######################

AFF_SGA_RAM

##################
# ETAT RAM      ##
##################

DELTA_RAM_SGA

DELTA_SGA_PGA

DELTA_SESSION

##################
# ETAT SWAP     ##
##################

ETAT_SWAP

if [ ${OSLEVEL} -eq 5200 ] && [ "${PRECO}" == "KO" ] && [ ${USER_ID} != "oracle" ];
then
        TOP_15_SWAP
fi

if [ ${OSLEVEL} -ge 5300 ] && [ "${PRECO}" == "KO" ];
then
        TOP_15_SWAP
fi


rm -f ${FILE_CURRENT_SESSION}_* 2>/dev/null
rm -f ${LST_SIZE_SGA_SQL}       2>/dev/null
rm -f ${SPOOL_SIZE_SGA_SQL}     2>/dev/null
rm -f /tmp/poubelle             2>/dev/null


}
##################################
# DEBUT  DU PROGRAMME          ###
##################################

if  [ "${USER_ID}" != "root" ] && [ "${USER_ID}" != "oracle" ];
then
        STATUS=16
        RESULT ${STATUS} "Le Script $0 doit être lancé avec le User : Root où Oracle"
fi

if [ -s /etc/oratab ];
then
        FCT_TRAIT
else
        STATUS=16
        RESULT ${STATUS} "Pas de Fichier /etc/oratab sur le Serveur : ${SERVEUR_NAME}"
fi
