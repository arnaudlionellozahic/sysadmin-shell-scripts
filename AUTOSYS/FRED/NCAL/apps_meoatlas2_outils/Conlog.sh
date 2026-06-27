#!/usr/bin/ksh

#==========================
#Conlog TNG tous les jours
#===========================
. /usr/bin/EnvironnementTNG

h1=$CAISCHD0011
d1=$(date +%d-%m-%Y)
h2=$(date +%H:%M:%S)

#Date1=yesterday"
#Date1="`TZ=MET+24 date +"%Y%m%d"`,${h1}:00:00"
Date2="$d1,$h2"

echo $Date1


sleep  30

#cautil select conlog start="yesterday" end="$Date2" list conlog  > /ficsav/EQUIPE_MEO/conlog/conlog.txt.`TZ=MET+24 date +"%Y%m%d"`
cautil select conlog start="yesterday" end="$Date2" list conlog  > /ficsav/conlog/conlog.txt.`TZ=MET+24 date +"%Y%m%d"`

