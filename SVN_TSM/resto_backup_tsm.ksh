#!/bin/ksh -x 


resto_svn_tsm ()
{
if [ `/bin/grep ${fic} ${out1} | wc -l` -eq 1 ]
then
	echo -e "\033[31mLa restauration TSM est KO, le fichier ${fic} ne doit pas etre present dans le repertoire ${rep_appli}.\033[00m"
	echo "Bonjour," > ${out}
        echo "" >> ${out}
	echo "La restauration tsm backup de ${rep1} est KO le $(date +'%d/%m/%Y a %H:%M')" >> ${out}
	echo "" >> ${out}
        echo "Le fichier ${fic} ne doit pas etre present dans le repertoire ${rep_appli}." >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN][${J_DAY}] - Restauration svn backup tsm KO" ld-tip-app-bgc-rri@natixis.com < ${out}
        exit 1
else
	dsmc rest "${rep_appli}/${fic}" -ina=yes -optfile=/opt/tivoli/tsm/client/ba/bin/BK/SLQDL7BDD01_BK-dsm.opt > ${out2}_${J_DAY}
	
fi
}


controle_resto ()
{
cp -rp ${out2}_${J_DAY} ${out3}
perl -pi -e "s/ //g" ${out3} && cat ${out3} | grep restored > $toto

if [ `/bin/grep Totalnumberofobjectsrestored:1 ${out3} | wc -l` -lt 1 ]
then
        echo -e "\033[31mLa restauration de l'archive ${fic} via tsm est KO, veuillez verifier la log ${out2}_${J_DAY}\033[00m"
        echo "Bonjour," > ${out}
        echo "" >> ${out}
        echo "La restauration de l'archive ${fic} via tsm est KO le $(date +'%d/%m/%Y a %H:%M'), veuillez consulter la log ${out2}_${J_DAY}" >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN][${J_DAY}] - Restauration de l'archive ${fic} via tsm KO" ld-tip-app-bgc-rri@natixis.com < ${out}
        exit 1
else
        echo -e "\033[31mLe service httpd de ${rep1} va etre arrete le temps de la restauration de l'archive ${fic} via tsm est OK\033[00m"
        echo "Bonjour," > ${out}
        echo "" >> ${out}
        echo "Le service httpd de ${rep1} va etre arrete le temps de la restauration de l'archive ${fic} via tsm." >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN][${J_DAY}] - Arret/Relance du service httpd de ${rep1} pour restauration de l'archive ${fic} via tsm" ld-tip-app-bgc-rri@natixis.com < ${out}
	sleep 120
	Stop -s HTTPD_SVN
fi
}


controle_arret_httpd ()
{
if [ `/bin/grep httpd ${out1} | wc -l` -eq 0 ]
then
        echo -e "\033[31mLe service httpd est arrete, l'archive svn va etre decompressee\033[00m"
else
        echo -e "\033[31mL'arret du service httpd de ${rep1} est KO\033[00m"
        echo "Bonjour," > ${out}
        echo "" >> ${out}
	echo "Le service httpd de ${rep1} ne s'est pas arrete correctement le $(date +'%d/%m/%Y a %H:%M')" >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN][${J_DAY}] - L'arret du service httpd de ${rep1} est KO" ld-tip-app-bgc-rri@natixis.com < ${out}
        exit 1
fi
}


resto_2 ()
{
mv ${rep1} ${rep2}_${J_DAY}
tar xvf ${fic}

if [ $? == 0 ]
then
        Start -s HTTPD_SVN
else
        exit 1
fi
}


controle_demarrage_httpd ()
{
if [ `/bin/grep httpd ${out1} | wc -l` -ge 1 ]
then
        echo -e "\033[31mLe service httpd de ${rep1} est demarre\033[00m"
        echo "Bonjour," > ${out}
        echo "" >> ${out}
        echo "La restauration du repertoire ${rep} est OK le $(date +'%d/%m/%Y a %H:%M')" >> ${out}
        echo "" >> ${out}
        echo "Le service httpd de ${rep1} est demarre, ${rep1} est disponible" >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN] [${J_DAY}] - Restauration et redemarrage de ${rep1} via tsm OK" ld-tip-app-bgc-rri@natixis.com < ${out}
else
        echo -e "\033[31mLe demarrage du service htppd de ${rep1} est KO\033[00m"
        echo "Bonjour," > ${out}
        echo "" >> ${out}
        echo "Le service httpd de ${rep1} n'a pas demarree correctement le $(date +'%d/%m/%Y a %H:%M'), vérifier le process httpd et le relancer manuellement" >> ${out}
        echo "" >> ${out}
        echo "Le service httpd de ${rep1} est demarre, svn est disponible" >> ${out}
        echo "" >> ${out}
        echo "cdt," >> ${out}
        mailx -r mbx-tip-app-bfi-rri@natixis.com -s "[${ENVI}][SVN][${J_DAY}] - Le demarrage du service htppd de ${rep1} est KO" ld-tip-app-bgc-rri@natixis.com < ${out}
        exit 1
fi
}


# Main
rep1=svn
rep2=svn_crash
rep=/slqdl7bdd01/appli/dl7/svn
rep_backup=/slqdl7bdd01/appli/dl7/sp/backup
rep_appli=/slqdl7bdd01/appli/dl7
fic=svn_pcf.tar
fic2=subversion.tar
out=${rep_appli}/QDL7_OREST_SVN_TSM_RRI/logs/tsm.log
out1=${rep_appli}/QDL7_OREST_SVN_TSM_RRI/logs/svn_tmp.log
out2=${rep_appli}/QDL7_OREST_SVN_TSM_RRI/logs/tsm_rest.log
out3=${rep_appli}/QDL7_OREST_SVN_TSM_RRI/logs/tsm_rest_tmp.log
toto=${rep_appli}/QDL7_OREST_SVN_TSM_RRI/logs/toto.log
J_DAY=$(date "+%Y%m%d")
ENVI=PREX


cd ${rep_appli}
ls -A | grep "${fic}" > ${out1}
resto_svn_tsm

controle_resto && sleep 5

ps -ef | grep httpd | grep -v grep > ${out1}
controle_arret_httpd

resto_2 && sleep 5

ps -ef | grep httpd | grep -v grep > ${out1}
controle_demarrage_httpd

mv svn_crash_${J_DAY} svn_test
cd svn_test
rm -rf svn_crash_*
rm -f ${out} ${out1} ${out3} ${toto} ${rep_appli}/${fic}
