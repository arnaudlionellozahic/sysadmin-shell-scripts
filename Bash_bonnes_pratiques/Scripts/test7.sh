#!/bin/bash

function usage() {
  echo -e "Usage: $0 [-h] [-s|-d] [-q|-v] [-m] [-p <string>]"
  echo -e "  -h\t\tThis help"
  echo -e "  -q\t\tQuiet (no stdout)"
  echo -e "  -s\t\tSimulation"
  echo -e "  -b\t\tDeploy"
  echo -e "  -m\t\tSend mail"
}

while getopts ":hsqbd:mvp:z:" option
do
  case $option in
    h)
      usage; exit 0
      ;;
    s)
      SIMU=1
      DEPLOY=0
      ;;
    q)
      QUIET=1
      ;;
    b)
      BACKUP=1
      ;;
    m)
      SEND_MAIL=1
      ;;
    v)
      VERBOSE=1
      QUIET=0
      ;;
    d)
      DEPLOY=1
      SIMU=0
      ;;
    p)
      USE_P=1
      p=${OPTARG}
      ;;
    \?)
      usage; exit 1
      ;;
  esac
done

echo "Simu=${SIMU} Quiet=${QUIET} Deploy=${DEPLOY}"
[ $USE_P ] && echo "Use P with ${p}"
