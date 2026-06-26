#! /bin/ksh
#Arnaud Lozahic
#version 0.1 création de la version pour la prex
#version 0.2 ajout des fonctions de recup de la prod
#version 0.3 ajout de la copie du env.ksh + mise en 775 des scripts
#version 0.4 correction du bug de non creation de l'arbo quand la racine existe
#version 0.5 demande d'import des scripts en prod script par script

_ENVIR=p
_APP=x6a
_HOST=mspx6aubat01


#variables pour la prod
_HOST_SRC=msux6aubat01
_USER_SRC=ux6aadmin
_ENVIR_SRC=u



echo "saisir le nom de la chaine:"
read _CHAINE
if [ -z ${_CHAINE} ]; then
        echo "Le nom de chaine est vide"
        exit 1
fi

_ENVIR_MAJ=$(echo ${_ENVIR}|tr "[a-z]" "[A-Z]")
_APP_MAJ=$(echo ${_APP}|tr "[a-z]" "[A-Z]")
_CHEMIN=/${_HOST}/appli/${_APP}/${_ENVIR_MAJ}${_APP_MAJ}_${_CHAINE}

#création de l'arbo
if [ ! -d ${_CHEMIN} ]; then
    mkdir ${_CHEMIN}
	echo "creation du rep ${_CHEMIN}"
fi
if [ ! -d ${_CHEMIN}/cft ]; then
	mkdir ${_CHEMIN}/cft
	echo "creation du rep ${_CHEMIN}/cft"
fi
if [ ! -d ${_CHEMIN}/error ]; then
	mkdir ${_CHEMIN}/error
	echo "creation du rep ${_CHEMIN}/error"
fi
if [ ! -d ${_CHEMIN}/logs ]; then
	mkdir ${_CHEMIN}/logs
	echo "creation du rep ${_CHEMIN}/logs"
fi
if [ ! -d ${_CHEMIN}/travaux ]; then
	mkdir ${_CHEMIN}/travaux
	echo "creation du rep ${_CHEMIN}/travaux"
fi
if [ ! -d ${_CHEMIN}/${_ENVIR}v ]; then
	mkdir ${_CHEMIN}/${_ENVIR}v
	echo "creation du rep ${_CHEMIN}/${_ENVIR}v"
fi
if [ ! -d ${_CHEMIN}/${_ENVIR}v/etc ]; then
	mkdir ${_CHEMIN}/${_ENVIR}v/etc
	echo "creation du rep ${_CHEMIN}/${_ENVIR}v/etc"
fi
if [ ! -d ${_CHEMIN}/${_ENVIR}v/sbin ]; then
	mkdir ${_CHEMIN}/${_ENVIR}v/sbin
	echo "creation du rep ${_CHEMIN}/${_ENVIR}v/sbin"
fi
if [ ! -d ${_CHEMIN}/${_ENVIR}v/sbin/REP_OLD ]; then
	mkdir ${_CHEMIN}/${_ENVIR}v/sbin/REP_OLD
	echo "creation du rep ${_CHEMIN}/${_ENVIR}v/sbin/REP_OLD"
fi
#si l'environnement est la prex
if [ ${_ENVIR_MAJ} = P ]; then


#creation du parms.ini
    if [ ! -d ${_CHEMIN}/${_ENVIR}v/etc/parms.ini ]; then
        echo "#REPERTOIRE# ARCHIVAGE# SUPPRESSION" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
        echo "logs:15:45" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
        echo "travaux:15:45" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
		for i in $(ls ${_CHEMIN}/cft);do
            echo "cft/${i}:15:45" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
        done
    fi

#creation de la sous arbo cft
	echo "saisir le nombre de flux cft dont-il faut creer l'arbo :"
	read _NUMBER_MAX
	_NUMBER=0
	while [ ${_NUMBER} -lt _NUMBER_MAX ] ; do
		echo "saisir le nom du flux cft dont il faut creer l'arbo :"
		read _FLUX
		_FLUX=$(echo ${_FLUX}|tr "[a-z]" "[A-Z]")
		if [ ! -d ${_CHEMIN}/cft/${_FLUX}.done ]; then
            mkdir ${_CHEMIN}/cft/${_FLUX}.done
            echo "creation du rep ${_CHEMIN}/cft/${_FLUX}.done"
		fi
		if [ ! -d ${_CHEMIN}/cft/${_FLUX}.wait ]; then
			mkdir ${_CHEMIN}/cft/${_FLUX}.wait
			echo "creation du rep ${_CHEMIN}/cft/${_FLUX}.wait"
		fi
		
#ajout des purges de la sous arbo cft dans le parms.ini
		echo "cft/${_FLUX}.done:15:45" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
		echo "cft/${_FLUX}.wait:15:45" >> ${_CHEMIN}/${_ENVIR}v/etc/parms.ini
		
		_NUMBER=${_NUMBER}+1
	done
fi
#si l'environnement est la prod
if [ ${_ENVIR_MAJ} = X ]; then
	if [ -z ${_USER_SRC} ]; then
			echo "Merci de parametrer le user source"
			exit 1
	fi
	if [ -z ${_HOST_SRC} ]; then
			echo "Merci de parametrer le host source"
			exit 1
	fi
	if [ -z ${_ENVIR_SRC} ]; then
			echo "Merci de parametrer l'environnement source"
			exit 1
	fi
	_ENVIR_SRC_MAJ=$(echo ${_ENVIR_SRC}|tr "[a-z]" "[A-Z]")
	_CHEMIN_SRC=/${_HOST_SRC}/appli/${_APP}/${_ENVIR_SRC_MAJ}${_APP_MAJ}_${_CHAINE}
#récup de la sous arbo cft
	for i in $(ssh ${_USER_SRC}@${_HOST_SRC} "ls ${_CHEMIN_SRC}/cft");do
		if [ ! -d ${_CHEMIN}/cft/${i} ]; then
			mkdir ${_CHEMIN}/cft/${i}
			echo "creation du rep ${_CHEMIN}/cft/${i}"
		fi
	done
#récup du parms.ini s'il existe
	echo "Voulez-vous importer le parms.ini y/n"
	read _REPONSE
	if [ ${_REPONSE} = y ]; then
		#sauvegarde du parms.ini s'il existe
		if [ -f ${_CHEMIN}/${_ENVIR}v/etc/parms.ini ]; then
			cp ${_CHEMIN}/${_ENVIR}v/etc/parms.ini ${_CHEMIN}/${_ENVIR}v/etc/parms.ini.$(date '+%Y.%m.%d.%H%M%S')
			echo "sauvegarde du parms.ini"
		fi
		#copie du parms.ini
		scp ${_USER_SRC}@${_HOST_SRC}:${_CHEMIN_SRC}/${_ENVIR_SRC}v/etc/parms.ini ${_CHEMIN}/${_ENVIR}v/etc
		if [ ! -f ${_CHEMIN}/${_ENVIR}v/etc/parms.ini ]; then
			echo "Attention, le parms.ini n'existe pas"
		fi
	fi
#récup du env.ksh s'il existe
	echo "Voulez-vous importer le env.ksh y/n"
	read _REPONSE
	if [ ${_REPONSE} = y ]; then
		#sauvegarde du env.ksh s'il existe
		if [ -f ${_CHEMIN}/${_ENVIR}v/etc/env.ksh ]; then
			cp ${_CHEMIN}/${_ENVIR}v/etc/env.ksh ${_CHEMIN}/${_ENVIR}v/etc/env.ksh.$(date '+%Y.%m.%d.%H%M%S')
			echo "sauvegarde du env.ksh"
		fi
		#copie du parms.ini
		scp ${_USER_SRC}@${_HOST_SRC}:${_CHEMIN_SRC}/${_ENVIR_SRC}v/etc/env.ksh ${_CHEMIN}/${_ENVIR}v/etc
		if [ ! -f ${_CHEMIN}/${_ENVIR}v/etc/env.ksh ]; then
			echo "Attention, le env.ksh n'existe pas"
		fi
	fi
#récup des scripts
	for i in $(ssh ${_USER_SRC}@${_HOST_SRC} "ls ${_CHEMIN_SRC}/${_ENVIR_SRC}v/sbin/${_ENVIR_SRC_MAJ}*");do
		_BASENAME=$(basename ${i})
		echo "Voulez-vous importer le script ${_BASENAME} dans sbin y/n"
		read _REPONSE
		if [ ${_REPONSE} = y ]; then
			#sauvegarde du script s'il existe
			if [ -f ${_CHEMIN}/${_ENVIR}v/sbin/${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}} ]; then
				cp ${_CHEMIN}/${_ENVIR}v/sbin/${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}} ${_CHEMIN}/${_ENVIR}v/sbin/REP_OLD/${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}}.$(date '+%Y.%m.%d.%H%M%S')
				echo "sauvegarde du script ${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}} dans REP_OLD"
			fi
			#copie du script avec renommage de celui-ci
			echo "import du script ${_BASENAME} et renommage en ${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}}"
			scp ${_USER_SRC}@${_HOST_SRC}:${i} ${_CHEMIN}/${_ENVIR}v/sbin/${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}}
			chmod 775 ${_CHEMIN}/${_ENVIR}v/sbin/${_ENVIR_MAJ}${_BASENAME#${_ENVIR_SRC_MAJ}}
		fi
	done
fi

exit 0