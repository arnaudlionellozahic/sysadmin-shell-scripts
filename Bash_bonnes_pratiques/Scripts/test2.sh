#!/bin/bash -x
#
# Un script qui fait des trucs
#

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# le truc le plus important du script
echo "1.2.3" > ~/application.conf
echo $toto
echo "sortie 1"
ls /rezt
echo "sortie 2"

# ici c'est la fin
