#!/bin/bash
# arglist.sh
# Appelez ce script avec plusieurs arguments, tels que "un deux trois".

E_MAUVAISARGS=65

if [ ! -n "$1" ]
then
  echo "Usage: `basename $0` argument1 argument2 etc."
  exit $E_MAUVAISARGS
fi

echo

index=1 # Initialise le compteur.

echo "Liste des arguments avec \"\$*\" :"
for arg in "$*" # Ne fonctionne pas correctement si "$*" n'est pas entre guillemets.
do
  echo "Arg #$index = $arg"
  let "index+=1"
done # $* voit tous les arguments comme un mot entier.
echo "Liste entière des arguments vue comme un seul mot."

echo

index=1 # Ré-initialisation du compteur.
        # Qu'arrive-t'il si vous oubliez de le faire ?

echo "Liste des arguments avec \"\$@\" :"
for arg in "$@"
do
  echo "Arg #$index = $arg"
  let "index+=1"
done # $@ voit les arguments comme des mots séparés.
echo "Liste des arguments vue comme des mots séparés."

echo

index=1 # Ré-initialisation du compteur.

echo "Liste des arguments avec \$* (sans guillemets) :"
for arg in $*
do
  echo "Argument #$index = $arg"
  let "index+=1"
done # $* sans guillemets voit les arguments comme des mots séparés.
echo "Liste des arguments vue comme des mots séparés."

echo

index=1 # Ré-initialisation du compteur.

echo "Liste des arguments avec \$@ (sans guillemets) :"
for arg in $@
do
  echo "Argument #$index = $arg"
  let "index+=1"
done # $* sans guillemets voit les arguments comme des mots séparés.
echo "Liste des arguments vue comme des mots séparés."


exit 0
