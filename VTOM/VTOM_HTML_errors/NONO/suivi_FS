#!/bin/ksh
# suivi_FS - surveillance usage espace disque - envoi de mail
# auteur: WA    date 04/07/2002
H=`hostname`
CTOUT=/tmp/rapport_suivi_FS.log
touch $CTOUT.old
df -h | awk '
/%/ && ($0 !~ /mnt/ ) && ($0 !~ /cdrom/ ) && ($0 !~ /db[0-9]/ ) && ($0 !~ /base/ ) && ($0 !~ /%Util/ ) && ($0 !~ /usr_parc[2-7]/ ) {
$5 ~ /%/
{ i=$4/1024; split($5,perc,"%"); if (perc[1]>=86 && i<90) {printf (" <****> "h": %-20s atteint \t\t %s \t   =>    reste  %i Mo\n",$6,$5,i) }}
}
' h=$H | sort > $CTOUT

#diff $CTOUT $CTOUT.old|wc -l|read DIFF
#if  [ -s $CTOUT -a $DIFF != 0 ]

diff $CTOUT $CTOUT.old|wc -l|read DIFF
cat $CTOUT |wc -l|read RESTE
if [ $DIFF -ne 0 ]
then
        if [ $RESTE -ne 0 ]
        then
                mailx -s "Rapport du suivi des FileSystem" mail_exploit < /tmp/rapport_suivi_FS.log
        else
                mailx -s "Rapport du suivi des FileSystem OK" mail_exploit < /dev/null
        fi

        cp $CTOUT $CTOUT.old
fi
