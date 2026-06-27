#!/usr/bin/ksh

if [ $(whoami) != "root" ]
then
echo " Il faut etre root pour le bon fonctionnement de ce script"
        exit
fi

if [[ "$#" != "1" ]] ; then
        echo "Usage    : `basename $0` seuil"
        echo "Exemple  : ./`basename $0` 70 correspond a un seuil de 70% une alerte sera envoyee dans le mail pour chaque FS qui dépasse ce seuil"
        exit 1
fi

SEUIL=$1
LOG=/apps/meoatlas2/log/check_FS.log
MAIL=/apps/meoatlas2/log/check_FS_mail
> ${LOG}
for i in $(df -m |awk '{print $7}'|egrep -v "/proc|%Iused")
do
	FS=$(df -m $i |awk '{print $7}'|tail -1)
	LV=$(df -m $i |awk '{print $1}'|awk -F/ '{print $3}'|tail -1)
	FS_SPACE=$(df -m $i |awk '{print $4}' |tail -1|awk -F% '{print $1}')
	VG=$(lslv ${LV} |grep VOLUME |awk '{print $6}')
	FREE_SPACE_VG=$(lsvg ${VG} |grep FREE|awk -F"(" '{print $2}'|awk '{print $1}')
	if [[ "${FS_SPACE}" -gt "${SEUIL}" ]]
	then
		echo "Le FS ${FS} est a ${FS_SPACE}% merci de l agrandir pour qu il soit en dessous de ${SEUIL}%" >> ${LOG}
		echo "Il reste actuellement ${FREE_SPACE_VG} Mb sur ${VG} si ce n'est pas suffisant verifier si un disk est dispo et l ajouter puis agrandir le FS" >> ${LOG}
		echo ${VG} |grep -i bcv >/dev/null 2>&1
                if [[ $? -eq 0 ]]
		then
			echo "Attention ce FS est sur un VG Time Finder si vous devez ajouter un disk merci d utiliser la doc ajout d'un disque Time Finder" >> ${LOG}
		fi	
		echo "" >> ${LOG}
		echo "_________________________________________________________________________________________________________________" >> ${LOG}
		echo "" >> ${LOG}
	fi	 
done

# Envoi du mail
if [[ -s ${LOG} ]]
then

echo "Subject: Verification du remplissage des FS de $(hostname)" > ${MAIL}
echo "To: meo_atlas_paris" >> ${MAIL}
echo "Cc: laurent.molitor@bnpparibas.com" >> ${MAIL}

echo "Bonjour,"  >> ${MAIL}
echo >> ${MAIL}
echo >> ${MAIL}


echo "Machine : $(hostname)"  >> ${MAIL}
echo >> ${MAIL}
echo "Liste des FS qui sont remplis à + de ${SEUIL}% :" >> ${MAIL}
echo >> ${MAIL}
echo >> ${MAIL}
cat $LOG >> ${MAIL}
echo >> ${MAIL}
echo >> ${MAIL}
echo Cordialement >> ${MAIL}
echo Mise En Oeuvre ATLAS2 >> ${MAIL}

sendmail -f paris_ips_meo_irb@bnpparibas.com -t <  ${MAIL}

fi
