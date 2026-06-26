#!/usr/bin/ksh
# Cet outil sert à purger les FS
# Prerequis :   /apps/meoatlas2/scripts,/apps/meoatlas2/log
# $2:
# Version    : 1.0
# 07/03/2013 : Creation A.MARIE-JEANNE
# mai 2013   : maj PETITPRE
#=================================================================
[[ $# -gt 1 ]] && echo "Usage : $0 " && exit
[[ $(id -un) != "root" ]] && echo "Seul un user <root> a le droit d'executer le script." && exit

export MEO_WORK=/apps/meoatlas2/outils
export MEO_LOG=/apps/meoatlas2/log/${0}.log_$(date +"%Y%m%d%H%M")



MEO_DATE=$(date +"%d")

echo "
==============================
Purge de /apps/exploit/work   :
=============================="

find /apps/exploit/work  -type f -mtime +2 -exec rm -f {} \; | tee -a $MEO_LOG

echo "
===============================================
Purge de /apps/oradbf/backup/atpr01/compress   :
================================================"

find /apps/oradbf/backup/atpr01/compress/tips*  -type f -mtime +10 -exec rm -f {} \; | tee -a $MEO_LOG

echo"
==============================
Purge de data1/arch          :
=============================="

find /apps/atlas/atlas2v0/uf1/data1/arch  -type f -mtime +100 -exec rm -f {} \; | tee -a $MEO_LOG


echo"
==============================================================
Purge des sous-repertoires de fic swift swift1 MT100         :
=============================================================="

find /apps/atlas/atlas2v0/uf1/data1/fic/swift  -type f -mtime +100 -exec rm -f {} \; | tee -a $MEO_LOG
find /apps/atlas/atlas2v0/uf1/data1/fic/swift1  -type f -mtime +100 -exec rm -f {} \; | tee -a $MEO_LOG
find /apps/atlas/atlas2v0/uf1/data1/fic/MT100  -type f -mtime +100 -exec rm -f {} \; | tee -a $MEO_LOG

