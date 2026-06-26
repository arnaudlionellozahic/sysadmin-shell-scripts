export JAVA_HOME=/data/programmes/java_solis
export CATALINA_HOME=/data/programmes/tomcat_solis
export CATALINA_BASE=/data/solis/web
# export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m -XX:MaxPermSize=512m -Dfile.encoding=UTF-8"
export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx4096m -Xss1024k -Dfile.encoding=iso-8859-1 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9024 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
#export JAVA_OPTS="$JAVA_OPTS -Xms2048m -Xmx2048m -Xss1024k -Dfile.encoding=iso-8859-1 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9024 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
$CATALINA_HOME/bin/startup.sh -config $CATALINA_BASE/conf/server.xml
