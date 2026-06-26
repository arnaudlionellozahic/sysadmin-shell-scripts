#!/bin/bash
# Script de déploiement de l'application archeschool

echo "Déploiement de archeschool" > /tmp/script1.log

# récupération de l'archive
sftp -4 -o ConnectTimeout=3 -q -P 1122 archeschool@sftp1.apovir.net:/version1.tar.gz /tmp/ >> /tmp/script1.log

# déploiement de l'application
mkdir -p ~/www/ > /dev/null
cd ~/www/ > /dev/null
tar -xvzf /tmp/version1.tar.gz >> /tmp/script1.log
cd - > /dev/null

# redémarrage du service
systemctl status apache2 >> /tmp/script1.log

# log & fin
echo "Déploiement terminé" >> /tmp/script1.log
cat /tmp/script1.log | mail -s "déploiement d'archeschool OK" -- ludovic.lefloch@arche-mc2.fr

exit 0
