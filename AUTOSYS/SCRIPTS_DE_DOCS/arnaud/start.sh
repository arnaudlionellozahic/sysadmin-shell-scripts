[user2@rh602 /]$ cat start.sh
#### ORACLE
su - oracle -c "dbstart"
su - oracle -c "lsnrctl start"


###  Autosys
unistart CA-WAAE
