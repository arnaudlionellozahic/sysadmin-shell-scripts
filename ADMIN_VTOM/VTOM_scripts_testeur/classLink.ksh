#!/bin/ksh
# ~~~~                  FICHE SIGNALETIQUE SHELL
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PROJET           : ESSOR
# ~~~~ NOM DU PROGRAMME : class_Link.ksh
# ~~~~ DESIGNATION      : Attachement d'une machine a une classe dans
# ~~~~                    l'environnement d'exploitation
# ~~~~
# ~~~~ HISTORIQUE
# ~~~~ Version---Date----------Auteur--------------Commentaires-----------------
# ~~~~   1.0    09/08/2004    FM Lefort      	Creation
# ----   1.1    12/10/2005    S. HARE		Correction taddmach (ajout nom physique)	
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PERIODICITE : D          QUOTIDIEN (Q)   - HEBDOMADAIRE (H)
# ~~~~                          MENSUEL (M)     - ANNUEL (A)
# ~~~~                          SEMESTRIEL (S)  - DEMANDE (D)
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ BUT DU PROGRAMME :
# ~~~~     Reproduire le mecanisme d'attachement d'une CPU a une classe de
# ~~~~     Maestro sur VTOM.
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ FICHIERS DE PARAMETRES APPELES : aucun
# ~~~~ _________________________________________________________________________
# ~~~~
# ~~~~ PARAMETRES D'ENTREE : (nom du parametre - format - libelle)
# ~~~~ <class>  char    le nom de la classe
# ~~~~ <CPU>    char    le nom de la machine a ajouter dans la classe
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

# Variables essentielles
#gras=`tput bold`
#annu=`tput sgr0`

# Nom des fichiers issus du shell
SHLLNAME=$(basename $0 .ksh)

# Version du shell
VERSION="${SHLLNAME}.ksh Version 1.1"
echo $VERSION
# Usage du shell
USAGE="AIDE DE ${SHLLNAME}.ksh :\n
Copie l application correspondant a une classe pour l associer a une nouvelle machine.\n
${SHLLNAME}.ksh <class> <CPU> ..."

echo $*

[[ $(tlist env 2>/dev/null|wc -l) -eq 0 ]] && { echo "Le serveur de donnees doit etre actif." >&2; exit 3; }
# Parse de la ligne de commande
[[ $# -gt 1 ]] || { echo $USAGE >&2; exit 2; }

EXPL_ENV=$(tlist env | grep EXPLOIT |  sed 's/ //g')
CLASS=$1
echo "CLASS : $CLASS"
echo "-----------------------"
R_CLASS=$(tlist -f ${EXPL_ENV} app | grep "^${EXPL_ENV}[ 	]*C[0-9]*_${CLASS}" | awk '{print $2;}')
[[ "$R_CLASS" = "" ]] && { echo $USAGE >&2; exit 2; }
N_CLASS=$(echo $R_CLASS | sed -e 's/^\(C[0-9]*\)_.*$/\1/')
shift

for CPU in $*; do
  echo "Ajout du membre $CPU dans la classe $CLASS :"
  echo "- Ajout du membre ($CPU) dans le referentiel et attachement a l'environnement $EXPL_ENV"
  taddmach /machine=$CPU /nom_reel=$CPU /att_env=${EXPL_ENV}
  [[ $? -eq 0 ]] || { echo "Creation de la machine dans le referentiel impossible" >&2; exit 3; }
  typeset -i NBM=$(tlist -f ${EXPL_ENV} app | grep "^${EXPL_ENV}[ 	]*${N_CLASS}-" | wc -l)
  echo "- Attachement a la classe (creation de ${N_CLASS}-${CPU} d'apres ${EXPL_ENV}/${R_CLASS})"
  taddapp /nom=${EXPL_ENV}/${N_CLASS}-${CPU} /de=${EXPL_ENV}/${R_CLASS}
  [[ $? -eq 0 ]] || { echo "Copie de la classe impossible" >&2; exit 3; }
  echo "- Pointage vers le membre (${N_CLASS}-${CPU} pointe sur $CPU"
  taddapp /nom=${EXPL_ENV}/${N_CLASS}-${CPU} /machine=$CPU
  [[ $? -eq 0 ]] || { echo "Activation du membre impossible" >&2; exit 3; }
  set $(texport ${EXPL_ENV}/${R_CLASS}|grep "^geometrie="|head -1|sed -e 's/.*=\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/\1 \2 \3 \4/')
  GEOM="${1}x${2}+$(( $3 + 50 * ( $NBM + 1 ) ))+${4}"
  echo "- Placement ($GEOM) du nouveau membre ($CPU) dans le graphe"
  taddapp /nom=${EXPL_ENV}/${N_CLASS}-${CPU} /geom=$GEOM /cbord=Blue /cfond=Blue
  [[ $? -eq 0 ]] || { echo "Placement du membre dans le graphe impossible" >&2; exit 4; }
  echo "- Activation du membre (${N_CLASS}-${CPU} en mode job)"
  taddapp /nom=${EXPL_ENV}/${N_CLASS}-${CPU} /mode=job
  [[ $? -eq 0 ]] || { echo "Activation du membre impossible" >&2; exit 4; }
  nb=$(tresetApp -e ${EXPL_ENV} -a ${N_CLASS}-${CPU}|wc -l)
  [[ $nb -eq 0 ]] || { echo "Echec lors du lancement" >&2; exit 4; }
done
