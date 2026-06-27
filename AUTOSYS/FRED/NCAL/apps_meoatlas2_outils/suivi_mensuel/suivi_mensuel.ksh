#!/usr/bin/ksh
. /usr/bin/EnvironnementTNG
export LANG=C
DATE=$(date | awk '{ print $2, $3 }')
SCHDMTR=$(ls -altr $CAIGLBL0000/sche/log/`hostname`/schdmtr* | awk '{print $9}')
SCHDLCS=$(ls -altr $CAIGLBL0000/sche/log/`hostname`/schdlcs* | awk '{print $9}')
SCHDTRK=$(ls -altr $CAIGLBL0000/sche/log/`hostname`/schdtrk* | awk '{print $9}')
JOBTOFOLLOW="arz1 msfa msua dsu1 mdi1 mww0 mfu99 mfu50 mfl99 mfl43 mfl16 mfl67 mds99 mds00 mdsb30 mds05 mds16 jrf7 mrf4 mrfh mrft mrf8 jrf2 mrfa mrfu mrfc mfu98 mfu17 mfl97 mfoas mfl01 mfl48 mfl74 mds90 mds14 mds41 mds61 mds90 mdm1 mdm9 mwsf m1sf m2sf"

>/tmp/suivi_mensuel_schdmtr.txt
>/tmp/suivi_mensuel_schdlcs.txt
>/tmp/suivi_mensuel_schdtrk.txt


for i in $JOBTOFOLLOW
do

        for j in $SCHDMTR
        do
        VERIF=$(ls -altr $j | awk '{print $6,$7,$9,$8}')
        grep -i $i $j | grep -e CASH_I_0072 > /dev/null 2> /dev/null
                if [[ $? -eq 0 ]]
                then
                        jour=$(echo $VERIF | awk '{print $1}')
                        mois=$(echo $VERIF | awk '{print $2}')
                        fichier=$(echo $VERIF | awk '{print $3}')
                        heure=$(echo $VERIF | awk '{print $4}')
                        export jour mois heure
                        #result=$(grep -i $i $fichier | grep -e CASH_I_0072 -e Aborted)
                        #echo "$result"| awk '{print "'$jour' '$mois' '$heure' #",$0}'
                        grep -i $i $fichier | grep -e CASH_I_0072 -e Aborted | awk '{print "'$jour' '$mois' '$heure' #",$0}' > /tmp/suivi_mensuel_schdmtr.txt
                        cat /tmp/suivi_mensuel_schdmtr.txt

                fi
        done

        for j in $SCHDLCS
        do
        VERIF=$(ls -altr $j | awk '{print $6,$7,$9,$8}')
        grep -i $i $j | grep -e CASH_I_0072 > /dev/null 2> /dev/null
                if [[ $? -eq 0 ]]
                then
                        jour=$(echo $VERIF | awk '{print $1}')
                        mois=$(echo $VERIF | awk '{print $2}')
                        fichier=$(echo $VERIF | awk '{print $3}')
                        heure=$(echo $VERIF | awk '{print $4}')
                        export jour mois heure
                        #result=$(grep -i $i $fichier | grep -e CASH_I_0072 -e Aborted -e CASH_I_0155)
                        #echo "$result"| awk '{print "'$jour' '$mois' '$heure' #",$0}'
                        grep -i $i $fichier | grep -e CASH_I_0072 -e Aborted -e CASH_I_0155 | awk '{print "'$jour' '$mois' '$heure' #",$0}' > /tmp/suivi_mensuel_schdlcs.txt
                        cat /tmp/suivi_mensuel_schdlcs.txt 

                fi
        done

        for j in $SCHDTRK
        do
        VERIF=$(ls -altr $j | awk '{print $6,$7,$9,$8}')
        grep -i $i $j | grep -e CASH_I_0072 -e CASH_I_0060 > /dev/null 2> /dev/null
                if [[ $? -eq 0 ]]
                then
                        jour=$(echo $VERIF | awk '{print $1}')
                        mois=$(echo $VERIF | awk '{print $2}')
                        fichier=$(echo $VERIF | awk '{print $3}')
                        heure=$(echo $VERIF | awk '{print $4}')
                        #result=$(grep -i $i $fichier | grep -e CASH_I_0072 -e CASH_I_0060 -e dask12 -e msrf09 -e msrf00 -e Aborted)
                        #echo "$result"| awk '{print "'$jour' '$mois' '$heure' #",$0}'
                        grep -i $i $fichier | grep -e CASH_I_0072 -e CASH_I_0060 -e dask12 -e msrf09 -e msrf00 -e Aborted | awk '{print "'$jour' '$mois' '$heure' #",$0}'> /tmp/suivi_mensuel_schdtrk.txt
                        cat /tmp/suivi_mensuel_schdtrk.txt

                fi
        done



done



