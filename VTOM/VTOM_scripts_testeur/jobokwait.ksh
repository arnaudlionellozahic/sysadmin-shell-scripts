#!/bin/ksh

if [ "$1" = "" ] ; then attente=1 ; else attente=$1 ; fi


echo "attente "$attente" secondes"
sleep $attente

