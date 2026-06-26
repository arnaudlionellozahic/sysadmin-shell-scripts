#!/bin/ksh

export LANG=us_US
HOST=`hostname`
OUTPUT=/tmp/chksrv_${HOST}.txt
exec 1>$OUTPUT 2>/dev/null

function lsora
{
	[ ! -d /apps/oracle ] && return
	> /tmp/dirora
	for i in `egrep -v "^#|^$" /etc/oratab`
	do
		echo $i|awk -F ":" '{print $1" "$2}'|read inst dir
		if [ -f ${dir}/dbs/init${inst}.ora ]
		then
			grep arch ${dir}/dbs/init${inst}.ora|awk -F "=" '{print $2}' >> /tmp/dirora
			ifile=`grep ifile ${dir}/dbs/init${inst}.ora|awk -F "=" '{print $2}'`
			ctfile=`grep control_file $ifile|awk -F "=" '{print $2}'|awk -F "," '{print $1}'|sed s/\(//`
			dirname $ctfile >> /tmp/dirora
			for j in `strings $ctfile|grep "^/"`
			do
				dirname $j
			done|sort -u|grep -v "^/$" >> /tmp/dirora
		fi
	done
	for i in `cat /tmp/dirora`
	do
		df $i |tail -1|awk '{print $1}'	
	done|sort -u >>/tmp/lvimp
	cp /tmp/lvimp /tmp/oradbonly
	df|grep exp|grep ora |awk '{print $1}' >>/tmp/lvimp
	df|grep back|grep -v mksysb|awk '{print $1}' >>/tmp/lvimp
}

function lsatlas
{
	df|grep data|egrep "fic|imp"|awk '{print $1}' >>/tmp/lvimp
	df|grep work|grep -v ora|awk '{print $1}' >>/tmp/lvimp
}

function entete
{
	echo ""
	echo "---- $*"
	echo "----------------------------------------------------------------"
	echo ""
}

entete Action 1.1 :: Configuration systeme

echo "HW			:	`uname -M` `lsattr -El proc0|grep type|awk '{print $2}'` `pmcycles|awk '{print $5 $6}`"
typeset integer j=1
for i in `lparstat -i|egrep "Type|Entitled Capacity|Online Virtual CPU|Maximum Virtual CPU|Online Memory|Maximum Memory|Maximum Capacity"|grep -v Pool|awk -F ":" '{print $2}'`
do
	[ $j -eq 1 ] && smt=$i
	[ $j -eq 2 ] && ce=$i
	[ $j -eq 3 ] && vp=$i
	[ $j -eq 4 ] && vpm=$i
	[ $j -eq 5 ] && ram=$i
	[ $j -eq 7 ] && ramm=$i
	[ $j -eq 9 ] && cem=$i
	let j=j+1

done
echo "CE  (actuel/max)	:	$ce / $cem"
echo "VP  (actuel/max)	:	$vp / $vpm"
echo "RAM (actuel/max)	:       $ram / $ramm"
echo "SMT			:	$smt" 

entete Action 1.2 :: Fuseau horaire
date

entete Action 2.1 :: Rapport erreur AIX
errpt -T PERM

entete Action 2.2 :: Sanity Check BP2I
grep BAD `ls -tr /tmp/*AixSan*|tail -1`

entete Action 2.3 :: Activite systeme et disque
echo "-- Activite systeme"
sar|grep Average
echo ""
echo "-- Activite disque"
sar -d|grep hdiskpower|grep -v " 0      0.0 "

entete Action 3.1 :: Acces disque
echo "-- Cartes E/S"
lsdev -Cc adapter
echo ""
echo "-- Disques virtuels"
for i in ` lsdev -Cc disk|grep Virtual|awk '{print $1}'`
do
lspv $i|grep "VOLUME GROUP"
done

entete Action 3.2 :: Parametrage cartes FC
echo ""
echo "---- Parametres attendus:	max_xfer_size=0x200000 et num_cmd_elems=2048"
echo ""        

echo "HBA  : max_xfer_size num_cmd_elems"
for i in `lsdev -Cc adapter|grep fcs|awk '{print $1}'`
do
	echo "$i : `lsattr -El $i|grep max_xfer_size|awk '{print $2}'`		`lsattr -El $i|grep num_cmd_elems|awk '{print $2}'`" 
done

entete Action 3.3 :: FS non jfs2
lsvg -o|lsvg -i -l|egrep -v "jfs2|boot|paging|sysdump|MOUNT POINT"

# construi liste des LV important
>/tmp/lvimp
lsora
lsatlas

entete Action 3.4 :: Repartition LV important sur plusieurs disques

echo "Nb Disque		LV"
for i in `cat /tmp/lvimp`
do
	lv=`basename $i`
	nb=`lslv -l $lv|egrep -v "COPIES|${lv}"|wc -l`
	echo "$nb	$i"
done

entete Action 3.5 :: Positionnement des LV sur les disques 
echo ""
echo "---- Parametres attendus:	inter-policy=maximum, write verify=off"
echo "----	intra-policy=center pour datafiles applicatifs Oracle et ficsav ATLAS"
echo "----	intra-policy=middle ou inner middle pour datafiles système Oracle"
echo "----	intra-policy=edge ou inner edge pour le reste"
echo ""

for i in `cat /tmp/lvimp`
do
	lv=`basename $i`
	lslv $lv >/tmp/lblv
	wr=`grep "WRITE VERIFY" /tmp/lblv|awk '{print $4}'`
	inter=`grep "INTER-POL" /tmp/lblv|awk '{print $2}'`
	intra=`grep "INTRA-POL" /tmp/lblv|awk '{print $2}'`
	echo "$i		InterPolicy: $inter	IntraPolicy: $intra	WriteVerify: $wr"
done

entete Action 3.6 :: Parametre JFS2
echo ""
echo "---- Parametres attendus:	j2_nBufferPerPagerDevice=2048 et j2_dynamicBufferPreallocation=128 minimum"
echo ""

ioo -a|grep j2|grep Buffer

entete Action 3.7 :: FS monte en CIO

lsfs|grep cio

entete Action 3.8 :: agblksize
echo ""
echo "---- Parametres attendus:	agblksize=4096 pour datafiles Oracle et 512 pour redologs"
echo ""

echo "	blocksz	  LV"
for i in `cat /tmp/oradbonly`
do
	blc=`lsfs -q $i|grep "block size"|awk '{print $9}'|tr "\," " "`
	echo "	$blc	$i"
done

entete Action 3.9 : disque qdepth
echo ""
echo "---- Parametres attendus:	queue_depth=40"
echo ""
for i in `cat /tmp/oradbonly`
do
        lv=`basename $i`
	echo "--LV: $i"
	for j in `lslv -l $lv|grep "^hd"|awk '{print $1}'`
	do
		echo "	$j \c"
		lsattr -El $j|grep queue_depth|awk '{print $2}'
	done
done

entete Action 3.10 :: Nb jfslog

for i in `lsvg -o|egrep -v "rootvg|vg_apps"`
do
	echo "-- VG: "$i
	lsvg -l $i|egrep "jfslog|jfs2log"
done

for i in `cat /tmp/lvimp`
do
        Opt=`lsfs -q $i|tail -1|awk -F "," '{print $5}'`
        echo $i" "$Opt
done


rm /tmp/dirora
rm /tmp/lvimp
rm /tmp/oradbonly
