#!/bin/ksh
#
# Stockage des processus les plus consommateurs en CPU ou memoire
#

set -x

if [ $(whoami) != "root" ]
then
echo " Il faut etre root pour le bon fonctionnement de ce script"
        exit
fi

if [[ "$#" != "2" ]] ; then
        echo "Usage    : `basename $0` duree_de_la_boucle_en_minutes nombre_de_process_maxi_surveillés"
        echo "Exemple  : `basename $0` 30 10 correspond a une boucle de 30 minutes 1 vacations toutes les 10 min pour 10 process audites"
        exit 1
fi

# Recup arg
DUREE_BOUCLE=$1
NB_PROC=$2

# Log files
PROCFILE=/tmp/CPU_cons
SYNTHESE=/tmp/SYNTHESE
SYNTHESE1=/tmp/SYNTHESE1

>/tmp/CPU_cons
>/tmp/SYNTHESE
>/tmp/SYNTHESE1

chmod 777 $PROCFILE $SYNTHESE $SYNTHESE1

# Maximum duration
LOOPNUM=$(expr ${DUREE_BOUCLE} / 10)    # Number of Interval
INTERVAL=600     # Seconds
COUNT=1
while [ $COUNT -lt $LOOPNUM ]
do
        # DATE HEURE
        DATE=$(date +%d/%m/%Y)
        TIME=$(date +%H:%M)
        ITIME=$(echo ${DATE} a ${TIME})
        echo "###############################" >> $PROCFILE
        echo le $ITIME >> $PROCFILE

        # CHARGE MACHINE
#        IDLE=$(vmstat |awk '{print $16}'|tail -1)
#        echo "###############################" >> $PROCFILE
#        echo idle a ${IDLE}% >> $PROCFILE

        # ANALYSE CPU
        echo "###############################" >> $PROCFILE
        NB_PROC1=$(expr ${NB_PROC} + 1)
        ps auxww | grep -Eiv 'kproc|wait|cft|etac|gzip|gtar'|head -${NB_PROC1} >> $PROCFILE

        echo "------------------------------------------------------------------------------------------------------------" >> $PROCFILE
        echo "------------------------------------------------------------------------------------------------------------" >> $PROCFILE
        COUNT=$(expr $COUNT + 1)
        sleep $INTERVAL
done

# Creation du fichier de synthese

echo "USER         PID %CPU %MEM   SZ  RSS    TTY STAT    STIME  TIME COMMAND" >> $SYNTHESE
PROC1=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -1)
grep $PROC1 $PROCFILE |head -1 >> $SYNTHESE

PROC2=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -2|head -1)
grep $PROC2 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC2 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC3=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -3|head -1)
grep $PROC3 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC3 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC4=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -4|head -1)
grep $PROC4 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC4 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC5=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -5|head -1)
grep $PROC5 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC5 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC6=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -6|head -1)
grep $PROC6 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC6 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC7=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -7|head -1)
grep $PROC7 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC7 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC8=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -8|head -1)
grep $PROC8 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC8 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC9=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -9|head -1)
grep $PROC9 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC9 $PROCFILE |head -1 >> $SYNTHESE
fi

PROC10=$(cat /tmp/CPU_cons|egrep -v "#|-----|idle|$DATE|USER" |awk '{print $3"  "$2}'|sort -n|awk '{print $2}'|uniq |tail -10|head -1)
grep $PROC10 $SYNTHESE >/dev/null 2>&1
if [[ $? != 0 ]]; then
grep $PROC10 $PROCFILE |head -1 >> $SYNTHESE
fi

cat $SYNTHESE | egrep -v "#|-----|idle|$DATE" >>$SYNTHESE1


# Envoi par sendmail

echo "Subject: Verification de la consommation des process de $(hostname)" > /tmp/check_proc_mail
echo "To: meo_atlas_rb" >> /tmp/check_proc_mail
#echo "Cc: laurent.molitor@bnpparibas.com" >> /tmp/check_proc_mail
echo "Cc: laurent.molitor@bnpparibas.com" >> /tmp/check_proc_mail

echo "Bonjour,"  >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail


echo "Machine : $(hostname)"  >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo SYNTHESE : >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo "Synthese des process qui ont consomme le plus de CPU pendant une analyse de $DUREE_BOUCLE minutes, merci de verifier si cette consommation est justifiee et si certains ne bouclent pas. Merci de killer les process applicatifs du type sql rtsora dfed32 rts32 ... qui tournent depuis plusieurs jours voire semaines et qui consomment beaucoup">> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
cat $SYNTHESE1 >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo "Boucle de vérification des ${NB_PROC} process qui consomment le plus, vacation toutes les 10 minutes pendant $DUREE_BOUCLE minutes" >> /tmp/check_proc_mail
echo  >> /tmp/check_proc_mail
echo DETAIL : >> /tmp/check_proc_mail
echo  >> /tmp/check_proc_mail
cat $PROCFILE >> /tmp/check_proc_mail

echo >> /tmp/check_proc_mail
echo >> /tmp/check_proc_mail
echo Cordialement >> /tmp/check_proc_mail
echo Mise En Oeuvre ATLAS2 >> /tmp/check_proc_mail

sendmail -f meo_atlas_rb -t <  /tmp/check_proc_mail
