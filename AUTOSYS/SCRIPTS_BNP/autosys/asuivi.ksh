#!/bin/ksh
#set -x
exec 2>/dev/null
#Fonctions a inclure
clear
(. /apps/meoatlas2/autosys/asuivi/fonction_autosys.ksh

failure
failureclasse |sort -k 3

terminated
terminatedclasse |sort -k 3

encours
encoursclasse |sort -k 3

rmfic
echo "\n"
)

