#!/bin/sh
cd /opt/solis/scripts/
echo "Arret application web"
su - infodb --command "/opt/solis/scripts/shutdown_tomcat-PROD.sh"
echo "Arret appserver"
su - infodb --command "/opt/solis/scripts/shutdown-app-PROD.sh"
