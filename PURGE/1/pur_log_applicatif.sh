#! /bin/ksh

################################################
# But:
#
# Effectue une action de maintenance en fonction
# du compte applicatif
#
# pbytela  :
#	Nettoyage du journal d'execution
#	Purge des logs VTOM sur $retention jour(s)
#	Purge de tous les logs en mode test
#	Purge des journaux de statistiques de validation sur $retention jours
#	Nettoyage du fichier de correspondance de service machine
# autre    :
#	Sauvegarde de l'environnement applicatif
#
#----------------------------------------------
# Usage:
#       Pas de parametre
#
#----------------------------------------------
# Date de Modification:
# Ni.POTIER Dece 2003
#
#----------------------------------------------
# Gestion des fichiers:
# Fichier Entree : Aucun
# Fichier Sortie : Aucun
# Fichiers Temporaires : /tmp/$0_TMP_$$
#
#
################################################

# -----------------------------------
# Test pour savoir si on soumet bien
# le script via VTOM
# -----------------------------------

if [ -z "${TOM_JOB_ID}" ] ; then
        print "\nUsage : Ne peut etre appele uniquement que par VTOM\n"
        exit 1
fi

# ------------------------------------------
# Option si on veut executer la meme action
# sur toutes les machines
# ------------------------------------------

#exit

# ------------------------
# Initialisation variable
# ------------------------

# Retention des logs VTOM

tmp=`tval -name R_ret_purge -info`
retention=`echo $tmp | cut -f3 -d":" | sed 's/ //'`

# Fichier tmp pour compter les logs supprimes

fichier_tmp=/tmp/pur_log_applicatif_TMP_$$

# Recuperation MdP pbytela

pass_pb=`cat ${TOM_ADMIN}/.PB`

# alias pour SUN par rapport a l'option
# -q de la commande grep

[ `uname` = "SunOS" ] && alias grep=/usr/xpg4/bin/grep

# -----------------------------------------
# Affichage d'information pour le log VTOM
# -----------------------------------------

echo
echo "Retention sur les logs VTOM et des journaux de validation : $retention jour(s)"
echo

# -------------------------------------------
# Purge des logs VTOM sur $retention jour(s)
# -------------------------------------------

echo;echo "utilisateur : $TOM_USER";echo

if [ "${TOM_USER}" = "pbytela" ]
then
	echo "Administrateur VTOM :";echo

	# ---------------------------------------
	# Suppression du journal_adm s'il existe
	# pour nettoyage
	# ---------------------------------------

	JOURNAL_EXPLOIT=/usr/users/pbytela/log/`hostname`_journal_adm
	if [ -f ${JOURNAL_EXPLOIT} ]
	then
		echo "Suppression du fichier journal adm"
		echo "rm ${JOURNAL_EXPLOIT}"
		rm ${JOURNAL_EXPLOIT}
	else
		echo "Le fichier journal adm n'est pas present"
		echo "donc pas de suppression"
	fi

	# --------------------
	# Purge des logs VTOM
	# --------------------

	echo "Execution de la purge de log VTOM";echo

	echo "find ${ABM_LOGS} -name \"*\" -mtime +$retention -print -exec rm -f {} \;"
	find ${ABM_LOGS} -name "*" -mtime +$retention -print -exec rm -f {} \; > ${fichier_tmp}

	count=`cat ${fichier_tmp} | wc -l`

	echo "Fichier effaces : ";echo
	cat ${fichier_tmp}
	echo
	print "\nNombre de fichiers effaces : $count\n"

	rm ${fichier_tmp}


	# ------------------------------------
	# Purge de tous les logs en mode test
	# ------------------------------------

	echo;echo "Purge des logs du mode test";echo

	cd /usr/users/pbytela/vtom_client/logs
	for fichier in `ls | grep -v "^maintenance_*" | nawk '{ if ( $0 ~ /\.o$/ ) { print $0 }}'`
	do
		fichier_generique=`echo $fichier | cut -d"." -f1`
		grep -q "MODE TEST" $fichier
		if [ "$?" = "0" ]
		then
			echo "rm ${fichier_generique}.*"
			rm ${fichier_generique}.*
		fi
	done

	echo


	# -------------------------------------------------
	# Purge des journaux de statistiques de validation
	# -------------------------------------------------

	echo "Execution de la purge des journaux de validation";echo

	cd /usr/users/pbytela/log

	echo "find . -name \"journal_exe_*.csv\" -ctime +$retention -print  -exec rm -f {} \;"
	find . -name "journal_exe_*.csv" -ctime +$retention -print -exec rm -f {} \; > ${fichier_tmp}

	echo "Fichier effaces : "
	cat ${fichier_tmp}
	echo
	count=`cat ${fichier_tmp} | wc -l`
	print "\nNombre de fichiers effaces : $count\n";echo

	rm ${fichier_tmp}

	# ------------------------------------------------------------
	# Suppression du fichier de conversion service pour nettoyage
	# ------------------------------------------------------------

	[ "$TOM_HOST" = "" ] && TOM_HOST=inconnu
	fichier_conv=$HOME/vtom_client/admin/SERVICE_${TOM_HOST}.txt

	if [ -f ${fichier_conv} ]
	then
		echo "Suppression du fichier de conversion service pour nettoyage"
		echo "rm ${fichier_conv}"
		rm ${fichier_conv}
	else
		echo "Pas de fichier de conversion service"
		echo "Donc pas de suppression"
	fi

# -------------------------------------------------
# correspond a 'if [ "${TOM_USER}" != "pbytela" ]'
# -------------------------------------------------

else
	echo " Utilisateur applicatif sauvegarde de l'environnement";echo
	date=`date '+%Y%m%d'`
	rep_ref=ref_$date
	echo "Repertoire de reference : $rep_ref";echo
	cd

	# Certains clients ont un repertoire "envrionnement"
	# --------------------------------------------------

	if [ -d environnement ]
	then
		ftp -nv bt1sssfe << FIN
			user pbytela ${pass_pb}
			cd outils/ref
			mkdir ${rep_ref}
			cd ${rep_ref}
			mkdir ${TOM_HOST}
			cd ${TOM_HOST}
			mkdir ${TOM_USER}
			cd ${TOM_USER}
			mkdir environnement
			cd environnement
			lcd environnement
			prompt
			mput .*
			bye
FIN
	fi

	# Sauvegarde du repertoire automate/control
	# -----------------------------------------

	if [ -d automate -a -d automate/control ]
	then
		echo "Sauvegarde du repertoire automate/control"
		cd automate/control
		ftp -nv bt1sssfe << FIN
			user pbytela ${pass_pb}
			cd outils/ref
			mkdir ${rep_ref}
			cd ${rep_ref}
			mkdir ${TOM_HOST}
			cd ${TOM_HOST}
			mkdir ${TOM_USER}
			cd ${TOM_USER}
			mkdir automate_control
			cd automate_control
			prompt
			mput *
			mput .*
			bye
FIN
	else
		echo "Le repertoire automate/control ne semble pas exister"
		echo "pas de sauvegarde"
	fi

	echo
fi