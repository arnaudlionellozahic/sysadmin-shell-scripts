# export JAVA_HOME=/opt/solis/jdk1.8.0_91
# export CATALINA_HOME=/opt/solis/apache-tomcat-8.0.36
export JAVA_HOME=/opt/solis/programmes/jdk8u345-b01
export CATALINA_HOME=/opt/solis/programmes/apache-tomcat-9.0.56
export CATALINA_BASE=/opt/solis/prod/web
$CATALINA_HOME/bin/shutdown.sh -config $CATALINA_BASE/conf/server.xml
sudo /usr/sbin/logrotate /etc/logrotate.conf
dateexec=`date +"%Y%m%d"`
gzip -c $CATALINA_BASE/logs/catalina.out >$CATALINA_BASE/logs/catalina.out_${dateexec}.gz
find $CATALINA_BASE/logs/ -mtime +15 -type f -exec rm -f {} \;
find $CATALINA_BASE/temp/ -mtime +15 -type f -exec rm -f {} \;
find $CATALINA_BASE/webapps/Solis1/log/ -mtime +15 -type f -exec rm -f {} \;
rm -Rf $CATALINA_BASE/work

