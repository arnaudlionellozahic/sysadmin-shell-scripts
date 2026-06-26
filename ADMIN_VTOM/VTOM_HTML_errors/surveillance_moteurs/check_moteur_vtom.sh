
#!/bin/ksh
# 
# script de surveillance des moteurs VTOM
#
# NGU le 08/09/2011

MOTEUR=$1 

help(){
	echo "-h|--help"
	echo "Afficher l'aide!"
	echo "Usage: $0 nom_de_moteur"
	}

setup(){	
	VT_PROC=`ps -ef|grep tengine|grep "$MOTEUR" |awk -F ' ' '{print $9}'`

	if [ "$VT_PROC" = "$MOTEUR" ]; then
		echo "Le moteur VTOM: $MOTEUR est demarre"
		exit 0
	else 
		echo "VTOM: INCIDENT SUR LE MOTEUR $MOTEUR"
		exit 2
	fi
	}

if [ "$1" = "-h" ] || [ "$1" = "--help" ];then
	
	help

elif [ -z "$1" ];then

	echo "Saisissez un nom de moteur /!\\"
else

	setup
fi
