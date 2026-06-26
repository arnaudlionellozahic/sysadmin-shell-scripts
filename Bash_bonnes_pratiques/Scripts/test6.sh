#!/bin/bash

if $( touch /tmp/file.log ); then
  echo 'fichier créé'
fi

if [ -f /tmp/file.log ]; then
  echo "le fichier /tmp/file.log existe"
else
  echo "le fichier /tmp/file.log n'existe"
fi

[ ! -f /tmp/file2.log ] && echo "le fichier /tmp/file2.log n'existe pas" || echo "le fichier /tmp/file2.log existe"

number=6
if [[ $number -gt 9 ]]; then
  echo "$number est plus grand que 9"
else
  echo "$number est plus petit que 9"
fi

if $( mkdir -p /tmp/mondossier ); then
  echo "on a pu créer le dossier"
else
  echo "on n'a pas pu créer le dossier"
fi

number="test"
if [ "$number" == "9" ]; then
  echo "$number est plus grand que 9"
else
  echo "$number est plus petit que 9"
fi
