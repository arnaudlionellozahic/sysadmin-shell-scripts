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
TIME=$(date +%H%M) # Set DATE equal to the output of running the shell command date

#Begin Code

echo $DATE
echo $HOSTNAME
echo $PASSWORD_FILE
echo $TIME
echo --------------
echo --------------
echo --------------

#USING CASE 

##################
function if_error
##################
{
if [[ $? -ne 0 ]]; then # check return code passed to function
    print "$1" # if rc > 0 then print error msg and quit
exit $?
fi
}

if [[ -e /tmp/file ]]; then  #Check to see if the file exists first
   rm -f /tmp/file #Delete file
   if_error "Error: Failed removing file /tmp/file"
else
   print "/tmp/file doesn.t exist"
fi

if [[ -d /tmp/test ]]; then
     mkdir /tmp/test #Create the directory test
     if_error "Error: Failed trying to create directory /tmp/test"
else
     print "Directory exists, no need to create directory"
fi

case $TIME in
                 "1258")
                 rm -f /tmp/file1
                        ;;
                 "2300")
                 rm -f /tmp/file1
                        ;;
#End Script
esac
