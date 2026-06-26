#!/bin/ksh -x 

menu ()
{
rep=""
echo -e "\033[35m              TWS REFERENTIEL'S EXTRACTION \033[00m"
echo -e "\033[36m 0 HELP \033[00m"
echo -e "\033[35m 1 VERSION_CPU \033[00m"
echo -e "\033[35m 2 LIST_CPU \033[00m"
echo -e "\033[35m 3 EXPORT_JOBS \033[00m"
echo -e "\033[35m 4 EXPORT SCHEDULES \033[00m"
echo -e "\033[35m 5 EXPORT_CALENDARS \033[00m"
echo -e "\033[35m 6 EXPORT EVENTRULES \033[00m"
echo -e "\033[35m 7 EXTRACTION VARTABLES \033[00m"
echo -e "\033[35m 8 EXTRACTION VARIABLES \033[00m"
echo -e "\033[35m 9 EXTRACTION RESSOURCES \033[00m"
echo -e "\033[36m q quitter \033[00m"
#echo -e "      commande: \c"
echo -e "\033[31m VEUILLEZ RENTRER VOTRE CHOIX \033[00m"
read rep
choix
}


#############################################################################
#############################################################################


version_cpu ()
{
. ${REP}/version_cpu.ksh
}


#############################################################################
#############################################################################


list_cpu ()
{
. ${REP}/list_cpu.ksh
}


#############################################################################
#############################################################################


export_jobs ()
{
. ${REP}/export_jobs.ksh
}


#############################################################################
#############################################################################


export_schedules ()
{
. ${REP}/export_schedules.ksh
}


#############################################################################
#############################################################################


export_calendars ()
{
. ${REP}/export_calendars.ksh
}


#############################################################################
#############################################################################


export_erules ()
{
. ${REP}/export_erules.ksh
}


#############################################################################
#############################################################################


export_vartables ()
{
. ${REP}/export_vartables.ksh
}


#############################################################################
#############################################################################


export_variables ()
{
. ${REP}/export_variables.ksh
}


#############################################################################
#############################################################################


export_resources ()
{
. ${REP}/export_resources.ksh
}


#############################################################################
#############################################################################


choix ()
{
case $rep in
0) info ;;
1) version_cpu ;;
2) list_cpu ;;
3) export_jobs ;;
4) export_schedules ;;
5) export_calendars ;;
6) export_erules ;;
7) export_vartables ;;
8) export_variables ;;
9) export_resources ;;
q) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
#*) echo -e "\033[32m  ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT \033[00m"; exit 0 ;;
esac
}


#Main
REP=/home/alozahic/SCRIPTS_SHELL/TWS/REFERENTIEL/SCRIPTS
clear
menu

