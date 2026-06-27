#!/bin/ksh

cd /mscoutille/appli/q04/QQ04_DALIM_TIERS_PR2/cft

for u in `cat liste.txt`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.txt\(.*\)/cp & ${toto}.txt/" | sh ; mv ${toto}.txt ../${u}.wait/
cd ..
done

for u in `cat liste.CFT`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.CFT\(.*\)/cp & ${toto}.CFT/" | sh ; mv ${toto}.CFT ../${u}.wait/
cd ..
done

for u in `cat liste.xml`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.xml\(.*\)/cp & ${toto}.xml/" | sh ; mv ${toto}.xml ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DMARKET_DATA_PR2/cft

for u in `cat liste.txt`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.txt\(.*\)/cp & ${toto}.txt/" | sh ; mv ${toto}.txt ../${u}.wait/
cd ..
done

for u in `cat liste.xml`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.xml\(.*\)/cp & ${toto}.xml/" | sh ; mv ${toto}.xml ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DREGLE_LIVR_PR2/cft

for u in `cat liste.txt`
do
cd ${u}.done
toto=`ls -1 | tail -1 | awk -F"." '{print $1}'` ; ls -1 | tail -1 | sed "s/${toto}.txt\(.*\)/cp & ${toto}.txt/" | sh ; mv ${toto}.txt ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DALIM_ABAQUES_PR2/cft

for u in `ls -1 | awk -F"." '{print $1}' | sort -n | uniq`
do
cd ${u}.done
toto=`ls -1 report_ABAQ_20*.tar.gz* | tail -1 | awk -F"-" '{print $1}'` ; ls -1 report_ABAQ_20*.tar.gz* | tail -1 | sed "s/${toto}\(.*\)/cp & ${toto}/" | sh ; mv ${toto} ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DLOADER_AM_PR2/cft

for u in `ls -1 | awk -F"." '{print $1}' | sort -n | uniq`
do
cd ${u}.done
toto=`ls -1 report_NATIXIS_20*.tar.gz* | tail -1 | awk -F"-" '{print $1}'` ; ls -1 report_NATIXIS_20*.tar.gz* | tail -1 | sed "s/${toto}\(.*\)/cp & ${toto}/" | sh ; mv ${toto} ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DLOADER_PM_PR2/cft

for u in `ls -1 | awk -F"." '{print $1}' | sort -n | uniq`
do
cd ${u}.done
toto=`ls -1 report_full_20*.tar.gz* | tail -1 | awk -F"-" '{print $1}'` ; ls -1 report_full_20*.tar.gz* | tail -1 | sed "s/${toto}\(.*\)/cp & ${toto}/" | sh ; mv ${toto} ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DINTRADAY_AM_PR2/cft

for u in `ls -1 | awk -F"." '{print $1}' | sort -n | uniq`
do
cd ${u}.done
toto=`ls -1 report_intraday_AM_20*.tar.gz* | tail -1 | awk -F"-" '{print $1}'` ; ls -1 report_intraday_AM_20*.tar.gz* | tail -1 | sed "s/${toto}\(.*\)/cp & ${toto}/" | sh ; mv ${toto} ../${u}.wait/
cd ..
done

cd /mscoutille/appli/q04/QQ04_DINTRADAY_PM_PR2/cft

for u in `ls -1 | awk -F"." '{print $1}' | sort -n | uniq`
do
cd ${u}.done
toto=`ls -1 report_intraday_PM_20*.tar.gz* | tail -1 | awk -F"-" '{print $1}'` ; ls -1 report_intraday_PM_20*.tar.gz* | tail -1 | sed "s/${toto}\(.*\)/cp & ${toto}/" | sh ; mv ${toto} ../${u}.wait/
cd ..
done
