#!/bin/ksh
# @(#)####################################################################
# @(#)# COMMANDE     /a/vtom/prc/vtom_ctl_mode_exec.prc                  #
# @(#)#                                                                  #
# @(#)# FONCTION     Controle du mode d'execution des applications       #
# @(#)#              --> obligatoirement en mode Traitement              #
# @(#)#                                                                  #
# @(#)#                                                                  #
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
. /u/default/envgen.env
APPLIC=180
SSAPPLIC=vtom
PROCED=`basename $0`

GENMAN=/home/fcharbon/coopagri
SAVE=/home/fcharbon/coopagri

#-----------------------------------
# Variables applicatives   
#-----------------------------------
FIC_LOG="$GENMAN/$PROCED.log"
FIC_TMP="$GENMAN/$PROCED.tmp"
FIC_SML="$GENMAN/$PROCED.sml"
DATE_TRT=`date '+%d/%m/%Y %H:%M:%S'`
AFFICHAGE="N"


#----------------------------------------------------------
# Controle du mode d'execution des applications     
#----------------------------------------------------------
tlist apps_execution > $FIC_LOG
cat $FIC_LOG | while read env appli reste
do
   if test "$AFFICHAGE" = "N"
   then
      echo "" >$FIC_TMP 
      echo "      VTOM : Controle du mode d'execution des applications" >>$FIC_TMP
      echo "                       Le $DATE_TRT" >>$FIC_TMP
      echo "      ====================================================" >>$FIC_TMP
      echo "" >>$FIC_TMP
      echo "" >>$FIC_TMP
      echo "Applications en mode Execution :" >>$FIC_TMP
      echo "" >>$FIC_TMP
      AFFICHAGE="O"
   fi
   echo "$env : $appli" >>$FIC_TMP
done 


# SML au PCP
if test "$AFFICHAGE" = "O"
then
   echo "######SMI PCP;VTOM : Controle mode execution" > $FIC_SML
   cat $FIC_TMP >> $FIC_SML
#   $GENPRC/mbxcre.prc -mSML -f$FIC_SML -a180 -pVTOM

#   rm "$FIC_LOG"
#   rm "$FIC_TMP"
fi

