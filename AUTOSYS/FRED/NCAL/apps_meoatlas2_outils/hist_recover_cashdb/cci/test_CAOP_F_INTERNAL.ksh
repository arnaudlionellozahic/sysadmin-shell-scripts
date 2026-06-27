#!/usr/bin/ksh

# test si ccirmtd est ralenti en regardant si on a l'erreur
# CAOP_F_INTERNAL Internal error: Error in received CCI block
# objectif de voir si on a ce message si le generated est en dérive
# afin  de vérfier si un trigger n'a pas été loupé

DATE=$(date +'%Y%m%d')
FILE=/apps/unicenter/EM/3.1/opr/logs/oplog.${DATE}
#FILE=/apps/meoatlas2/outils/hist_recover_cashdb/test.20140912
DIR=/apps/meoatlas2/outils/hist_recover_cashdb/cci

if [ -f ${DIR}/CAOP_F_INTERNAL.${DATE} ]
then
        mv ${DIR}/CAOP_F_INTERNAL.${DATE} ${DIR}/CAOP_F_INTERNAL.${DATE}.diff
fi

strings $FILE | grep -i "CAOP_F_INTERNAL Internal error: Error in received CCI block" > ${DIR}/CAOP_F_INTERNAL.${DATE}

if [ -f ${DIR}/CAOP_F_INTERNAL.${DATE}.diff ]
then
        diff ${DIR}/CAOP_F_INTERNAL.${DATE} ${DIR}/CAOP_F_INTERNAL.${DATE}.diff
        if [ $? -ne 0 ]
        then
               ${DIR}/sendemail_CAOP_F_INTERNAL.ksh
        fi
else

        grep -i "CAOP_F_INTERNAL Internal error: Error in received CCI block" ${DIR}/CAOP_F_INTERNAL.${DATE}
        if [ $? -eq 0 ]
        then
                ${DIR}/sendemail_CAOP_F_INTERNAL.ksh
        fi
fi


