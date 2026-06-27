#!/bin/ksh
 
export HOMEBATCH=/home4/plair/scripts
 
echo "$1" > $HOMEBATCH/date_trt_batch
echo 'contenu de la date_trt_batch :'  $(cat $HOMEBATCH/date_trt_batch)
