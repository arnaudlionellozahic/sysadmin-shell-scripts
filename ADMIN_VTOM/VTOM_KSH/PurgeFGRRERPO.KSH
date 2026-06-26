#!/bin/ksh
# ----------------------------------------------------------------------------
# ?RRPM???? : Intégration du fichier ????? de l appli E-IRIS
# ----------------------------------------------------------------------------
# Parametres     :
# Entrees        :
# Sorties        :
# ----------------------------------------------------------------------------
# al 13-12-2006 creation
# ----------------------------------------------------------------------------
set -x
#-------------------------------------------------------------------
#Diverses initialisations de variables obligatoires
#-------------------------------------------------------------------

#Date passee en argument par CONTROLM
ODATE=${1}
[ "X${ODATE}" = "X" ] && echo "Parm ODATE non specifie" && exit 1

ctrlmExports ${0}
switch ${GEHLOG} > /dev/null


#-------------------------------------------------------------------
#Chargement des variables d'environnement
#-------------------------------------------------------------------
_GENERAL_ENV="${GEDAA}/etc/`echo ${GEIENV} | tr "PXG" "pxg"`v/env.ksh"
_LOCAL_ENV="${GEDAACC}/etc/env.ksh"
[ -a ${_GENERAL_ENV} ] && . ${_GENERAL_ENV}
[ -a ${_LOCAL_ENV} ] && . ${_LOCAL_ENV}

#-------------------------------------------------------------------
#Initialisation des variables n'ayant pas a etre modifiees
#-------------------------------------------------------------------
_P_DATE=`date +"%y%m%d_%H%M%S"`
_CODE=0


P_DATE=`date +"%d%m%H%M%S"`
 
_MNEMO=FGRRERPO
DATAERIS=$DATA/${_MNEMO}.wait
DATAERIS_done=$DATA/${_MNEMO}.done

mv $DATAERIS/*.txt ${DATAERIS_done}

_CODE=$?
echo "*--------------------------------------------* "
echo "* Fin du script $JOB = $P_DATE                 "
echo "*--------------------------------------------* "

exit ${_CODE}
