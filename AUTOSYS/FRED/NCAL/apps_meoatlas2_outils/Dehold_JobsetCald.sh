#!/bin/ksh

######################################################################
#Fichier     : Dehold_JobsetCald.sh                                  #
#                                                                    #
# Objet       : Dehold le jobset jfu50Cald si il est holder          #
#                                                                    #
#                                                                    #
# Création    : HAMMADI Choukri       14/03/2015 - version : 1.00    #
######################################################################



#-----------#
#VARIABLES  #
#-----------#

. /usr/bin/EnvironnementTNG

dateT=`date +%d-%m-%Y_%H:%M:%S`
repLog=/apps/meoatlas2/outils/tmp/LOG
LOG_TRAIT=${repLog}/Dehold_JobsetCal_${dateT}
LOG_JOB=${repLog}/List_jobs_${dateT}.log

#----------------------------------------------------------------------
# FONCTION    : RESULT ( )
#----------------------------------------------------------------------
# DESCRIPTION : TEST LE CODE RETOUR ET RENVOI LE MESSAGE D'ERREUR
#----------------------------------------------------------------------
RESULT ()
{
RET=$1
        if [ ${RET} -ne 0 ];
        then
                #print "\t\t\tFATAL   :  $2"
                echo "Usage: `basename $0`  FATAL   :  $2"    | tee -a  ${LOG_TRAIT}
                exit ${RET}
        fi
}
#----------------------------------------------------#
# FC ACTION : Si le jobset est en HOLD il le dehold  #
#----------------------------------------------------#

ACTION ()
{
            DEHOLD=`cautil sel tjobset id=jfu50Cald li | grep "Status:"  |  awk '{print $3}'` 
            if [ "${DEHOLD}" = "OPHELD" ];
	    then 
	             cautil rel tjobset id=jfu50Cald    	                   	
	    else
		     echo "Le jobset jfu50Cald n'est pas en HOLD"                  
       	    fi
                     sleep 5 
	 
}


##############
# Envoi mail #
##############

ENVOI ()
{
	
cautil sel tjobset id=jfu50Cald li > ${LOG_JOB}

           EMETTEUR=Production_Webdoc
           echo "Subject: DEHOLD DU JOBSET jfu50Cald serveur $(hostname)" | tee -a  ${LOG_TRAIT}
           echo "Bonjour," | tee -a  ${LOG_TRAIT}
           echo "\n" | tee -a  ${LOG_TRAIT}
           echo "Date d execution  : $(date +%Y%m%d)" | tee -a  ${LOG_TRAIT}
           echo "\n" | tee -a  ${LOG_TRAIT}
           echo "\n\n" | tee -a  ${LOG_TRAIT}
           cat ${LOG_JOB} | tee -a   ${LOG_TRAIT}
	   echo "Cordialement,"| tee -a  ${LOG_TRAIT}
           echo "." | tee -a  ${LOG_TRAIT}
           sendmail -f meo_atlas_paris -v -t choukri.hammadi@externe.bnpparibas.com fathi.beddiar@bnpparibas.com < ${LOG_TRAIT} >>$A2_LOG 2>&1
		   
}
		   
##############
# PURGE   ####
##############

PURGE ()
{
find ${repLog} -type f -mtime +2 -exec /bin/rm -f {} \;
}

############################
# FONCTION                 #
############################

ACTION

ENVOI

PURGE
