#!/bin/ksh
 
export HOMEBATCH=/home4/plair/scripts
 
echo "$1" > $HOMEBATCH/date_learn
echo 'contenu de la date_learn :'  $(cat $HOMEBATCH/date_learn)

