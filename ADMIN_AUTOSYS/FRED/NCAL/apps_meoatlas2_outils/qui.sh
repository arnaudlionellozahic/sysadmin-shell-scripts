#!/usr/bin/ksh
#Recherche Qui a fait Quoi ?
#GB 13/01/2009
#---------------------------
if [[ $# -ne 1 ]]
   then
     echo "usage: qui.sh mot_cle"
     exit 1
fi

PARM=$1

cd /apps/meoatlas2/trace

for i in $(ls)
do
   strings $i | grep -q $PARM
   if [[ $? -eq 0 ]]
     then
         user=$(echo $i | awk -F"_" '{print $1}')
         QUI=$(grep $user /etc/passwd | awk -F":" '{print $5}' | awk -F"," '{print $1}')
         echo "\n---- $i == $QUI ----"
         strings $i | grep $PARM
   fi
done

echo "\n"
cd /apps/meoatlas2/outils

