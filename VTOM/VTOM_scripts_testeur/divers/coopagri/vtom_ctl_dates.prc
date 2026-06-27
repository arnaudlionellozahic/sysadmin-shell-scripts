#!/bin/ksh
# @(#)####################################################################
# @(#)# COMMANDE     /a/vtom/prc/vtom_ctl_dates.prc                      #
# @(#)#                                                                  #
# @(#)# FONCTION     Controle des dates d'exploitation                   #
# @(#)#                                                                  #
# @(#)#              usage : vtom_ctl_dates.prc [param ]                 #
# @(#)#                                                                  #
# @(#)#              param=VTOM si lancement par VTOM                    #
# @(#)#                         pour envoi msg aux RAPP                  #
# @(#)#                                                                  #
# @(#)# CREATION        10/02/2010                                       #
# @(#)# AUTEUR          D. QUIMERCH                                      #
# @(#)#                                                                  #
# @(#)# MODIFICATIONS :                                                  #
# @(#)# JJ/MM/SSAA XX :                                                  #
# @(#)#                                                                  #
# @(#)#                                                                  #
# @(#)#                                                                  #
# @(#)#                                                                  #
# @(#)####################################################################


#========================================================================
#                               TRAITEMENT
#========================================================================

#-----------------------------------
# Variables generales      
#-----------------------------------
# . /u/default/envgen.env
APPLIC=180
SSAPPLIC=vtom
PROCED=`basename $0`

GENMAN=/home/fcharbon/coopagri
SAVE=/home/fcharbon/coopagri

#-----------------------------------
# Variables applicatives   
#-----------------------------------
FIC_TMP="$GENMAN/$PROCED.tmp$$"
FIC_SML="$GENMAN/$PROCED.sml$$"
FIC_DAT="/home/fcharbon/coopagri/fic/vtom_ctl_dates.dta"
DATE_TRT=`date '+%d/%m/%Y %H:%M:%S'`
DATE_CMP=`date +%d-%m-%Y`



echo "" 
echo "              VTOM : Controle des dates d'exploitation" 
echo "                       Le $DATE_TRT"
echo "              ========================================"
echo ""
echo "Dates differentes du $DATE_CMP :"
echo "" 


#----------------------------------------------------------
# Comparaison des dates d'exploitation avec la date
# du traitement  
#----------------------------------------------------------
tlist -v dates > $FIC_TMP
cat $FIC_TMP | while read date_nom date_valeur reste
do
   if test "$date_nom" != "000_BacASable"
   then
      if test "$DATE_CMP" -ne "$date_valeur"
      then
         date_fmt=`echo $date_nom"                "|cut -c1-16` 
         echo "$date_fmt : $date_valeur"

         # Msg aux RA
         LADATE=`grep "$date_nom" $FIC_DAT` > /dev/null
         if test "$LADATE" != "" -a "$1" = "VTOM"
         then
             RAPP=`echo $LADATE|awk '{print $2}'`
             echo "######$RAPP;VTOM : Controles des dates d'exploitation" >$FIC_SML
             echo "">>$FIC_SML 
             echo "         VTOM : Controle des dates d'exploitation">>$FIC_SML 
             echo "                  Le $DATE_TRT">>$FIC_SML 
             echo "         ========================================">>$FIC_SML
             echo "">>$FIC_SML
             echo " Blocage de la date d'exploitation : $date_nom">>$FIC_SML
             echo " Les traitements ne s'executent plus">>$FIC_SML
             echo "">>$FIC_SML
#             $GENPRC/mbxcre.prc -mSML -f$FIC_SML -a180 -pVTOM >/dev/null
             rm $FIC_SML
         fi

      fi
   fi
done 


echo ""
rm $FIC_TMP

