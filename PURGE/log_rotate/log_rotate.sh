#/usr/bin/ksh

purge_logs_apache ()
{

cd ${REP}

echo -e "\n"
echo "#############################################################################"
echo "LISTE DES FICHIERS A PURGER"
find ${REP} -name "*.log.*" -type f -mtime +1 -exec ls -ltr {} \;

echo -e "\n"
echo "#############################################################################"
echo "ARCHIVAGE DES FICHERS AVEC HORADATAGE"
toto=`find ${REP} -name "*.log.*" -type f`
gtar -Pcvzf ${backup_log_apache} $toto
if [ $? == "0" ]; then
   echo ""
   echo "Larchivage des fichiers est ok, la purge va demarrer"
   else
       echo "Archivage des fichiers ko, pas de purge"
           echo "exit 1"
           exit 1
fi

echo -e "\n"
echo "#############################################################################"
echo "SUPPRESSION DES FICHIERS A 1 JOUR"
find ${REP} -name "*.log.*" -type f -mtime +1 -exec \rm -f {} \;
if [ $? == "0" ]; then
   echo "La suppression des fichiers de rotation des logs a + de 1 jour est ok"
   else
       echo "La suppression des fichiers de rotation des logs a + de 1 jour ne sest pas bien deroulee"
           echo "exit 1"
           exit 1
fi

echo -e "\n"
echo "#############################################################################"
echo "PURGE DES ARCHIVES A 7 JOURS"
find ${REP} -name "backup_log_apache*tgz" -type f -mtime +7 -exec \rm -f {} \;
if [ $? == "0" ]; then
   echo "La suppression des fichiers backup_log_apache*tgz a plus de 7 jours est ok"
   else
       echo "La suppression des fichiers backup_log_apache*tgz a plus de 7 jours ne sest pas bien deroulee"
           echo "exit 1"
           exit 1
fi

echo -e "\n"

}

#Main
DATE=$(date "+%Y%m%d-%H%M%S")
REP=/var/log/httpd
backup_log_apache=${REP}/backup_log_apache_${DATE}.tgz
log_purge_apache=${REP}/backup_apache.txt
purge_logs_apache > ${log_purge_apache}
