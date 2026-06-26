tlist env | while read eng; do
  echo "$(epresent $eng|sed -e 's/^Aucun.*$/2/' -e 's/^Un moteur.*$/1/') $eng \c"
  echo $(ps -eo 'pid,args'|grep '[tT]engine'|grep " $eng "|awk '{print $1;}')"\c"
  echo ""
done | sort
