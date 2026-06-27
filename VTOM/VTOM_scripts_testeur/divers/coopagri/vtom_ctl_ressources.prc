#!/bin/ksh
# @(#)####################################################################
# @(#)# COMMANDE   /a/vtom/prc/vtom_ctl_ressources.prc                   #
# @(#)#                                                                  #
# @(#)# FONCTION   Controle de l'etat des ressources numeriques et       #
# @(#)#            d'exclusion                                           #
# @(#)#                                                                  #
# @(#)#                                                                  #
# @(#)#                                                                  #
# @(#)# CREATION        10/02/2010                                       #
# @(#)# AUTEUR          D. QUIMERCH                                      #
# @(#)#                                                                  #
# @(#)# MODIFICATIONS :                                                  #
# @(#)# JJ/MM/SSAA XX :                                                  #
# @(#)#                                                                  #
# @(#)####################################################################


#========================================================================
#                               TRAITEMENT
#========================================================================

#-----------------------------------
# Variables generales
#-----------------------------------
. /u/default/envgen.env
APPLIC=180
SSAPPLIC=vtom
PROCED=`basename $0`

GENMAN=/home/fcharbon/coopagri
SAVE=/home/fcharbon/coopagri

#-----------------------------------
# Variables applicatives
#-----------------------------------
FIC_TMP=$GENMAN/$PROCED.$$
FIC_EX=$GENMAN/$PROCED.$$.EX
FIC_NU=$GENMAN/$PROCED.$$.NU
FIC_PI=$GENMAN/$PROCED.$$.PI
DATE_TRT=`date '+%d/%m/%Y %H:%M:%S'`
AFFICHAGE="N"


echo ""
echo "              VTOM : Controle de l'etat des ressources"
echo "                       Le $DATE_TRT"
echo "              ========================================"
echo ""
echo "Recherche en cours. Veuillez patienter ...."
echo " "
cp /dev/null $FIC_EX
cp /dev/null $FIC_NU
cp /dev/null $FIC_PI

for i in `tlist res|egrep -v "Stocks_NU_002"`
do
   if echo $i | grep _EX >/dev/null 2>&1
   then
      TYPE=EX
   fi
   if echo "$i" | grep _FI >/dev/null 2>&1
   then
      TYPE=FI
   fi
   if echo "$i" | grep _NU|grep -v _FI_NU|grep -v NU$|grep -v "Tina_NU" >/dev/null 2>&1
   then
      TYPE=NU
   fi
 if echo "$i" | grep _PI_|grep -v  Hartst_PI_001>/dev/null 2>&1
   then
      TYPE=PI
   fi
   case "$TYPE" in
   EX)
      res_valeur=`tval -name $i`
      if test $res_valeur -ne 0
      then
         res_nom=`echo $i"               "|cut -c1-16`
 		 echo "$res_nom : $res_valeur">>$FIC_EX
      fi
   ;;
    NU)
      res_valeur=`tval -name $i`
      if test $res_valeur -ne 0
      then
         res_nom=`echo $i"               "|cut -c1-16`
 		 echo "$res_nom : $res_valeur">>$FIC_NU
      fi
   ;;
   PI)
      res_valeur=`tpush -name $i -info|awk 'length($0) > 2 {print $0}'|wc -l`
      if test $res_valeur -gt 1
      then
         res_nom=`echo $i"               "|cut -c1-16`
         res_nombre=`expr $res_valeur - 2`

		 echo "$res_nom : $res_nombre elements">>$FIC_PI
      fi
   ;;   *)
   ;;
   esac
   TYPE=""
done
if test -s $FIC_EX
then
  echo " "
  echo "Nom et valeur des ressources d'exclusion positionnees"
  echo " "
  cat $FIC_EX
  echo  ""
  AFFICHAGE="O"
fi
if test -s $FIC_NU
then
  echo "Nom et valeur des ressources numeriques positionnees"
  echo " "
  cat $FIC_NU
  echo  ""
  AFFICHAGE="O"
fi
if test -s $FIC_PI
then
  echo "Nom et valeur des piles non vides"
  echo " "
  cat $FIC_PI
  echo  ""
  AFFICHAGE="O"
fi
if test "$AFFICHAGE" -ne "O"
then
   echo ""
   echo " Toutes les ressources sont a la valeur 0"
   echo ""
fi

