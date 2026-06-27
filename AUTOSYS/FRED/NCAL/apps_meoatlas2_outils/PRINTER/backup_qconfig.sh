#!/usr/bin/ksh
# Backup des fichiers qconfig
DATE=$(date +"%Y%m%d.%H%M%S")
cp -p /etc/qconfig /etc/qconfig_${DATE}
cp -p /etc/qconfig.bin /etc/qconfig.bin_${DATE}
ls -rtl /etc/qconfig /etc/qconfig_${DATE} /etc/qconfig.bin /etc/qconfig.bin_${DATE}
