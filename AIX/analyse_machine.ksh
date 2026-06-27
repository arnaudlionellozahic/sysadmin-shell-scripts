#!/bin/ksh

cd /apps/meoatlas2/outils/
. ./parametre_machine.ksh

export machine_host=${INFO_HOST}

mkdir ${MEO_ANALYSE}
mkdir ${MEO_LOG}

cd ${MEO_ANALYSE} 

#######################################################################################################
# Recherche sur les FS
#######################################################################################################
# nom du FS; taille du FS; Espace libre du FS; % utilisé ; nom du LV auquel il est rattaché

#export liste_FS="/ficsav /apps/atlas/atlas2v0/uf1/data1/fic /apps/atlas/atlas2v0/uf1/data1/imp /apps/atlas/atlas2v0/uf1/infoc /apps/atlas/atlas2v0/uf1/infocdr  \
#								/apps/oradbf/atpr01 /apps/oradbf/atdr01 /apps/cft_data /apps/arch /apps/oradbf/backup /apps/exploit/work"

df -g  | grep -v proc | awk '{ print $7 ";" $2 ";" $3 ";" $4 ";" $1}' | sed "s/\/dev\///g" | sed '1d' > file_FS.lst

set -A nom_fs $(cat file_FS.lst | awk  -F';' '{print $1 }')
set -A tot_fs $(cat file_FS.lst | awk  -F';' '{print $2}')
set -A free_fs $(cat file_FS.lst | awk  -F';' '{print $3}')
set -A used_fs $(cat file_FS.lst | awk  -F';' '{print $4}')
set -A nom_lv $(cat file_FS.lst | awk  -F';' '{print $5}')

#######################################################################################################
# Recherche des VG :
#######################################################################################################
export i=0
export listeVG=$(lsvg)
for name_vg in $listeVG
do
   lsvg $name_vg > $name_vg.lst
   export nom_vg[$i]=$name_vg
   export taille_vg[$i]=$(cat $name_vg.lst | grep "FREE" |awk '{print $7}'|sed "s/(//g")
   export total_vg[$i]=$(cat $name_vg.lst | grep "TOTAL PPs:" |awk '{print $7}'|sed "s/(//g")
   export nbDisk_vg[$i]=$(cat $name_vg.lst | grep "TOTAL PVs:" | awk '{print $3}')
   ((i=i+1))
done

#######################################################################################################
# Recherche sur le LV
#######################################################################################################
export i=0
for lv_t in ${nom_lv[*]}
do
   lslv $lv_t > $lv_t.lst
   export vg_attache_lv[$i]=$(cat $lv_t.lst | grep "VOLUME GROUP" | awk '{print $6}')
   export type_lv[$i]=$(cat $lv_t.lst |grep "TYPE" | grep -v DEVICESUBTYPE | awk '{print $2}')
   export free_vg[$i]=$(cat ${vg_attache_lv[$i]}.lst | grep "FREE" | awk '{print $7}'|sed "s/(//g")
   export mounted_lv[$i]=$(cat $lv_t.lst | grep "LV STATE" | awk '{print $6}' )
   export max_lp[$i]=$(cat $lv_t.lst| grep "MAX LPs" | awk '{print $3}' )
   ((i=i+1))
done

#######################################################################################################
# Recherche des disques :
#######################################################################################################

#############################
# Init -Time FINDER
#############################
if [[ ($machine_host == "parva4004789") || ($machine_host == "parva400626")  || ($machine_host == "parva4004788") || ($machine_host == "parva4000839") ]]
then
  export liste_pv_tf=$(cat /apps/exploit/shell/envoie/std.lst | tr '\n' '|' | sed "s/|$//g" )
  export liste_pv_add_tf=$(grep display /etc/motd | egrep -v "$liste_pv_tf" | sed "s/ID=//g" |awk '{print $2}'| tr '\n' '|' | sed "s/|$//g")
  if [[ -z $liste_pv_add_tf ]]
  then
	export liste_pv_add_tf="¤"
  fi
else
  export liste_pv_tf="¤"
  export liste_pv_add_tf="¤"
fi

#############################
# Recherche des disques - tri
#############################
lspv | grep hdiskpower | sort -k3 -k1.11,1.13n |awk '{ print $1 ";" $2 ";" $3 ";" $4}'> file_PV.lst

export i=0
for ligne_disque in $(cat file_PV.lst)
do
  export nom_pv[$i]=$(echo $ligne_disque | awk -F";" '{ print $1 }')
  export taille_pv[$i]=$(bootinfo -s ${nom_pv[$i]})
  export logical_id[$i]=$(powermt display dev=${nom_pv[$i]} | grep "Logical device ID" | awk -F"=" '{print $2}')
  export vg_attachpv[$i]=$(echo $ligne_disque | awk -F";" '{ print $3 }')
  export id_pv[$i]=$(echo $ligne_disque | awk -F";" '{ print $2 }')

  export test_tf=$(echo "${logical_id[$i]}" | egrep "$liste_pv_tf" )
  if [[  -n $test_tf  ]]
  then
     export ok_tf[$i]="DisqueTF"
  fi
  
  if  [[ liste_pv_add_tf  != "¤" ]]
  then
	  export test_tf=$(echo "${logical_id[$i]}" | egrep "$liste_pv_add_tf" )
	  if [[  -n $test_tf   ]]
	  then
		 export ok_tf[$i]="DisqueAjoutTF"
	  fi
  fi
  ((i=i+1))
done


#######################################################################################################
# Sortie du fichier :
#######################################################################################################
>analyse.csv
>analyse.csv.tmp


###############
# VG :
###############
export i=0
for nom in ${nom_vg[*]}
do
  echo "$machine_host;VG;$nom;${taille_vg[$i]};${total_vg[$i]};${nbDisk_vg[$i]};;;;;"  >> analyse.csv
  ((i=i+1))
done

###############
# PV :
###############
export i=0
for disque in ${nom_pv[*]}
#for disque in $liste_PV_libres
do
  echo "$machine_host;PV;${nom_pv[$i]};${logical_id[$i]};${id_pv[$i]};${vg_attachpv[$i]};${taille_pv[$i]};${ok_tf[$i]};;;" >> analyse.csv
  ((i=i+1))
done

###############
# LV :
###############
# Machine ; LV ; nom_LV ; nom_VG ; type_JFS ; opened_LV
export i=0
for disque in ${nom_lv[*]}
do
  echo "$machine_host;LV;${nom_lv[$i]};${vg_attache_lv[$i]};${type_lv[$i]};${mounted_lv[$i]};${max_lp[$i]};;;;;;" >> analyse.csv
  ((i=i+1))
done

###############
# FS :
###############
export i=0
for nom in ${nom_fs[*]}
do
  echo "$machine_host;FS;$nom;${tot_fs[$i]};${free_fs[$i]};${used_fs[$i]};;${nom_lv[$i]};${type_lv[$i]};${vg_attache_lv[$i]};${free_vg[$i]}"  >> analyse.csv
  ((i=i+1))
done

mv analyse.csv ${MEO_LOG}/A2fs3_machine.txt
chmod 775 ${MEO_LOG}/A2fs3_machine.txt

. /apps/cft/ENV_CFT 

/apps/cft/filexe/CFTUTIL send part=${RMEO_PART},idf=${RMEO_IDF},fname=${MEO_LOG}/A2fs3_machine.txt,parm=${RMEO_PARM_SITE}#A2fs3_machine.txt

exit 0;

