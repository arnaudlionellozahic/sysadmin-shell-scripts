#!/bin/ksh

##################################################################
#   Script de creation de packages
#   Christophe CONGIUSTI
#   29/04/2002
##################################################################

# Go to compilation dir
cd $HOME/packages

# Recuperation des parametres
if [ $# -eq 4 ]; then
	pack_os=$1
	pack_tag=$2
	pack_root=$3
	pack_langue=$4
else
	echo "syntaxe: make_it.ksh <os> <tag> <dir> <lng>"
	echo "<os>  - un nom d'OS (ex:SOL,AI3,AI4,HP,LINUX,HPIT,...)"
	echo "<tag> - une estampille (Version 4.1)"
	echo "<dir> - un repertoire (vtom41)"
	echo "<lng> - une langue (Fr_FR/En_US)"
	exit 1
fi


# En fct. du type d'OS
case "$pack_os" in
	"AI4")		pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"HP")		pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"SOL")		pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"LINUX")	pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"HPIA64")	pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"HPIT")		pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"DECUX")	pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"SOL_X86")	pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"LINUX_X64")	pack_list='CS SDS SNMP PATROL NETDW WEBDOC';;
	"LINUX_IA64")	pack_list='CS';;
	"NCR")		pack_list='CS';;
	"SCO")		pack_list='CS';;
	"UNIXWARE")	pack_list='CS';;
	*)
		echo "Unknown pack OS ($pack_os)"
		exit 1
	esac

cd $pack_root
for pack_type in $pack_list
do
	case "$pack_type" in
		"CS")		./create_pack CS $pack_os "$pack_tag" "$pack_langue";;
		"SDS")		./create_pack SDS $pack_os "$pack_tag" "$pack_langue";;
		"SNMP")		./create_pack SNMP $pack_os "$pack_tag SNMP" "$pack_langue";;
		"PATROL")	./create_pack PATROL $pack_os "$pack_tag PATROL" "$pack_langue";;
		"NETDW")	./create_pack NETDW $pack_os "$pack_tag NETDW" "$pack_langue";;
		"WEBDOC")	./create_pack WEBDOC $pack_os "$pack_tag WEBDOC" "$pack_langue";;
		"*")
			echo "Unknown pack TYPE ($pack_type)"
			exit 1
		esac

	if [ $? -ne 0 ]; then
		echo "Build failed!!!"
		exit 1
	fi
done