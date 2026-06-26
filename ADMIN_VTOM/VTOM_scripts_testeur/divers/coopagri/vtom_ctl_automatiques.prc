#!/bin/ksh
# @(#)####################################################################
# @(#)# COMMANDE     /a/vtom/prc/vtom_ctl_automatique.prc                #
# @(#)#                                                                  #
# @(#)# FONCTION     Controle automatique :                              #
# @(#)#                       Dates d'exploitation                       #
# @(#)#                       Valeur des ressources                      #
# @(#)#                                                                  #
# @(#)#              param=VTOM si lancement par VTOM                    #
# @(#)#                    pour envoie MSG aux RAPP                      #
# @(#)#                                                                  #
# @(#)# CREATION        12/02/2010                                       #
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


#-----------------------------------
# Variables applicatives   
#-----------------------------------

GENMAN=/home/fcharbon/coopagri
SAVE=/home/fcharbon/coopagri

FIC_TMP=$GENMAN/$PROCED$$
FIC_SML=$GENMAN/$PROCED.sml
DATE_TRT=`date '+%d/%m/%Y %H:%M:%S'`
DATE_CMP=`date +%d-%m-%Y`
AFFICHAGE="N"


# Controle des dates d'exploitation
/home/fcharbon/scripts/vtom_ctl_dates.prc "$1" >> $FIC_TMP

echo "" >> $FIC_TMP
echo " -------------------------------------------------------------------" >> $FIC_TMP
echo "" >> $FIC_TMP

# Controle de la valeur des ressources
/home/fcharbon/scripts/vtom_ctl_ressources.prc >> $FIC_TMP


# Sauvegarde du fichier + SML au PCP
cp $FIC_TMP $SAVE/tmp100
echo "######SMI PCP;VTOM : Controles automatiques" > $FIC_SML
cat $FIC_TMP >> $FIC_SML
# $GENPRC/mbxcre.prc -mSML -f$FIC_SML -a180 -pVTOM

# rm $FIC_TMP   
 
