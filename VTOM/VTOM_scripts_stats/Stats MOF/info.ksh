#!/bin/ksh

# @(#) $Id: info.ksh,v 1.0 2007/10/05 19:18:00 vtom Exp $
# @(#) $Type: Korn Shell Script $
# @(#) $Summary: Rapport sur l'etat des processus VTOM $
# @(#) $Location: /home/vtom/scripts/pilotage $
# @(#) $Support: Unices with VTOM agent 4.1 $
# @(#) $Owner: vtom $
# @(#) $Copyright: Administration SAP DP (Franck M. Lefort) - AGF Informatique $

_B=$(tput bold)
_R=$(tput rev)
_U=$(tput smul)
_X=$(tput sgr0)

echo "${_R}                               Informations VTOM                                ${_X}"
if [[ -n "$TOM_BIN" ]]; then
  if [ -n "${TOM_PRIMARY_SERVER}" ] ; then
    echo "Serveur de backup ${HOST} (primaire : ${TOM_PRIMARY_SERVER}) \c"
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] && { echo "${_B}inactif${_X}"; pulse="none"; }
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] || { echo "actif"; pulse="many"; }
    (export TOM_REMOTE_SERVER=${TOM_PRIMARY_SERVER}; [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] && echo "${_B}Serveur primaire inactif${_X}")
    (export TOM_REMOTE_SERVER=${TOM_PRIMARY_SERVER}; [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] || echo "Serveur primaire actif")
  elif [ -n "${TOM_BACKUP_SERVER}" ] ; then
    echo "Serveur primaire ${HOST} (backup : ${TOM_BACKUP_SERVER}) \c"
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] && { echo "${_B}inactif${_X}"; pulse="none"; }
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] || { echo "actif"; pulse="many"; }
    (export TOM_REMOTE_SERVER=${TOM_BACKUP_SERVER}; [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] && echo "${_B}Serveur de backup inactif${_X}")
    (export TOM_REMOTE_SERVER=${TOM_BACKUP_SERVER}; [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] || echo "Serveur de backup actif")
  else
    echo "Serveur ${HOST} en mode single \c"
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] && { echo "${_B}inactif${_X}"; pulse="none"; }
    [[ $(tlist cal 2> /dev/null|wc -l) -eq 0 ]] || { echo "actif"; pulse="many"; }
  fi
  abswhat $TOM_BIN/dserver | sed -e 's/^.*: //'
  echo "${_U}Processus serveurs (dserver, gserver, pserver, vtlserver, iserver)${_X}"
  ps -o "pid,comm" -u $TOM_USER_ADMIN|grep "[dgpli]server"|while read p c;do
    echo "($p) $c  \c"
  done; echo ""
  if [[ "$pulse" = "many" ]]; then
    echo "${_U}Etat des moteurs${_X}"
    tlist env | while read eng; do
      echo "$(epresent $eng|sed -e 's/^Aucun.*$/2/' -e 's/^Un moteur.*$/1/') $eng \c"
      echo $(ps -eo 'pid,args'|grep '[tT]engine'|grep " $eng "|awk '{print $1;}')"\c"
      echo ""
    done | sort | sed -e 's/^1/ON/' -e 's/^2/OFF/' | awk '{printf("%-16.16s\t%s\t(%s)\n",$2,$1,$3);}'
  fi
  echo "${_U}                                                                                ${_X}\n"
fi
if [[ -n "$ABM_BIN" ]]; then
  [[ $(buser|grep impossible|wc -l) -eq 0 ]] && echo "Client VTOM actif $(ps -eo 'pid,comm'|grep bdaemon|awk '{print $1;}')"
  [[ $(buser|grep impossible|wc -l) -eq 0 ]] || echo "${_B}Client VTOM inactif${_X}"
  abswhat $ABM_BIN/bdaemon | sed -e 's/^.*: //'
  echo "${_U}                                                                                ${_X}\n"
fi
if [[ -n "$TOM_VISUAL" ]]; then
  echo "IHM VTOM"
  abswhat $TOM_VISUAL/vtom | sed -e 's/^.*: //'
  echo "${_U}IHM actives${_X}"
  ps -ef | nawk '$NF ~ ".*vtom$" {printf("%s\t(%s)\n",$1,$2);}'
  echo "${_U}                                                                                ${_X}\n"
fi
if [[ $(id | cut -f2 -d"(" | cut -f1 -d")") = $TOM_USER_ADMIN ]]; then
  echo "Vous avez les droits d'administration ($(who | grep $TOM_USER_ADMIN | wc -l | sed 's/^[         ]*//') connectes)"
  echo "${_U}                                                                                ${_X}\n"
else
  echo "Vous n'avez pas les droits d'administration\n"
  echo "${_U}                                                                                ${_X}\n"
fi
