DATE=$1
FILTRE=$2
MAIL=$3

STATS_FILE=$TOM_STATS/$(echo $DATE|sed 's/\(..\)-\(..\)-\(....\)/\3-\2-\1/').csv
echo $STATS_FILE