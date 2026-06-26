#!/bin/ksh

#Sauvegarde du repertoire /opt/CA
REP_LOG="/apps/atlas/atlas2v0/uf1/data1/imp"
REP_SAU="/opt/CA"
DATE=$(date "+%Y%m%d.%H%M")
DATE_ARCH=$(date "+%Y%m%d")
BLEU="\033[44m"
NORMAL="\033[00m"
exec 1>$REP_LOG/SAUVE.log.$DATE 2>&1

cd $REP_SAU
gtar czvf /apps/atlas/atlas2v0/uf1/ficsav/CA.tgz.$DATE_ARCH . /etc/auto.profile

if [[ $? -eq 0 || $? -eq 2 ]]
then
print "\n\n${BLEU}Archive créée ${NORMAL}\n\n"
dsmc Archive -se=TSM-ARZ108 -ARCHMC=ARCH0030 -desc=CA.$DATE_ARCH "/apps/atlas/atlas2v0/uf1/ficsav/CA.tgz.$DATE_ARCH"
        if [[ $? -eq 0 ]]
        then
        print "\nCheck si archive envoyé sur bande\n"
        dsmc q ar "/apps/atlas/atlas2v0/uf1/ficsav/CA.tgz.$DATE_ARCH"
                if [[ $? -eq 0 ]]
                then
                print "\n\nFichier envoyé sur bande, suppression du fichier de plus de 6 jours"
                print "\n\nListe des fichiers à supprimer\n\n"
                find /apps/atlas/atlas2v0/uf1/ficsav/ -name "CA.tgz?????????" -mtime +6 -ls
                find /apps/atlas/atlas2v0/uf1/ficsav/ -name "CA.tgz?????????" -mtime +6 -exec rm -f {} \;
                else
                print "\nLe fichier n'est pas envoyé sur bande\n"
                fi
        fi
fi