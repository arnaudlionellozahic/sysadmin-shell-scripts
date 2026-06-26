#!/bin/ksh
##############################################################################
# Fichier     : RESTAURATION_RMAN_HOT.sh                                     #
#                                                                            #
# Objet       : Restauration de la Base Oracle AUTOSYS                       #
#                                                                            #
# Création    : HAMMADI Choukri       01/02/2016                             #
#                                                                            #
##############################################################################
export LIBPATH=$ORACLE_HOME/lib32:$ORACLE_HOME/lib:$LIBPATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib32:$ORACLE_HOME/lib:$LD_LIBRARY_PATH
export NLS_LANG=French_FRANCE.WE8ISO8859P15
export NLSPATH=/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/%L/%N.cat
export ETIQUETTE="RESTAURATION_RMAN_HOT"

MODE="INFO"
NOR=`echo "\033[0;39m"`
VERT=`echo "\033[5;30;42m"`
JAUNE=`echo "\033[1;33m"`
BLUE=`echo "\033[1;34m"`
ROUGE=`echo "\033[5;30;41m"`

#============================================================================#
# INITIALISATIONS                                                            #
#============================================================================#
export script=`basename $0 .ksh`

#############################
# DECLARATION DES FONCTIONS #
#############################
function err_exit #[mess]
{
        echo ERREUR [$1]
        exit -1
}

RESULT ()
{
RET=$1
        if [ ${RET} -ne 0 ]
        then
                print "`date +%Y%d%m_%H:%M:%S ` : FATAL : Echec de Traitement  : $2"                            | tee -a ${FLOG}
                exit ${RET}
        fi
}

#============================================================================#
# FONCTION PRINCIPALE                                                        #
#============================================================================#


SANS_ARGS=0
E_ERREUROPTION=16

if [ $# -eq "$SANS_ARGS" ]  # Script appelé sans argument?
then
  echo "Usage: `basename $0` options (-i -c )"
  exit $ERREUROPTION                            # Sort et explique l'usage, si aucun argument(s)
                                                # n'est donné.
fi

# Usage: nomscript -options
# Note: tiret (-) nécessaire

NAME_FILE_CTL=""

while getopts :i:c: opt
do
        case $opt in
            i)  ORACLE_SID="$OPTARG";;
            c)  NAME_CONTROL_FILE="$OPTARG";;
            \?)  echo "erreur option $opt inconnue"; exit 1;;
        esac

        echo "option trouvee; $opt ${BLUE}OK${NOR}"
        sleep 2
done

if [ -z "${ORACLE_SID}" ];then
        echo "Usage: `basename $0` options -i <ORACLE_SID> "
        STATUS=16
        RESULT ${STATUS} "Le NOM DE LA BASE  doit ETRE INITIALISE AVEC L'OPTION -i "
fi

if [ -z "${NAME_CONTROL_FILE}" ];then
        echo "Usage: `basename $0` options -c <NAME CONTROLFILE> "
        STATUS=16
        RESULT ${STATUS} "Le NOM DU FICHIER DE CONTROLE doit ETRE INITIALISE AVEC L'OPTION -c "
fi

if [ ! -f ${NAME_CONTROL_FILE} ];then
        echo "LE FICHIER DE CONTROL : ${NAME_CONTROL_FILE} N'EXISTE PAS "
        STATUS=16
        RESULT ${STATUS} "Le FICHIER DE CONTROL : ${NAME_CONTROL_FILE} N'EXISTE PAS"
else
        REP_SAVE=`dirname ${NAME_CONTROL_FILE}`
fi


export FLOG=${REP_SAVE}/${script}_.log

trace_INFO()

{

       if [ "$1" = "INFO" ]
       then
                 s_timestamp=`date '+%d/%m/%Y %H:%M:%S'`
                 #  echo "${s_timestamp} ** $2"
                 echo "********************************************************************************************************"  | tee -a ${FLOG}
                 echo "${s_timestamp} ** $2"                                                                                      | tee -a ${FLOG}
                 echo "********************************************************************************************************"  | tee -a ${FLOG}
       else
                 echo "$1 : $2"                                                                                  | tee -a ${FLOG}
      fi

}

RMAN_RESTORE_HOT ()
{
echo "\n"
echo "${JAUNE}La restauration de la base ${ORACLE_SID} est en cours merci de bien vouloir patienter.....${NOR}"   | tee -a ${FLOG}
echo ""
rman target / << EOF >> ${FLOG}

            startup nomount;
            restore controlfile from '${NAME_CONTROL_FILE}';
            alter database mount ;
            restore database ;
            recover database ;
            alter database open resetlogs ;


EOF
}

Validation ()
{
sleep 5
sqlplus -s '/ as sysdba' <<EOF >> ${FLOG}
spool ${REP_SAVE}/Connect_Base.log
select status from v\$instance;
spool off
EOF

OPEN_BASE=`cat ${REP_SAVE}/Connect_Base.log |grep OPEN |awk '{print $1}'`


if [ "${OPEN_BASE}" == "OPEN" ];
then


                echo "\n"                                                            | tee -a ${FLOG}
                printf "|%23s|\n" "-----------------------"                          | tee -a ${FLOG}
                printf "|%15s|%7s|\n"  "INSTANCE" "STATUS"                           | tee -a ${FLOG}
                printf "|%23s|\n" "-----------------------"                          | tee -a ${FLOG}
                printf "|%15s|%7s|\n"  "${ORACLE_SID}" "${VERT}  OPEN ${NOR}"        | tee -a ${FLOG}
                printf "|%23s|\n" "-----------------------"                          | tee -a ${FLOG}
else
                echo "\n"                                                            | tee -a ${FLOG}
                printf "|%26s|\n" "---------------------------"                      | tee -a ${FLOG}
                printf "|%15s|%11s|\n"  "INSTANCE" "STATUS"                          | tee -a ${FLOG}
                printf "|%26s|\n" "---------------------------"                      | tee -a ${FLOG}
                printf "|%15s|%11s|\n"  "${ORACLE_SID}" "${ROUGE}  NOT OPEN ${NOR}"  | tee -a ${FLOG}
                printf "|%26s|\n" "---------------------------"                      | tee -a ${FLOG}
                cp -p ${FLOG} ${FLOG}_err
                echo ""
                echo "${ROUGE}Warning!!${NOR}${JAUNE} consulter la log d'erreur ${FLOG}_err${NOR}"
                echo "\n"
fi
}

###########################"
trace_INFO "${MODE}" " ETAPE (1) :DEBUT DE LA RESTAURATION DE LA BASE ${ORACLE_SID} "
#RMAN_RESTORE_HOT
trace_INFO "${MODE}" " ETAPE (2) :VERIFICATION DE L'OUVERTURE DE LA BASE ${ORACLE_SID} "
Validation

