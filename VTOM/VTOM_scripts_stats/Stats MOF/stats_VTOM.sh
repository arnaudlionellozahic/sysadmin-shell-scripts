#! /bin/ksh

while getopts ":f:smco:" option; do
  case $option in
     f) [[ -z "$OPTARG" ]] && { echo "option -f suivie d'un filtre" >&2; exit 1; }
        FILTRE="-f $OPTARG" ;;
     m) SEND=o; SAVE=o ;;
     c) ZIP=o; SAVE=o ;;
     s) SAVE=o ;;
     o) [[ -z "$OPTARG" ]] && { echo "option -o suivie d'un nom de fichier" >&2; exit 1; }
        STATS_FILE="$OPTARG"; SAVE=o ;;
    \?) echo "option $OPTARG invalide" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))
case $# in
  0) DATE_D=${1:-$(date +"%d-%m-%Y")}; DATE_F=$DATE_D ;;
  1) DATE_D=$1; DATE_F=$DATE_D ;;
  2) DATE_D=$1; DATE_F=$2 ;;
  *) echo ""
esac
if [[ -z "$SAVE" ]]; then
  STATS_FILE=/dev/null
  [[ -t 1 ]] && STATS_FILE=/dev/tty
else
  [[ -z "$STATS_FILE" ]] && {
    STATS_FILE=$(echo $DATE_D|sed 's/\(..\)-\(..\)-\(....\)/\3-\2-\1/').csv
    [[ -z "$FILTRE" ]] || STATS_FILE=$(echo $FILTRE|sed -e 's/-f //' -e 's:/:-:g')_$STATS_FILE
    STATS_FILE=$TOM_STATS/$STATS_FILE
  }
fi

echo "ENV/APP/JOB;MACHINE;USER;BEGIN;END;ELAPSE;STATUS" > $STATS_FILE
vtstools -local $FILTRE -export $DATE_D $DATE_F \
| sed -e 's/INVISION;FIDELIO/INVISION,FIDELIO/g' \
| awk -F\; '{printf("%s/%s/%s;%s;%s;%s;%s;%s;%s\n",$1,$2,$3,$7,$9,$10,$11,$12,$18)}' \
| grep -v "^.JOB_STAT." \
| grep -v "^ENV/APP/JOB;MACHINE" >> $STATS_FILE

[[ -z "$SEND" ]] || /usr/local/bin/sendmime.sh -t "Stats VTOM du $DATE_D au $DATE_F" mail_exploit $STATS_FILE
[[ -z "$ZIP" ]] || gzip -f -9 $STATS_FILE
