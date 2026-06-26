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

#USING FUNCTION

ls -l $PASSWORD_FILE #> /dev/null 2>&1 

##################
function if_error
##################
{
if [[ $? -ne 0 ]]; then # check return code passed to function
	print "$1"  # if rc > 0 then print errot msg and quit
exit $?
fi
}

rm -f /tmp/file  #Delete file
if_error "Error: Failed removing file /tmp/file"

rmdir /tmp/test   #Create the directory test
if_error "Error: Failed removing directory /tmp/test"

mkdir /tmp/test   #Create the directory test
if_error "Error: Failed trying to create directory /tmp/test"
