#/usr/bin/ksh

purge_logs ()
{

cd ${REP}

echo -e "\n"
echo "#############################################################################"
echo "LISTE DES FICHIERS A PURGER"
find ${REP} -name "*.log" -type f -mtime +30 -exec ls -ltr {} \;

echo -e "\n"
echo "#############################################################################"
echo "ARCHIVAGE DES FICHERS AVEC HORADATAGE"
toto=`find ${REP} -name "*.log" -type f`
gtar -Pcvzf ${backup_log} $toto
if [ $? == "0" ]; then
   echo ""
   echo "Larchivage des fichiers de logs est ok, la purge va demarrer"
   else
       echo "Archivage des fichiers de logs ko, pas de purge"
           echo "exit 1"
           exit 1
fi

echo -e "\n"
echo "#############################################################################"
echo "SUPPRESSION DES FICHIERS A 30 JOURS"
find ${REP} -name "*.log" -type f -mtime +30 -exec \rm -f {} \;
if [ $? == "0" ]; then
   echo "La suppression des fichiers de logs a + de 30 jours est ok"
   else
       echo "La suppression des fichiers de logs a + de 30 jours ne sest pas bien deroulee"
           echo "exit 1"
           exit 1
fi

echo -e "\n"
echo "#############################################################################"
echo "PURGE DES ARCHIVES A 7 JOURS"
find ${REP} -name "backup_log*tgz" -type f -mtime +7 -exec \rm -f {} \;
if [ $? == "0" ]; then
   echo "La suppression des fichiers backup_log*tgz a plus de 7 jours est ok"
   else
       echo "La suppression des fichiers backup_log*tgz a plus de 7 jours ne sest pas bien deroulee"
           echo "exit 1"
           exit 1
fi

echo -e "\n"

}

#Main
DATE=$(date "+%Y%m%d-%H%M%S")
REP=/home/tomcat_app/batch/logs
backup_log=${REP}/backup_log_${DATE}.tgz
log_purge=${REP}/backup_log.txt
purge_logs > ${log_purge}
