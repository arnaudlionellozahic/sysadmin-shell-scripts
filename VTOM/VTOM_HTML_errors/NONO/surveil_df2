#!/bin/ksh
#arnaud.lozahic@mondial-assistance.fr=$1
H=`hostname`
CTOUT=/tmp/surveil.df
touch $CTOUT.old
echo " Controle des filesystems de $H"> $CTOUT
date "+%d/%m" >> $CTOUT
df -h | awk '
/%/ && ($1 !~ /Filesystem/ ){
if ( $1 <= 0 )
{  split($5,perc,"%"); if (perc[1]>=70) {print " <****> "h": " $6 " atteint " $5 }}
}
' h=$H | sort >> $CTOUT
echo ok1
if [ `cat $CTOUT|wc -l` -gt 2 -a `diff $CTOUT $CTOUT.old|wc -l` != 0 ]
then
        echo ok2
        /usr/bin/mailx -s "Rapport du suivi des FileSystem" arnaud.lozahic@mondial-assistance.fr < $CTOUT

# lp  $CTOUT
        cp $CTOUT $CTOUT.old

fi


#!/bin/ksh
# chk_dsk $1 - controle de l'usage disque - envoi d'un rapport a l'adresse $1
MAIL_WARN_UNIX=$1
H=`hostname`
CTOUT=/tmp/chk_dsk.log
touch $CTOUT.old
echo " Controle des filesystems de $H"> $CTOUT
date "+%d/%m" >> $CTOUT
df -lk | awk '
/%/ && ($0 !~ /cdrom/ ) && ($1 !~ /Filesystem/ ){
if ( $1 <= 0 )
{ split($5,perc,"%"); if (perc[1]>=93) {print " <****> "h": " $6 " atteint " $5 }}
}
' h=$H | sort >> $CTOUT
echo ok1
if [ `cat $CTOUT|wc -l` -gt 2 -a `diff $CTOUT $CTOUT.old|wc -l` != 0 ]
then
        echo ok2
        /usr/bin/mailx -s "Rapport du suivi des FileSystem" $MAIL_WARN_UNIX < $CTOUT

# lp  $CTOUT
        cp $CTOUT $CTOUT.old

fi

