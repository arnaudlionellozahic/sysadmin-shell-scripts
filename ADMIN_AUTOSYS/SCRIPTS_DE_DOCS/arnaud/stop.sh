[user2@rh602 /]$ cat stop.sh
### Autosys
. /etc/profile.CA

unishutdown CA-WAAE

### EEM
/etc/rc.d/init.d/igatewayd stop


### Oracle
su - oracle -c "dbshut"
su - oracle -c "lsnrctl stop"
