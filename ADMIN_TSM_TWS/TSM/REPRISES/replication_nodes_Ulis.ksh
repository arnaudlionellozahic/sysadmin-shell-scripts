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
FIC=${REP}/list_nodes_Ulis
CIBLE=${REP}/script_repli_nodes_Ulis

echo "serial" > $CIBLE
node
