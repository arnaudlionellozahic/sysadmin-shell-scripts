# export JAVA_HOME=/opt/solis/jdk1.8.0_91
# export CATALINA_HOME=/opt/solis/apache-tomcat-8.0.36
export JAVA_HOME=/opt/solis/programmes/jdk8u345-b01
export CATALINA_HOME=/opt/solis/programmes/apache-tomcat-9.0.56
export CATALINA_BASE=/opt/solis/prod/web
export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m  -XX:MaxPermSize=512m -Dfile.encoding=iso-8859-1"
$CATALINA_HOME/bin/startup.sh -config $CATALINA_BASE/conf/server.xml

