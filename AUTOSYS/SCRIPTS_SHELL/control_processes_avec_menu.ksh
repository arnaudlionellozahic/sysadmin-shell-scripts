#!/bin/ksh -x


menu ()
{
rep=""
echo "\033[35m              AUTOSYS CONTROL PROCESSES \033[00m"
echo "\033[36m 0 HELP \033[00m"
echo "\033[35m 1 SERVER_CONTROL_PROCESSES \033[00m"
echo "\033[35m 2 AGENT_CONTROL_PROCESSES \033[00m"
echo "\033[35m 3 VERSION_AUTOSYS \033[00m"
echo "\033[35m 4 DATABASE_STATUS \033[00m"
echo "\033[35m 5 MACHINES_STATUS \033[00m"
echo "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


#############################################################################


entete ()
{
echo ""
echo "CONTROL OF THE AUTOSYS PRIMARY PROCESSES"
echo ""
echo "################################################################"
# echo "-------------------------------------------------------------------"
echo ""
}

server_control_processes ()
{
entete | tee ${FILE_LOG}
echo "PROCESS_SERVER"
#ps -fu auto113 | grep "event_demon|as_server" | grep -v egrep | awk '{print $9}' | sort -n
toto=`ps -fu auto113 | grep "as_server" | grep -v grep | awk '{print $8}' | sort -n`
titi=`ps -fu auto113 | grep "event_demon" | grep -v grep | awk '{print $8}' | sort -n`

if [ "$toto" = "as_server" ] && [ "$titi" = "event_demon" ]
then
echo "${DATE} : Les process autosys sont presents"
        else echo "${DATE}   Alerte : il manque au moins un process Autosys"
        fi

echo ""
echo "----------------------------------------------------------------"
echo ""
echo "ps -fu auto113"
echo "" 
ps -fu auto113 | grep -v grep | sort -u
echo ""
echo "----------------------------------------------------------------" 
echo "----------------------------------------------------------------"
echo ""

. /etc/profile.CA
echo "unifstat | sort -n"
unifstat | sort -n
echo ""
echo "----------------------------------------------------------------" 
echo "----------------------------------------------------------------"

#/opt/CA/SharedComponents/bin/ustat | sort -n
echo ""
echo "CONTROL OF THE PROCESSES LAUNCHED IN /etc/init.d"
# We verify that all the master processes are presents
echo ""
echo "CA-Message Queuing Service"
toto=`/etc/rc.d/CA-CCS status | awk '{print $5}' | sed '/^$/d'`
if [ "$toto" = "running" ]
then
echo "${DATE} : The process CA-Message Queuing Service is running"
        else echo "${DATE}   Alerte : The process CA-Message Queuing Service isn't running"
        fi

echo ""
echo "Systems Performance LiteAgent"
toto=`ps -ef | grep casplitegent | grep -v grep | awk '{print $8}' | awk -F"/" '{print $7}'`
if [ "$toto" = "casplitegent" ]
then
echo "${DATE} : The process Systems Performance LiteAgent is running"
        else echo "${DATE}   Alerte : The process Systems Performance LiteAgent isn't running"
        fi		

echo ""
echo "WAAE Agent"
toto=`/etc/rc.d/CA-WAAE status | grep "WAAE Agent" | awk '{print $5}'`
if [ "$toto" = "running" ]
then
echo "${DATE} : The process WAAE Agent is running"
        else echo "${DATE}   Alerte : The process WAAE Agent isn't running"
        fi		
		
echo ""
echo "WAAE Application Server"
toto=`/etc/rc.d/CA-WAAE status | grep "WAAE Application" | awk '{print $6}'`
if [ "$toto" = "running" ]
then
echo "${DATE} : The process WAAE Application Server is running"
        else echo "${DATE}   Alerte : The process WAAE Application Server isn't running"
        fi	
		
echo ""
echo "WAAE Scheduler"
toto=`/etc/rc.d/CA-WAAE status | grep "WAAE Scheduler" | awk '{print $5}'`
if [ "$toto" = "running" ]
then
echo "${DATE} : The process WAAE Scheduler is running"
        else echo "${DATE}   Alerte : The process WAAE Scheduler isn't running"
        fi	
		
echo ""
echo "----------------------------------------------------------------" 
echo "----------------------------------------------------------------"
echo ""
echo "unicntrl status"
unicntrl status
echo ""
echo "----------------------------------------------------------------" 
echo "----------------------------------------------------------------"
}


agent_control_processes ()
{
ps -ef | grep cybAgent | grep -v grep | grep -v cybspawn
toto=`ps -ef | grep cybAgent | grep -v grep | grep -v cybspawn | awk '{print $9}' | sort -n`

if [ "$toto" = "./cybAgent.bin" ]
then
echo "${DATE} : Le process agent autosys cybAgent.bin est present"
        else echo "${DATE}   Alerte : Le process agent autosys cybAgent.bin est absent"
        fi

#Voir les jobs en cours
#ps -ef | grep -i cybAgent

#ENVIRONNEMENT (voir nom de l'instance)
#echo $AUTOSERV

#VARIABLE 
#cd $AUTOSYS/bin
#cd $AUTOUSER/out
#cd $CASHCOMP/bin/

#DIVERS
#/apps/waae/11.3/autouser.R30/out/ tail -f event_demon.R30

#JIL DE TEST AUTOSYS
#cd /apps/waae/11.3/autosys/test/jil

}


version_autosys ()
{
. /etc/profile.CA
#ca_version

toto=`ca_version | grep -p ca-waae-server | grep VERSION | awk -F": " '{print $2}'`
echo "La version de ca-waae-server est : ${toto}"

}


check_data_base ()
{
chk_auto_up

# chk_auto_up : Check la base, le scheduler
# code retour : 11 => 1 scheduler, 1 base

if [ $? == 11 ]
then
echo "1 base - 1 scheduler"
else
echo "toto"
fi

# Recuperate the name of the database and control of the status
echo ""
titi=`chk_auto_up | grep "Connect with Database" | awk -F": " '{print $2}'`
tata=`ps -ef | grep ${titi} |grep pmon | awk '{print $9}'`
if [ "$tata" == ora_pmon_${titi} ]
then
echo "${DATE} : La base ${titi} est up"
        else echo "${DATE}   Alerte : La base ${titi} est down"
        fi

## control of the database's status via autosys
#toto=`chk_auto_up | grep "Have Connected successfully with Database" | awk -F": " '{print $2}' | awk -F"." '{print $1}'`
#if [ "$toto" == "${titi}" ]
#then
#echo "${DATE} : La base ${titi} est up"
#        else echo "${DATE}   Alerte : La base ${titi} est down"
#        fi		

}


check_machines ()
{

#Verify that both client and server are correctly configured
autoping -m ALL -A

}

#############################################################################


choix ()
{
case $rep in
0) info ;;
1) server_control_processes | tee ${FILE_LOG} ;;
2) agent_control_processes | tee ${AG_LOG} ;;
3) version_autosys | tee ${VER_LOG} ;;
4) check_data_base | tee ${DB_LOG} ;;
5) check_machines | tee ${MA_LOG} ;;
q) echo "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}



#Main
#############################################################
# Initialisation des variables n'ayant pas a etre modifiees #
#############################################################

#DATE=`date +"%y%m%d_%H%M%S"`
DATE=$(date "+%Y%m%d a %H%M%S")
REP=/ficsav/EQUIPE_MEO/arnaud/guinee
#FIC=${REP}/auto113_processes.txt
FILE_LOG=${REP}/auto113_processes.log
AG_LOG=${REP}/agent_processes.log
VER_LOG=${REP}/version_ca.log
DB_LOG=${REP}/database.log
MA_LOG=${REP}/machines.log

#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------
echo "----------------------------------------------------------------------------------------------------------"
echo "----------------------------------------------------------------------------------------------------------"
echo ""
echo "#### DEBUT JOB $(date "+%Y%m%d-%H%M%S") ####"
echo ""

clear
menu

# email -s "[PROD][AUTOSYS] : Control of the autosys primary processes" xxx_mail_xxx < ${FILE_LOG}

echo ""
echo "#### FIN JOB $(date "+%Y%m%d-%H%M%S") ####"
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
echo "exit ${?}"
exit ${?}