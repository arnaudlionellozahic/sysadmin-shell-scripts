#!/bin/ksh -x

TMP=/tmp/extract/
mkdir $TMP
ISQL_OUT=$TMP/ISQLOUT
SERVER=SP_TP_RR
USER=dborr_ihm
PASS=dat%era66
BASE=mrrdb_refrisque

#liste des fichiers générés
data_loan_general=data_loan_general.csv
DossierDeDefaut=DossierDeDefaut.csv
Data_Loan_History=Data_Loan_History.csv
Data_Entity_Financial=Data_Entity_Financial.csv
Data_entity=Data_entity.csv
Marges_Contrat=Marges_Contrat.csv
Transactions=Transactions.csv
Collateral=Collateral.csv
Garantors=Garantors.csv
Fiches=Fiche.csv


fonc_execproc ()
{
echo   "*--------------------------------------------------*"
echo   "* Execution de la PS $1                             "
echo   "*--------------------------------------------------*"
>$ISQL_OUT

isql -S$SERVER -U$USER -P$PASS -s"|" -w8000 <<EOF 1>$ISQL_OUT 2>&1

go 		

use $BASE
go


Declare @syb_err     Int,
        @syb_lib     VarChar(255)
        
EXECUTE $1 @syb_err OUTPUT, @syb_lib OUTPUT

select "RET_SYB:" + Convert(VarChar(10),@syb_err) + ":"
select "LIB_SYB:" + @syb_lib + ":"
go
EOF

CODE=$?
if [ $CODE -ne 0 ]
then
  echo "Code retour $CODE <> zero sur la PS $1"  
  cat $ISQL_OUT
  exit 254
fi


egrep -v "DEBUTLIGNE" $ISQL_OUT > $TMP/tracedextlgd; egrep "Msg|error " $TMP/tracedextlgd 2>/dev/null
if [ $? -eq 0 ]
then
    echo "ERREUR detectee par grep sur trace du fichier de sortie."
    cat $ISQL_OUT
    exit 254
fi
 
RET_SYB=`cat $ISQL_OUT | grep "RET_SYB" | \
 sed s/" "//g | $path_awk/awk -F":" '{print $2 }'`
LIB_SYB=`cat $ISQL_OUT | grep "LIB_SYB" | \
 $path_awk/awk -F":" '{print $2 }'`

echo "Retour sybase = $RET_SYB $LIB_SYB"

if [ $RET_SYB -ne 0 ]
then
    echo "\nCode retour $RET_SYB $RET_SYB <> zero sur PS $1"
    exit 254
else
 echo "*----------------*"
 echo "* ... Exec PS OK  `date`"
 echo "*----------------*"
 return 0
fi
}
fonc_execproc ps_37s04_Extract_GRQS
if [ $? != 0 ]
then
 exit 254
fi
date

#remplacement des mots clé null et nulle par ''
sed -e "s/NULL//g" \
    -e "s/NULLE//g" \
	-e "s/[ ]*$//" $ISQL_OUT > $TMP/all.dat

if [ $? != 0 ]
then
 exit 254
fi

#Extraction des données de contrats
awk -F"¤" '/!@@!DEBUTLIGNE!@@!CONTRAT!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$data_loan_general
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de dossiers
awk -F"¤" '/!@@!DEBUTLIGNE!@@!DOSSIER!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$DossierDeDefaut
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de histo contrat
awk -F"¤" '/!@@!DEBUTLIGNE!@@!HISTO!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Data_Loan_History
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de Data_Entity_Financial.csv
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Data_Entity_Financial!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Data_Entity_Financial
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de Data_entity
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Data_entity!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Data_entity
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de Marges_Contrat
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Marges_Contrat!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Marges_Contrat
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de Transactions
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Transactions!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Transactions
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de collateraux
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Collateral!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Collateral
if [ $? != 0 ]
then
 exit 254
fi
date

#extraction données de garantie
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Garantors!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Garantors
if [ $? != 0 ]
 then
exit 254
fi
date

#extraction données de fiches
awk -F"¤" '/!@@!DEBUTLIGNE!@@!Fiche!@@!¤/{printf("%s\n",$2);}' $TMP/all.dat  > $TMP/$Fiches
if [ $? != 0 ]
then
 exit 254
fi
date

