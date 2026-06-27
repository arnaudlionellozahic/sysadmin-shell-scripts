#!/usr/bin/ksh

if [ $(whoami) != "root" ]
then
echo " Il faut etre root pour le bon fonctionnement de ce script"
        exit
fi

if [[ "$#" != "1" ]] ; then
        echo "Usage    : `basename $0` seuil mini avant alerte"
        echo "Exemple  : `basename $0` 10 un mail est envoye si il ne reste plus que 10% de libre dans le catalogue CFT"
        exit 1
fi


SEUIL=$1

su - cft -c "cftcatab >/tmp/cftcatab.lst"

export VAL=$(cat /tmp/cftcatab.lst |grep free |awk -F"("  '{print $3}' |awk -F% '{print $1}')

if [[ "$VAL" -le "$SEUIL" ]]
then

#Envoi du mail

echo "Subject: Verification du remplissage du catalogue CFT de $(hostname)" > /tmp/check_cata_cft_mail
echo "To: meo_atlas_paris" >> /tmp/check_cata_cft_mail
echo "Cc: laurent.molitor@bnpparibas.com" >> /tmp/check_cata_cft_mail

echo "Bonjour,"  >> /tmp/check_cata_cft_mail
echo >> /tmp/check_cata_cft_mail
echo >> /tmp/check_cata_cft_mail


echo "Machine : $(hostname)"  >> /tmp/check_cata_cft_mail
echo >> /tmp/check_cata_cft_mail
echo "Attention il ne reste plus que ${VAL}% de libre dans le catalogue CFT, merci de purger ou de l'agrandir" >> /tmp/check_cata_cft_mail
echo >> /tmp/check_cata_cft_mail
echo >> /tmp/check_cata_cft_mail
echo Cordialement >> /tmp/check_cata_cft_mail
echo Mise En Oeuvre ATLAS2 >> /tmp/check_cata_cft_mail

sendmail -f meo_atlas_rb -t <  /tmp/check_cata_cft_mail

fi
