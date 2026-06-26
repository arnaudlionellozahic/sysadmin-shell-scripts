#$vi my_first_script.ksh
#!/bin/ksh
###################################################
# Written By: Jason Thomas
# Purpose: This script was written to show users how to develop their first script
# May 1, 2008
###################################################

#Define Variables
#HOME="/home/jthomas" #Simple home directory
DATE=$(date) # Set DATE equal to the output of running the shell command date
HOSTNAME=$(hostname) # Set HOSTNAME equal to the output of the hostname command
PASSWORD_FILE="/etc/passd" # Set AIX password file path

#Begin Code

echo $DATE
echo $HOSTNAME
echo $PASSWORD_FILE
echo --------------
echo --------------
echo --------------

#CHECKING ERROR

if [[ -e $PASSWORD_FILE ]]; then #Check to see if the file exists and if so then continue

	for username in $(cat $PASSWORD_FILE | cut -f1 -d:)
	do

	print $username | tee -a /home4/alozahic/exploit/systeme/suivi/TRAINING/20120626/usernames

	done
else

	print "$PASSWORD_FILE was not found"
	exit
fi
