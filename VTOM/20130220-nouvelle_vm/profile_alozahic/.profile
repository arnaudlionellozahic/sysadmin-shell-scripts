#!/bin/ksh

alias ll='ls -ltr'                  
alias psme='ps -ef |grep alozahic|egrep -v "grep|ps -aef"'
alias trc='cd /home4/alozahic/traces'
alias la='ls -al'
alias killvtom=' kill `psme | cut -d " " -f4|grep -v grep| grep -v ^$`'
alias vi=vi
alias ls=ls
#set -o vi 
set -o emacs
alias __A=$(print -n "\020")
alias __B=$(print -n "\016")
alias __C=$(print -n "\006")
alias __D=$(print -n "\002")
alias ss='start_servers'
alias ssa='start_servers_arnaud'
alias es='stop_servers'
alias esa='stop_servers_arnaud'
alias sm='start_moteurs all'
alias em='stop_moteurs all'
alias sc='start_client'
alias ec='stop_client'
alias vt='vtping'
alias tl='tlist -v env'
alias psal='ps -fu alozahic'
alias psef='ps -ef | grep' 

stty erase "^H" 1>/dev/null 2>&1                   
stty erase "^?" 1>/dev/null 2>&1                   
stty intr "^C" 1>/dev/null 2>&1

export DISPLAY=192.90.84.186:0.0
export COLUMNS=132                           
HISTFILE=/tmp/.sh_history.$LOGNAME
export VTOM_KSH=/home/alozahic/exploit/systeme/suivi/ABSYSS_CENTOS/KSH/SURVEIL_PROD/VTOM
export SYSTEME_KSH=/home/alozahic/exploit/systeme/suivi/ABSYSS_CENTOS/KSH/SURVEIL_PROD/SYSTEME
export TRAINING=/home/alozahic/exploit/systeme/suivi/ABSYSS_CENTOS/TRAINING
export RANGE=/home/alozahic/exploit/systeme/suivi/RANGE
 
nom_machine=`hostname|awk -F"." '{print $1}'`
export PS1='${nom_machine}:$PWD > '                           

GR="bold"
SO="smul"
RT="sgr0"
ME="alozahic"
case `uname` in
	SunOS) repos="SunOS" ;;
	HP-UX|HP_UX) repos="HP-UX" ;;
	Linux) repos="Linux" ;;
	AIX)   repos="AIX" ; ;;
	havre) repos="NCR";;
	OSF1) repos="DEC_UX";;
	*) repos="NO" ; echo le fichier profile nest pas renseigne pour cet OS ; exit ;;
esac

machine=`uname -n | cut -d "." -f1`

echo
echo

client=`ps -ef|grep $ME|grep $repos|grep "bdaemon"`
v5=`ps -ef|grep $ME|grep $repos|grep "vtserver"`
v4=`ps -ef|grep $ME|grep $repos|grep "dserver"`

if [ ! "$client" = "" ] ; then
	v_client=`echo $client | awk -F"/" '{print $(NF-3)}'`
	VEC=`echo $v_client|awk '{print substr($0,4)}'`
	tput $GR ; tput $SO ; echo ATTENTION \!\! un client en version $VEC de Vtom fonctionne actuellt sur $repos ; tput $RT
	sleep 1
else

	if [ ! "$v5" = "" ] ; then
		v_v5=`echo $v5 | awk -F"/" '{print $(NF-3)}'`
		VEC=`echo $v_v5|awk '{print substr($0,4)}'`
	
	fi
	
	if [ ! "$v4" = "" ] ; then
		v_v4=`echo $v4 | awk -F"/" '{print $(NF-2)}'`
		VEC=`echo $v_v4|awk '{print substr($0,4)}'`	
	fi
	if [ ! "$VEC" = "" ] ; then
		tput $GR ; tput $SO ; echo "ATTENTION !! Une version ${VEC} de VTOM est demarree sur ${nom_machine}(${repos})" ; tput $RT
		sleep 1
	fi

fi

echo "LE SHELL EST : "$SHELL
ps

if [ ! "$VEC" = "" ] ; then
	. $HOME/$repos/$machine/Ver$VEC/admin/vtom_init.ksh 
else
	cd ${HOME}/$repos/$machine
	echo ; echo "choisir la version vtom a lancer dans la liste suivante :" ; echo 
	tput $GR ; ls|grep Ver|cut -b 4- ; tput $RT
	echo ; echo "choix ?" 
	tput $GR ; read VV ; tput $RT   
	VV=`echo Ver$VV` 
	while [ ! -d $VV ] 
	do
		echo choix inexistant reessayez 
		tput $GR ; ls|grep Ver|cut -b 4- ; tput $RT 
		echo "choix ?"  
		tput $GR ; read VV ; tput $RT 
		VV=`echo Ver$VV`     
	done
	. $HOME/$repos/$machine/$VV/admin/vtom_init.ksh
	ls -al $HOME/$repos/$machine/.vtom.ini|grep $TOM_ADMIN 2> /dev/null
	if [ $? -ne 0 ]
	then
		/bin/rm -f $HOME/.vtom.ini 2>/dev/null
		/bin/rm -f $HOME/$repos/$machine/.vtom.ini 2>/dev/null
		ln -s $TOM_HOME/admin/.vtom.ini $HOME/$repos/$machine/.vtom.ini 2> /dev/null
	fi
	if [ `ps -ef|grep $ME|grep $repos|egrep "visual|bdaemon|tengine"|grep -v $VV|grep -v grep|wc -l` -gt 0 ]
	then
		tput $GR ; tput $SO ; echo ATTENTION \!\! Les process suivants sont presents ; echo
		tput $RT ; ps -ef|grep $repos |egrep "visual|bdaemon|tengine"|grep -v $VV|grep -v grep|cut -b 48- ; echo ; sleep 1  
	fi
fi
PATH=${PATH}:/home4/alozahic/GNUzip/root/usr/local/bin
export PATH
HOME=${HOME}/$repos/$machine
export HOME
cd ${HOME}
echo

if [ $TOM_BACKUP_SERVER ] ; then
	echo BACKUP = $TOM_BACKUP_SERVER
else
	echo "Aucun BACKUP declare"
fi
if [ $TOM_PRIMARY_SERVER ] ; then 
	echo PRIMAIRE = $TOM_PRIMARY_SERVER
else
	echo "Aucun PRIMAIRE declare"
fi
