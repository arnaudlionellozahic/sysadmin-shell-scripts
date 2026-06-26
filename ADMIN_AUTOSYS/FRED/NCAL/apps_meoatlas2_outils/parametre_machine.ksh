#!/bin/ksh

#############################################################################
# Informations machine en dur :
#############################################################################
export INFO_MACHINE="atcald-prd"
export INFO_HOST="parva4000839"
export INFO_GROUPE="irs"
export INFO_TYPE="atlas2"
export INFO_PARTENAIRE="M091101B"

#############################################################################
# Information sur le serveur Intranet :
#############################################################################
export RMEO_PARM_SITE="${INFO_TYPE}#${INFO_MACHINE}#${INFO_GROUPE}"
export RMEO_IDF="MEOATLAS"
export RMEO_PART="MD31002P"

#############################################################################
# Répertoires utiles :
#############################################################################
export MEO_LOG=/apps/meoatlas2/log
export MEO_OUTILS=/apps/meoatlas2/outils
export MEO_PARAM=/apps/meoatlas2/param
export MEO_ANALYSE=/apps/meoatlas2/ANALYSE
