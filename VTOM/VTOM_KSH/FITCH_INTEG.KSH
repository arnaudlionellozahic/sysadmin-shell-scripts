#!/bin/ksh
#-------------------------------------------------------------------
#Diverses initialisations de variables obligatoires
#-------------------------------------------------------------------

#Date passee en argument par CONTROLM
ODATE=${1}
[ "X${ODATE}" = "X" ] && echo "Parm ODATE non specifie" && exit 1

ctrlmExports ${0}
switch ${GEHLOG} > /dev/null


#-------------------------------------------------------------------
#Chargement des variables d'environnement 
#-------------------------------------------------------------------
_GENERAL_ENV="${GEDAA}/etc/`echo ${GEIENV} | tr "PXG" "pxg"`v/env.ksh"
_LOCAL_ENV="${GEDAACC}/etc/env.ksh"
[ -a ${_GENERAL_ENV} ] && . ${_GENERAL_ENV}
[ -a ${_LOCAL_ENV} ] && . ${_LOCAL_ENV}
#-------------------------------------------------------------------
#Initialisation des variables n'ayant pas a etre modifiees
#-------------------------------------------------------------------
_P_DATE=`date +"%y%m%d_%H%M%S"`
_CODE=0

#-------------------------------------------------------------------
#Initialisation des variables specifiques au job
#-------------------------------------------------------------------

######################FOR DEBUG , TO BE REMOVED
#APP_DIR=~
#GEIENV=p
#SERVER=SD_TP_RR
#USER=callenou
#PASS=welcome
#BASE=mrrdb_refrisque
#ISQL_OUT=$APP_DIR/pm/travaux/ftp/sqlout
#TMP=$APP_DIR/pm/travaux/ftp
#path_awk=/usr/xpg4/bin/
#BCP=$APP_DIR/pm/travaux/ftp/bcp
######################FOR DEBUG , TO BE REMOVED

#override pour la marche en double
TMP=$APP_DIR/pm/travaux/tmp2

DATA=$APP_DIR/pm/travaux/ftp2
DATA_SAV=$DATA/sav
LISTE_INTEG_FITCH=Notation_integ_FI.txt

CONFIG=$APP_DIR/pm/`echo ${GEIENV} | tr "PXG" "pxg"`v/etc/

exec 1>$SYSOUT 2>&1


fonc_truncate ()
{
echo "\n*--------------------------------------------------*" 
echo   "* Truncate de la table $1 sur $SERVER,$BASE,$USER,$ISQL_OUT        " 
echo   "*--------------------------------------------------*" 

isql -S$SERVER -U$USER -P$PASS >$ISQL_OUT -I ~/interfaces 2>&1 <<EOF
truncate table $BASE..$1
go

select "Nb lignes apres truncate", count (*) from $1
go
EOF

CODE=$?

if [ $CODE -ne 0 ]
then
    echo "Code retour $CODE <> zero sur truncate table $1" 
    cat $ISQL_OUT
    exit 254
fi

grep Msg $ISQL_OUT >/dev/null 2>&1
if [ $? -eq 0 ]
  then
    echo "Erreur detectee par grep Msg."
    cat $ISQL_OUT
    exit 254
else
    echo "*------------------*" 
    echo "*... Truncate OK    "
    echo "*------------------*" 
fi
}

fonc_bcpin ()
{

echo "\n*----------------------------------------*" 
echo   "*  BCP IN : `date`                        " 
echo   "*  Table=$1                               "
echo   "*  Fichier IN=$2                          "
echo   "*  Separateur=$3                          "
echo   "*  Optionnel Fichier Format =$4           "
echo   "*----------------------------------------*" 

>$BCPIN

if [ "X"$4 == "X"  ]
then
	bcp $BASE..$1 in $2 -S$SERVER -U$USER -P$PASS -c -t$3 -b2500 -e$BCPIN >$BCP 2>&1
else
	bcp $BASE..$1 in $2 -S$SERVER -U$USER -P$PASS -t$3 -b2500 -e$BCPIN -f$4 >$BCP 2>&1
fi
CODE=$?

if [ $CODE -ne 0 ]
then   
   echo "Code retour $CODE <> zero sur bcp in $1" 
   cat $BCP
   return 1
fi

cat $BCP | grep error > /dev/null 2>&1
if [ $? -eq 0 ]
then
    echo "Code retour > zero par grep error sur $1"
    cat $BCP
    return 1
fi

cat $BCP | grep duplicate > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Code retour > zero par grep duplicate sur $1"  
  cat $BCP
  return 1
fi

echo "*-------------*" 
echo "* ... BCP OK   " 
echo "*-------------*" 
return 0
}

#--------------------------------------------
# Traitement d'integration d'un fichier FITCH
#--------------------------------------------
fonc_traite_fic ()
{
	    
    TYPE_FIC=`expr $1 : '\(.\)|.|.*'`
    NOM_FIC=`expr $1 : '.|.|\(.*\)'`
    EXTENSION_FIC=`expr $1 : '.*\..\(..\)'`
	FIC_TMP1=$NOM_FIC"1"
    FIC_TMP2=$NOM_FIC"2"		
    SEP_CHAMP='|'	
 
	
    echo "\n*================================================================*"
    echo   "* TRAITEMENT DU FICHIER :                                         "
    echo   "* Nom       : $NOM_FIC                                            "
    echo   "* Type      : $TYPE_FIC                                           "                 
    echo   "* Extension : $EXTENSION_FIC                                      "                 
    echo   "*=================================================================*"
	
    # Transformation du fichier Dos -> Unix -437 pour eviter un message d'erreur du à Solaris
	echo "Transformation du fichier Dos -> Unix, `date`"
	dos2unix -437 $DATA/$NOM_FIC > $TMP/$FIC_TMP1 
             
    # Suppression des chaines "," par | (il y a des commentaires avec des ,)
	echo "Remplacement du separateur, `date`"
	sed -e 's/","/|/g' -e 's/^"//g' -e 's/"$//g' $TMP/$FIC_TMP1 > $TMP/$FIC_TMP2
    
	# On ajoute pour chaque ligne le numero de ligne
	echo "ajout numero de ligne, `date`"
    $path_awk/awk -F$SEP_CHAMP '{printf ("%s|%s\n",FNR,$(0));}' $TMP/$FIC_TMP2 > $TMP/$FIC_TMP1
		
    if [ "$EXTENSION_FIC" = "ir" ] 
    then    
        BCP_FILE=$CONFIG/fi_issuer.fmt
        
        # BCP IN ta_fitch01_issuer_wk
        fonc_truncate ta_fitch01_issuer_wk
        fonc_bcpin ta_fitch01_issuer_wk $TMP/$FIC_TMP1 $SEP_CHAMP $BCP_FILE     
        ret=$? 
    fi
    
    if [ "$EXTENSION_FIC" = "is" ]
    then
        BCP_FILE=$CONFIG/fi_issue.fmt           
            
        # BCP IN ta_fi_issue_wk
        fonc_truncate ta_fitch02_issue_wk
        fonc_bcpin ta_fitch02_issue_wk $TMP/$FIC_TMP1 $SEP_CHAMP $BCP_FILE
        ret=$?
    fi 
        
   	# Renommage du fichier
   	cp $DATA/$NOM_FIC $DATA_SAV/_$NOM_FIC.sav
   	
   	# Suppression des fichiers temporaires
   	rm $TMP/$FIC_TMP1 $TMP/$FIC_TMP2  2>/dev/null 
	
	return $ret
}

#----------#
#  MAIN    #
#----------#


echo "*------------------------------------------------------*"
echo "*   Integration des fichiers de notations FITCH         "
echo "*   Debut du script $JOB = $P_DATE                      "
echo "*------------------------------------------------------*"
listeFichiersFITCH=`cat $DATA/$LISTE_INTEG_FITCH`

for FICHIER in $listeFichiersFITCH
{
    fonc_traite_fic $FICHIER
    if [ $ret != 0 ]
	then 
		$_CODE=$ret
		break 
	fi
}    

echo "*--------------------------------------------* "
echo "* Fin du script $JOB = $P_DATE                 "
echo "*--------------------------------------------* "

exit ${_CODE}


