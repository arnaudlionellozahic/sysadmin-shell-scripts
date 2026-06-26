#vi date_script.ksh
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

#USING $?

date #/dev/null 2>&1 # Any output from this command should never be seen

if [[ $? = 0 ]]; then
	print "The case command was successful"
else 
	print "The date command failed"
fi
