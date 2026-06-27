#!/usr/bin/ksh
#Suivi des PROD ATLAS2
#Equipe: MEO ATLAS2
#Planification crontab: 30 08 * * 2-6 ksh /apps/meoatlas2/outils/newcheck.sh 2>/dev/null 
#---------------------

#-------------------------
#Mise en place envt TNG
#-------------------------
if type cautil >/dev/null
  then
      :
  else
  . /usr/bin/EnvironnementTNG
fi

WORK=/apps/meoatlas2
cd $WORK/outils
. $WORK/outils/param_check
DATE=$(date +"%d%m%Y")
LOG=$WORK/log/check_prod.lst.$DATE
LOG1=$WORK/log/check_prod.lst1
LOG2=$WORK/log/check_prod.lst2
LOG3=$WORK/log/check_prod.lst3
LOG4=$WORK/log/check_prod.lst4

 if [[ $BCK_TF = "oui" ]]
   then
          :
   else
      :
 fi



function date_f 
  {
m1=$(echo $1 | cut -c 4-5)
j1=$(echo $1 | cut -c 1-2)
a1=$(echo $1 | cut -c 7-10)
he1=$(echo $1 | cut -c 12-13)
mi1=$(echo $1 | cut -c 15-16)
d1=${a1}${m1}${j1}${he1}${mi1}
echo $d1
}



function type_j
{
P="/apps/atlas/atlas2v0/uf1/"
INF=$(ls -ltrd ${P}dwhexeunl0?? 2>/dev/null | tail -1 | awk -F"/" '{print $NF}')
export PATH="$PATH:${P}site/jcl:${P}jclsite:${P}jcl:${P}${INF}/jcl:/apps/omr/users/fobo_pba/uni/:/apps/sys/admin/:/apps/sys/shell/exploit/:/apps/sys/tsm/:/apps/sys/unicenter/exploitation/:"
j=$1

  loc=$(type $j 2>/dev/null| awk '{print $NF}')
   case $loc in
      *site/jcl/$j) echo "SITE" ;;
      *jcl/$j) echo "DSI" ;;
      *) echo "MEO" ;;
   esac
}



rm -f $LOG
echo "Subject: Suivi PROD $(hostname)" > $LOG 
echo "To: $MAIL_DEST" >> $LOG
(

TODAY=$($WORK/outils/ctime | awk '{print $1}')

echo "\nverif Sauvegardes apres EOD sur TSM\n******************************"


#---------------------------
# SAUVEGARDES PAR TIMEFINDER
#---------------------------
if [[ $BCK_TF = "oui" ]]
  then
for i in $FILES
  do
    B=$(/usr/bin/dsmc q ar $INST_TSM $NODE_TSM $PASS_TSM "$i" |tail -1)
    BF=$(echo $B | awk '{print $5}')
    if [[ $B = *atpr01* ]]
      then
          datef=$(basename $BF | awk -F"." '{print $2""$3}' | cut -c 1-12)
    fi

    if [[ $B = *FIC.JSAVF* ]]
      then
          datef=$(basename $BF | awk -F"." '{print $3""$4}' | cut -c 1-12)
    fi
          d1_datef=$(date_f $datef)
          touch -t $datef $LOG1
          Duree_datef=$(ctime $LOG1 | awk '{print $1}')
          DIFF=$( echo "$TODAY - $Duree_datef" | bc -l)
          J=$(echo $DIFF"/ 60 / 60 / 24" | bc )
      if [[ $J -ge 1 ]]
        then
            echo ">>>>>NOK : $B"
        else
            echo "[OK] ==> : $B" 
      fi 
done
rm -f $LOG1
fi





#------------------------
#SAUVEGARDES CLASSIQUES
#------------------------
if [[ $BCK_TF = "non" ]]
  then
for i in $FILES
  do
    B=$(/usr/bin/dsmc q ar $INST_TSM $NODE_TSM $PASS_TSM "$i" |tail -1)
    BF=$(echo $B | awk '{print $5}')
    if [[ $B = *atpr01* ]]
      then
          datef=$(basename $BF | awk -F"/" '{print $NF}' | cut -c 7-16)
          datef="20${datef}"
    fi

    if [[ $B = *JAS9C* ]]
      then
          datef=$(basename $BF | awk -F"_" '{print $2}' | cut -c 1-12)
    fi
          d1_datef=$(date_f $datef)
          touch -t $datef $LOG1
          Duree_datef=$(ctime $LOG1 | awk '{print $1}')
          DIFF=$( echo "$TODAY - $Duree_datef" | bc -l)
          J=$(echo $DIFF"/ 60 / 60 / 24" | bc )
      if [[ $J -ge 1 ]]
        then
            echo ">>>>>NOK : $B"
        else
            echo "[OK] ==> : $B"
      fi
done
rm -f $LOG1
fi




#--------------------------------------
#DECHARGEMENT INFOCENTRE
#--------------------------------------
if [[ -n $A0 && -n $A1 ]]
   then
echo "\nHeure Déchargement infocentre (infoc)\n******************************"

DEB=$(for i in $A0
  do
    cautil sel jobsethist id=${i}* list |grep "^ Start:" | tail -1
done | sort +3 | head -1 | awk '{print $2" "$3}' | sed "s/\.00//")


FIN=$(for i in $A1
  do
    cautil sel jobsethist id=${i}* list |grep "^ Start:" | tail -1
done | sort +5 | tail -1 | awk '{print $5" "$6}' | sed "s/\.00//")

d_infoc=$($WORK/outils/duree.sh "$DEB" "$FIN")
echo "$DEB - $FIN - $d_infoc"
fi



 

#------------------------------------
# ABORTS PENDANT TP ET BATCH
#------------------------------------
#Qualifier du dernier BATCH
qual=$(cautil sel jobhist id=${JS_BATCH}*,${J_BATCH},* list | grep Qualifier: | tail -1 | awk '{print $NF}' | cut -c 1-2)

if [[ $qual = [0-9]* ]]
  then
D1_TP1=`cautil sel jobhist id=${JS_TP}*,${J_TP},* list | grep "^ Start:" | tail -2 | head -1 | awk '{ print $2","$3 }'`
D1_TP2=`cautil sel jobhist id=${JS_BATCH}*,${J_BATCH},* list | grep "^ Start:" | tail -1 | awk '{ print $2","$3 }'`
D1_BA1=`cautil sel jobhist id=${JS_TP}*,${J_TP},* list | grep "^ Start:" | tail -1 | awk '{ print $2","$3 }'`

d1_D1_TP1=$(date_f $D1_TP1)
d1_D1_TP2=$(date_f $D1_TP2)
d1_D1_BA1=$(date_f $D1_BA1)

touch -t $d1_D1_TP1 $LOG1
Duree_D1_TP1=$($WORK/outils/ctime $LOG1 | awk '{print $1}')

touch -t $d1_D1_TP2 $LOG2
Duree_D1_TP2=$($WORK/outils/ctime $LOG2 | awk '{print $1}')

touch -t $d1_D1_BA1 $LOG3
Duree_D1_BA1=$($WORK/outils/ctime $LOG3 | awk '{print $1}')

SEUIL_JTP1_JTP2=$( echo "$Duree_D1_TP2 - $Duree_D1_TP1" | bc -l)
SEUIL_JTP1_JTP1=$( echo "$Duree_D1_BA1 - $Duree_D1_TP1" | bc -l)



echo "\nJOBS TOMBES EN ABORT PENDANT LE TP ET LE BATCH \n********************************************"
echo "HORAIRE TP: $D1_TP1 - $D1_TP2"
echo "HORAIRE BATCH: $D1_TP2 - $D1_BA1 \n\n"
cautil select conlog start="$D1_TP1" end="$D1_BA1" list conlog | grep CASH_I_0062 | grep "(.)"  | grep GENERATED | sed "s/(.)//g" | grep "cau8trk" | awk '{ print $22,$23,$6,$7 }' | sed  -e "s/(//g" -e "s/)//g" | sort -un +0 +1 |
while read a b c d
do
lib=$(cautil sel job id=$c,$d,* list | grep "Description" | sed "s/Description://g")
D1_BA4="${a},${b}"
d1_D1_BA4=$(date_f $D1_BA4)
touch -t $d1_D1_BA4 $LOG4
Duree_D1_BA4=$($WORK/outils/ctime $LOG4 | awk '{print $1}')

SEUIL_JTP1_JBA4=$( echo "$Duree_D1_BA4 - $Duree_D1_TP1" | bc -l)

if [[ $SEUIL_JTP1_JBA4 -le 0 ]]
  then
      : 
fi


if [[ $SEUIL_JTP1_JBA4 -le $SEUIL_JTP1_JTP2 && $SEUIL_JTP1_JBA4 -ge 0  ]]
  then
      tj=$(type_j $d)
      echo "TP: $D1_BA4 $c $d $tj $lib" 
fi


if [[ $SEUIL_JTP1_JBA4 -le $SEUIL_JTP1_JTP1 && $SEUIL_JTP1_JBA4 -ge $SEUIL_JTP1_JTP2  ]]
  then
      tj=$(type_j $d)
      echo "BATCH: $D1_BA4 $c $d $tj $lib"
fi


if [[  $SEUIL_JTP1_JBA4 -ge $SEUIL_JTP1_JTP1  ]]
  then
      : 
fi

#echo "$c -- $SEUIL_JTP1_JBA4 -- $SEUIL_JTP1_JTP2 -- $SEUIL_JTP1_JTP2"
done

fi




#-------------------------------------------
# TRANSFERT CFT EMISSION/RECEPTION EN ERREUR
#-------------------------------------------
CFT_SEND=$(grep "+KO+" /apps/cft/fillog/IDU.log $(ls -ltr /apps/cft/fillog/IDU_???????? | tail -1 | awk '{print $NF}') | grep "+E+" | awk -F"+" '{print $5}' | sort -u)
CFT_RECV=$(grep "+KO+" /apps/cft/fillog/IDU.log $(ls -ltr /apps/cft/fillog/IDU_???????? | tail -1 | awk '{print $NF}') | grep "+R+" | awk -F"+" '{print $5}' | sort -u)

echo "\nTRANSFERT CFT TOMBES EN ERREUR\n****************************"
echo "EMISSION: $(echo $CFT_SEND | tr ' ' ',')"
echo "RECEPTION: $(echo $CFT_RECV | tr ' ' ',')"




) >> $LOG 

#cat $LOG
rm -f $LOG1 $LOG2 $LOG3 $LOG4
sendmail -f meo_atlas_paris -t < $LOG >/dev/null
