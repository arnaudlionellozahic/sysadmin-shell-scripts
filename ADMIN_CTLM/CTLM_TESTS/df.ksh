#!/bin/ksh
#------------------------------------------------
# Ce script fait un df toujours de la meme facon
#  - Affichage sur une seule ligne
#  - Trie sur le %full
#------------------------------------------------

#Par defaut si on ne passe rien on fait un df -m
arg_allargs="${*:--m}"

df ${arg_allargs} | awk '
                         {
                          if (NF>=6)
                                printf("%-20.20s %11s %11s %11s %4s %s\n",$1,$2,$3,$4,$5,$6)
                          else
                          if (NF==1)
                                printf("%-17.17s... ",$1)
                          else
                                printf("%11s %11s %11s %4s %s\n",$1,$2,$3,$4,$5)

                         }' | sort -n -k 5

