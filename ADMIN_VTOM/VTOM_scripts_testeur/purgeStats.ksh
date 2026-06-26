#!/bin/ksh
# ~~~~			FICHE SIGNALETIQUE SHELL
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PROJET		: ESSOR
# ~~~~ NOM DU PROGRAMME	: purgeStats.ksh
# ~~~~ DESIGNATION	: Purge du repertoire des statistiques
# ~~~~
# ~~~~ HISTORIQUE
# ~~~~ Version---Date----------Auteur--------------Commentaires-----------------
# ~~~~   1.0    20/04/2005    FM Lefort      Creation
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PERIODICITE : H		QUOTIDIEN (Q)	- HEBDOMADAIRE (H)
# ~~~~				MENSUEL (M)	- ANNUEL (A)
# ~~~~				SEMESTRIEL (S)	- DEMANDE (D)
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ BUT DU PROGRAMME :
# ~~~~     Purge de l'historique des statistiques
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ FICHIERS DE PARAMETRES APPELES : aucun
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PARAMETRES D'ENTREE : (nom du parametre - format - libelle)
# ~~~~ date		char	date jusqu'a laquelle les stats seront purgees
# ~~~~ _________________________________________________________________________
# ~~~~
# Reset des modes debug
unset DBSETDEBUGMODE
unset DBTOGGLEDEBUGMODE
unset DEBUG_MODE
unset DEBUGMODE
unset DOUG_DEBUG
unset DOUG_DEBUG_MODE
unset GLOBAL_DEBUG
unset TOM_DEBUG

LIMH=$1;
case $LIMH in
  [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9])
    set $(echo $LIMH | sed -e "s/^\(..\)-\(..\)-\(....\)$/\3 \2 \1/")
    JJ=$3; MM=$2; AA=$1
    [[ $MM -lt 1 || $MM -gt 12 ]] && { echo "Erreur : argument invalide ($LIMH)" >&2; exit 2; }
    case $MM in
    01|03|05|07|08|10|12)
      JMX=31;;
    04|06|09|11)
      JMX=30;;
    02)
      JMX=28
      [[ $(($AA%4)) -eq 0 ]] && JMX=29
      [[ $(($AA%100)) -eq 0 ]] && JMX=28
      [[ $(($AA%1000)) -eq 0 ]] && JMX=29
      ;;
    esac
    [[ $JJ -lt 1 || $JJ -gt $JMX ]] && { echo "Erreur : argument invalide ($LIMH) " >&2; exit 2; }
    LIMH_=$AA$MM$JJ;;
  *)
    echo "Erreur : argument invalide (mauvais typage : $LIMH)" >&2; exit 3;;
esac
LIMB_=$(vtstools -date | grep "..-..-...." | sed -e "s/^.*\(..\)-\(..\)-\(....\).*$/\3\2\1/" | sort | head -1)
[[ "$?" = "0" ]] || { echo "Erreur : impossible d'interroger la base"; exit 4; }
[[ -z "$LIMB_" ]] && { echo "Warning : pas d'histo."; exit 1; }
LIMB=$(echo $LIMB_ | sed -e "s/^\(....\)\(..\)\(..\)$/\3-\2-\1/")

[[ $LIMB_ < $LIMH_ ]] || { echo "Warning : pas de stat anterieure a $LIMH."; exit 1; }

echo "Purge des stats de $LIMB a $LIMH :"
vtstools -purge $LIMB $LIMH
ST=$?
[[ $ST -gt 0 ]] && { echo "L'operation a echoue." >&2; exit $(($ST+1)); }
exit $ST
