#!/bin/ksh

node ()
{
for V in `cat ${FIC}`
do
echo "replicate node $V maxsessions=20 wait=yes" >> $CIBLE
done
}


#Main
REP=/home/alozahic/SCRIPTS_SHELL/TSM/REPRISES
FIC=${REP}/list_nodes_Bessieres
CIBLE=${REP}/script_repli_nodes_Bessieres

echo "serial" > $CIBLE
node
