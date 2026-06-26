#!/bin/bash

#+ Si $IFS est initialisé mais vide,
#+ alors "$*" et "$@" n'affichent pas les paramètres de position
#+ comme on pourrait s'y attendre.

mecho () # Affiche les paramètres de position.
{
echo "$1,$2,$3";
}

IFS="" # Initialisé, mais vide.
set a b c # Paramètres de position.

mecho "$*" # abc,,
mecho $* # a,b,c

mecho $@ # a,b,c
mecho "$@" # a,b,c

# Le comportement de $* et $@ quand $IFS est vide dépend de la version de
#+ Bash ou sh.
# Personne ne peux donc conseiller d'utiliser cette «fonctionnalité» dans un
#+ script.

# Merci, Stephane Chazelas.

exit 0
