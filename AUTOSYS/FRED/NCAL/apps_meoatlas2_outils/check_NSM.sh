#!/bin/sh
##
# nom du script :       check_NSM.sh
#
# principe      :       execute le script /apps/sys/unicenter/exploitation/checkCashdb.sh
#               :       en crontab une fois par semaine
#               :       envoi un mail a paris ips meo irb en cas d'alerte
#               :       avec la log $CAISCHD0200/audit/cashdb_audit_parvaxxxxxxx.out
#
# date          :       25-02-2014
#
# auteur        :       PETITPRE - PARIS IPS MEO IRB
#
#
#-----------------------------------------------------------------------------------------------


export A2_TMP=/apps/meoatlas2/outils/tmp
export HOST=$(hostname)
export alias=$( host $(hostname) | awk '{ FS=":" ; print $2}' | tr "," " " | tr " " "\n"  | egrep "at....-prd|at....-int" )
export site=$( echo $alias | cut -c 3-6 )
export SITE=$( echo $site | tr 'a-z' 'A-Z')

# execution du script BP2I

/apps/sys/unicenter/exploitation/checkCashdb.sh > $A2_TMP/checkCashdb.output

if [[ $? -ne 0 ]]
then

export RAPPORT=$( ls $CAISCHD0200/audit/cashdb_audit_${HOST}.out)

# envoi d'un mail vers la meo irb si erreur

        echo "Subject: Problème NSM ${HOST} KO" > $A2_TMP/nsm_status_mail
        echo "To: meo_atlas_paris" >> $A2_TMP/nsm_status_mail

        echo "Bonjour,"  >> $A2_TMP/nsm_status_mail
        echo >> $A2_TMP/nsm_status_mail
        echo >> $A2_TMP/nsm_status_mail


        echo "Veuillez faire appliquer par BP2I les recommandations ci-dessous\n" >> $A2_TMP/nsm_status_mail
        echo "Si un cashcvr est demande, il faut simplement lancer une reindexation des index\n" >> $A2_TMP/nsm_status_mail
        echo "La reorg des index est a notre charge : voir la procedure de reorg TNG\n" >> $A2_TMP/nsm_status_mail

        echo "----------------------------------------------------------\n" >> $A2_TMP/nsm_status_mail
        echo "Machine : $alias ( $(hostname) )\n"  >> $A2_TMP/nsm_status_mail
        cat ${RAPPORT} >> $A2_TMP/nsm_status_mail
        echo "\n----------------------------------------------------------\n" >> $A2_TMP/nsm_status_mail
        echo >> $A2_TMP/nsm_status_mail
        echo >> $A2_TMP/nsm_status_mail
        echo Cordialement >> $A2_TMP/nsm_status_mail
        echo "Mise En Oeuvre ATLAS2" >> $A2_TMP/nsm_status_mail

       sendmail -f meo_atlas_paris -t <  $A2_TMP/nsm_status_mail


fi


