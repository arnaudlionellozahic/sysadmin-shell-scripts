#!/bin/sh
HOST='parva4000634'
USER='username'
PASSWD='password'
FILES='*.txt'
#
ftp -nv $HOST>$FTPLOG <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
cd somedirectory
binary
mget $FILES
quit
END_SCRIPT