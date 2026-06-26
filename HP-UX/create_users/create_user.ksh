#!/bin/ksh

export PATH=$PATH:.

#
# Christophe CONGIUSTI
# 13-01-2010
#

IFS=:

echo
echo [ CREATE absdev GROUP ]

#
# scan group
#
found=n
while read name filler gid
do
        if [ $name = "absdev" ] ; then
                found=$gid
        fi
done < /etc/group

#
# create group or not
#
if [ $found != "n" ]
then
        echo - group absdev already exist with gid $found
else
        echo - group absdev does not exist
        groupadd -g 1000 absdev
fi

echo
echo [ CREATE USERS ]

#
# create encode utilities
#
encode=0
encoder=encode.`hostname`
cc encode.c -o $encoder -lcrypt 2>&1 > /dev/null
if [ $? -eq 0 ]
then
        echo Encode utilities generated
        encode=1
else
        echo Can not make encode utilities
fi
#TODO encode utilities
encode=0

#
# create users
#
while read name passwd uid gid fname path shell
do
        found=`id "$name" 2> /dev/null`
        if [ $? -eq 0 ]
        then
                echo - user $name already exist $found
        else
                echo - user $name does not exist
                useradd -g "$gid" -u "$uid" -s "$shell" -d "$path" "$name"

                #set passwd (TODO)
                if [ $encode -eq 1 ]; then
                        echo set password for "$name"
                        passwd=`$encoder "$passwd"`
                        usermod -p "$passwd" "$name"
                fi
        fi
done < users.txt

echo
echo [ CREATE USERS PASSWORD ]