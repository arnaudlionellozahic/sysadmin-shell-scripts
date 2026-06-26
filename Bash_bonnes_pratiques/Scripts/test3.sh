#!/bin/bash
myvar=5
while true; do
  echo $(date)
  sleep 1
  if [[ $myvar -eq 3 ]]; then
    echo "myvar = 3"
  else
    echo "myvar != 3"
    if ( ls /tmp5/ > /dev/null ); then
      echo "le dossier tmp existe"
    else
      echo "le dossier tmp n'existe pas" > /dev/stderr
    fi
  fi
done
