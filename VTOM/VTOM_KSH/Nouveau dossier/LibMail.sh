#!/bin/ksh

email_attachment() {
    from="$1"
	to="$2"
    cc="$3"
	bcc="$4"
    subject="$5"
    body="$6"
    filename="${7:-''}"

    boundary="_====_blah_====_$(date +%Y%m%d%H%M%S)_====_"
    {
        print -- "To: $to"
        print -- "Cc: $cc"
		print -- "Bcc: $bcc"
        print -- "Subject: $subject"
        print -- "Content-Type: multipart/mixed; boundary=\"$boundary\""
        print -- "Mime-Version: 1.0"
        print -- ""
        print -- "This is a multi-part message in MIME format."
        print -- ""
        print -- "--$boundary"
        print -- "Content-Type: text/html; charset=ISO-8859-1"
        print -- ""
        print -- "$body"
        print -- ""
        if [[ -n "$filename" && -f "$filename" && -r "$filename" ]]; then
            print -- "--$boundary"
            print -- "Content-Transfer-Encoding: base64"
            print -- "Content-Type: application/octet-stream; name=`basename $filename`"
            print -- "Content-Disposition: attachment; filename=`basename $filename`"
            print -- ""
            print -- "$(perl -MMIME::Base64 -e 'open F, shift; @lines=<F>; close F; print MIME::Base64::encode(join(q{}, @lines))' $filename)"
            print -- ""
        fi
        print -- "--${boundary}--"
    } | /usr/lib/sendmail -f portail-credit@natixis.com -oi -t
}

fonc_execproc_TwoParam ()
{
echo   "*--------------------------------------------------*"
echo   "* Execution de la PS $1  param:$2                   "
echo   "*--------------------------------------------------*"
>$ISQL_OUT

isql -S$SERVER -U$USER -P$PASS -s"|" -w8000 <<EOF 1>$ISQL_OUT 2>&1

go

use $BASE
go


Declare @syb_err     Int,
        @syb_lib     VarChar(255)

EXECUTE $1 '$2','$3', @syb_err OUTPUT, @syb_lib OUTPUT

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


egrep "Msg|error" $ISQL_OUT 2>/dev/null
if [ $? -eq 0 ]
then
    echo "ERREUR detectee par grep sur trace du fichier de sortie."
    cat $ISQL_OUT
    exit 254
fi

RET_SYB=`cat $ISQL_OUT | grep "RET_SYB" | \
 sed s/" "//g | awk -F":" '{print $2 }'`
LIB_SYB=`cat $ISQL_OUT | grep "LIB_SYB" | \
 awk -F":" '{print $2 }'`

echo "Retour sybase : $RET_SYB $LIB_SYB"

if [ $RET_SYB -ne 0 ]
then
    echo "\nCode retour $RET_SYB $RET_SYB <> zero sur PS $1"
    exit 254
else
 echo "*----------------*"
 echo "* ... Exec PS OK  "
 echo "*----------------*"
 return 0
fi
}

getRecipient()
{
	if [ "x${GEIENV}" = "xX" ] 
	then
			CurrentEnv="PROD"
	else 
		CurrentEnv="PREX"
	fi
	
	fonc_execproc_TwoParam rr37s37_GetRecipient $1 $CurrentEnv
	RECIPIENT=`cat $ISQL_OUT |grep 'DATATAG'| tr -s " "`
	echo "resultat de la proc stock:"$RECIPIENT
	
	if [ `cat $ISQL_OUT |grep -c 'DATATAG'` -eq 0 ] 
	then
		echo "ERROR : Report [ $1 ] non trouvé en base"
		exit 1
	fi

	TO=`expr "$RECIPIENT" : '|DATATAG|\(.*\) |.* |.* |.* |'`
	CC=`expr "$RECIPIENT" : '|DATATAG|.* |\(.*\) |.* |.* |'`
	BCC=`expr "$RECIPIENT" : '|DATATAG|.* |.* |\(.*\) |.* |'`
	FROM=`expr "$RECIPIENT" : '|DATATAG|.* |.* |.* |\(.*\) |'`
	echo "variables crées:"
	echo \\tTO:$TO
	echo \\tCC:$CC
	echo \\tBCC:$BCC
	echo \\tFROM:$FROM
}

usage()
{
	echo "report [ReportId] [Subject] [Body] [Piece jointe]"
	echo "Body peut etre un fichier dont on utilisera le contenu ou alors une string"
	echo "Les variables suivantes doivent existées:"
	echo "GEIENV : variable contenant l'environnement X = PROD, P=PREX, ...."
	echo "ISQL_OUT :fichier de sortie des commandes isql"
	echo "BASE :nom database"
	echo "USER :login BDD"
	echo "PASSWORD :BDD"
	echo "SERVER : server:port de la BDD"
	
	exit 1
}

#############################################################
#					ENTRY POINT								#
#############################################################
report(){
	##############
	# Input parameters
	ReportId=$1
	Subject="$2"	
	Body="$3"
	Attachment="$4"
	

	#verification des variables necessaires:
	if [ X"$GEIENV" = "X" ]
	then
		echo "La variable GEIENV n'est pas définie, elle permet de savoir si on est en prod/prex/dev/rec"
		usage
	fi
	
	if [ X"$ISQL_OUT" = "X" ]
	then
		echo "La variable ISQL_OUT n'est pas définie"
		usage
	fi
	
	if [ X"$SERVER" = "X" ]
	then
		echo "La variable SERVER n'est pas définie"
		usage
	fi
	
	if [ X"$USER" = "X" ]
	then
		echo "La variable USER n'est pas définie"
		usage
	fi
	
	if [ X"$PASS" = "X" ]
	then
		echo "La variable PASS n'est pas définie"
		usage
	fi
	
	if [ X"$BASE" = "X" ]
	then
		echo "La variable BASE n'est pas définie"
		usage
	fi	
	
	
	#####
	# modification du titre pour la PREX
	if [ "x${GEIENV}" <> "xX" ]; then
			Subject="PREX : $Subject"
	fi
	
	#####
	# choix du mode: Body = fichier ou texte
	if [ -e $Body ]
	then
		echo "Body is a file, using the content as the body"
		Body="`cat $Body`"
	else
		echo "Body is not a file so using it"
	fi
	
	#######
	# récupération depuis la base des destinataires du mail.
	getRecipient $ReportId $GEIENV
	
	#######
	# appel de la fonction d'envoi (sendmail)
	email_attachment "$FROM" "$TO" "$CC" "$BCC" "$Subject " "$Body " "$Attachment "
}
