#!/usr/bin/ksh
# Cet outil sert à surveiller les FS
# Prerequis : répertoires /apps/meoatlas2/outils, /apps/meoatlas2/log,/apps/meoatlas2/outils/files
# /apps/meoatlas2/outils/files/list_fs_P1 : caractère utilisé dans EGREP pour la liste de des FS à 70%
# /apps/meoatlas2/outils/files/FS_suspend.lst : fichier comptenant la liste des FS à suspendre
# /apps/meoatlas2/outils/files/mail_cc.lst : liste des contacts en copie des mails
# $1 : [ -m ] pour envoi de mail à la boite commune
# Version    : 1.2
# 07/05/2013 : Creation A.MARIE-JEANNE 
#=================================================================
[[ $# -gt 1 ]] && echo "Usage : $0 " && exit
[[ $(id -un) != "root" ]] && echo "Seul un user <root> a le droit d'executer le script." && exit

export MEO_WORK=/apps/meoatlas2/outils
export MEO_FILE=$MEO_WORK/files
export MEO_LOG=/apps/meoatlas2/log/check_FS.log_$(date +"%Y%m%d%H%M%S")
export MEO_MAIL=/apps/meoatlas2/log/check_FS.mail_$(date +"%Y%m%d%H%M%S")
export MEO_TMP=/apps/meoatlas2/log/check_FS.tmp

# Calcul des VG
> ${MEO_TMP}.vg ; > ${MEO_TMP}.vg_l
lsvg | while read VG 
do
	vg_free_tmp=$(lsvg $VG |awk -F"[(]|[)]|megabytes" '/FREE PPs:/ {print $2}')
	[[ $vg_free_tmp -ne '0' ]] && let "VG_FREE=$vg_free_tmp/1024"
	
	echo "$VG: [free ${VG_FREE}G]" >> ${MEO_TMP}.vg
	echo "\n$(lsvg -l $VG)" >> ${MEO_TMP}.vg_l
done

# FS total
> ${MEO_TMP}.fs_P1 ; > ${MEO_TMP}.fs_P2 ; > ${MEO_TMP}.fs_suspend
df -g |grep "/dev" > ${MEO_TMP}.fs_all

# On enleve les FS en cours de commande de disque (defini dans FS_suspend.lst)

[[ -s $MEO_FILE/FS_suspend.lst ]] &&
for suspendFS in $(cat $MEO_FILE/FS_suspend.lst)
do
	# On remonte un alerte par precaution chaque Lundi 
	[[ $(date +"%a") == @(Mon|Lun) ]] && grep -w $suspendFS ${MEO_TMP}.fs_all |awk '{print $4" "$NF}' | while read PCT_FS FS
	do
		FS_VG=$(grep -p -w $FS ${MEO_TMP}.vg_l |head -1 |cut -d: -f1)
		FREE_FS=$(df -g $FS |tail -1 |awk '{print $3"G"}')
		#VG   FreeVG   FS   %FS   FreeFS
		echo "$FS_VG\t\t$FS\t$PCT_FS\t$FREE_FS" >> ${MEO_TMP}.fs_suspend
	done

	grep -v -w $suspendFS ${MEO_TMP}.fs_all > ${MEO_TMP}.fs_all.tmp
	mv ${MEO_TMP}.fs_all.tmp ${MEO_TMP}.fs_all
done

# FS Atlas
egrep "$(cat $MEO_FILE/list_fs_P1)" ${MEO_TMP}.fs_all |awk '{if(length($4) > "2" && substr($4,1,2) > "70") {print $4" "$NF}}' | while read PCT_FS FS
do
	FS_VG=$(grep -p -w $FS ${MEO_TMP}.vg_l |head -1 |cut -d: -f1)
	FREE_FS=$(df -g $FS |tail -1 |awk '{print $3"G"}')
	#VG   FreeVG   FS   %FS   FreeFS
	echo "$FS_VG\t\t$FS\t$PCT_FS\t$FREE_FS" >> ${MEO_TMP}.fs_P1
done

# FS Autres
egrep -v "$(cat $MEO_FILE/list_fs_P1)" ${MEO_TMP}.fs_all |awk '{if(length($4) > "2" && substr($4,1,2) > "80") {print $4" "$NF}}' | while read PCT_FS FS
do
	FS_VG=$(grep -p -w $FS ${MEO_TMP}.vg_l |head -1 |cut -d: -f1)
	FREE_FS=$(df -g $FS |tail -1 |awk '{print $3"G"}')
	#VG   FreeVG   FS   %FS   FreeFS
	echo "$FS_VG\t\t$FS\t$PCT_FS\t$FREE_FS" >> ${MEO_TMP}.fs_P2
done


#Le lundi on remonte les FS suspendus en cas d oubli
if [[ -s ${MEO_TMP}.fs_suspend ]] then
echo "
==============================================================
ATTENTION FS Suspendus :
==============================================================" |tee -a $MEO_LOG
	for VG in $(awk '{print $1}' ${MEO_TMP}.fs_suspend |sort -u)
	do
		echo "\nVG $(grep -w $VG ${MEO_TMP}.vg)\n---" |tee -a $MEO_LOG
		grep $VG ${MEO_TMP}.fs_suspend |awk '{print $2"\t[à "$3"]\t[free: "$4"]"}'|tee -a $MEO_LOG
		echo "----------------------------------------------------" |tee -a $MEO_LOG
	done
fi

if [[ -s ${MEO_TMP}.fs_P1 ]] then
echo "
==============================================================
FS Critique > 70% :
=============================================================="|tee -a $MEO_LOG
	for VG in $(awk '{print $1}' ${MEO_TMP}.fs_P1 |sort -u)
	do
		echo "\nVG $(grep -w $VG ${MEO_TMP}.vg)\n---" |tee -a $MEO_LOG
		grep $VG ${MEO_TMP}.fs_P1 |awk '{print $2"\t[à "$3"]\t[free: "$4"]"}'|tee -a $MEO_LOG
		echo "----------------------------------------------------" |tee -a $MEO_LOG
	done
fi

if [[ -s ${MEO_TMP}.fs_P2 ]] then
echo "
==============================================================
FS Autres > 80% :
=============================================================="|tee -a $MEO_LOG
	for VG in $(awk '{print $1}' ${MEO_TMP}.fs_P2 |sort -u)
	do
		echo "\nVG $(grep -w $VG ${MEO_TMP}.vg)\n---" |tee -a $MEO_LOG
		grep $VG ${MEO_TMP}.fs_P2 |awk '{print $2"\t[à "$3"]\t[free: "$4"]"}'|tee -a $MEO_LOG
		echo "----------------------------------------------------" |tee -a $MEO_LOG
	done
fi

[[ $1 == "-m" ]] &&
if [[ -s ${MEO_TMP}.fs_P1 || -s ${MEO_TMP}.fs_P2 || -s ${MEO_TMP}.fs_suspend ]] then
echo "Subject: ALERTE FILESYSTEM PROD : $(hostname)
To: meo_atlas_paris
Cc: $(cat $MEO_FILE/mail_cc.lst)
Bonjour,

Merci de traiter les points suivants sur la Prod : $(hostname)

$(cat $MEO_LOG )

Cdlt,
Mise En Oeuvre IRB

PS : généré par $0
Remplir le fichier [$MEO_FILE/FS_suspend.lst] pour suspendre temporairement la surveillance d un FS " >>$MEO_MAIL &&
sendmail -f meo_atlas_paris -t < $MEO_MAIL 

fi

