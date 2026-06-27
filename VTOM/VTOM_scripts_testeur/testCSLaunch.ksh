#!/bin/ksh
# ~~~~			FICHE SIGNALETIQUE SHELL
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PROJET		: ESSOR
# ~~~~ NOM DU PROGRAMME	: testCSLaunch.ksh
# ~~~~ DESIGNATION	: Lancement d'un job test sur le client
# ~~~~
# ~~~~ HISTORIQUE
# ~~~~ Version---Date----------Auteur--------------Commentaires-----------------
# ~~~~   1.0    20/04/2005    F. M. LEFORT	      Creation
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~
# ~~~~ PERIODICITE : D		QUOTIDIEN (Q)	- HEBDOMADAIRE (H)
# ~~~~				MENSUEL (M)	- ANNUEL (A)
# ~~~~				SEMESTRIEL (S)	- DEMANDE (D)
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ BUT DU PROGRAMME :
# ~~~~     Lancement d'un job de test sur le client
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ FICHIERS DE PARAMETRES APPELES : 
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PARAMETRES D'ENTREE : (nom du parametre - format - libelle)
# ~~~~
# ~~~~ _________________________________________________________________________
# ~~~~
case $1 in
  *@*) ;;
    *) echo "Argument invalide : $1" >&2; exit 2;;
esac
set $(echo $1|sed -e 's/\(.*\)@\(.*\)/\1 \2/')
mac_name=$1; mac_addr=$2

echo "Lancement d'un job test sur le client"
if [[ $mac_name = C?N* ]]; then
  echo "Client Windows : ${mac_name}"
  #/procedure/wav/${WAV_REL}/classLink.ksh WTOMTEST $mac_name 
  /home2/plair/scripts/classLink.ksh WTOMTEST $mac_name 
  [[ "$?" = "0" ]] || { echo "Echec lors de la modification du job de test" >&2; exit 4; }
else
  echo "Client Unix : ${mac_name}"
  #/procedure/wav/${WAV_REL}/classLink.ksh UTOMTEST $mac_name 
  /home2/plair/scripts/classLink.ksh UTOMTEST $mac_name 
  [[ "$?" = "0" ]] || { echo "Echec lors de la modification du job de test" >&2; exit 4; }
fi

echo "Le test est en cours"
