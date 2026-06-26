#!/bin/sh
cd /opt/solis/scripts
echo "Demarrage application Progress"
su - infodb --command "/opt/solis/scripts/startup-app-PROD.sh"
sleep 10
echo "Demarrage application web"
su - infodb --command "/opt/solis/scripts/startup-tomcat-PROD.sh"
