#/usr/bin/ksh I=0
>/ficsav/tt.tmp
#set -x
. /.profile
calcul_duree(){
export mult=0
export hhd=$(echo $1|awk -F. '{print $1}')
export hhf=$(echo $2|awk -F. '{print $1}')
export mmd=$(echo $1|awk -F. '{print $2}')
export mmf=$(echo $2|awk -F. '{print $2}')
export ssd=$(echo $1|awk -F. '{print $3}')
export ssf=$(echo $2|awk -F. '{print $3}')
#echo $hhd $hhf $mmd $mmf $ssd $ssf
export debut=$(bc -l <<EOF
($hhd*3600)+($mmd*60)+$ssd
quit
EOF)
export fin=$(bc -l <<EOF
($hhf*3600)+($mmf*60)+$ssf
quit
EOF)
export dif=$(bc -l <<EOF
$fin-$debut
quit
EOF)
#echo $fin $debut $dif
if [[ $dif -lt 0 ]]
then
mult=1
fi
   typeset -Z2 hh
   typeset -Z2 mm
   typeset -Z2 ss

(( diff=dif+(86400*mult) ))
export diff
(( hh=diff/3600 ))
export hh
(( rest=diff%3600 ))
export rest
(( mm=rest/60 ))
export mm
(( ss=rest%60 ))
export ss

echo $hh:$mm:$ss
}
cat /apps/atlas/atlas2v0/uf1/jobset/parm/*.txt >/ficsav/jobset.list
jfin=$(date +%d)
moisf=$(date +%m)
Fannee=`date +%Y`
#datemj=$(cat /apps/atlas/atlas2v0/uf1/data1/fic/ASF_PJF11101|cut -c 1-8)
datemj=$Fannee$moisf$jfin
annemj=$(echo $datemj|cut -c 1-4)
moismj=$(echo $datemj|cut -c 5-6)
jourmj=$(echo $datemj|cut -c 7-8)
datemj="$jourmj"-"$moismj"-"$annemj"
/apps/unicenter/EM/3.1/bin/cautil list jobset id=*|grep -iE 'update'  | awk '  {print $5}'>/ficsav/tngmaj
nbmaj=$(grep "$datemj" /ficsav/tngmaj|wc -l)
 if [[ $nbmaj -eq "0" ]]
        then
        print Pas de mise a jour TNG 
        exit
 fi
cd /ficsav
more  jobset.list |sed -e "s/^\([A-Za-z0-9 :,+=()]*\)DESCRIPTION[-A-Za-z0-9 :.,_+='éèàîê]*\(STATION=[A-Za-z0-9 :,+=]*\)/\1\2/" >jobset.list2
             
####################
while read var0 var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16
do
if [[ $var11 = "AUTOSEL=Yes" || $var11 = "AUTOSEL=No" ]] then
var12=$var11
fi
if [[ $var16 = "" && $var1 = "JOBSET" ]] then
var16=$var15
fi
if  [[  $var1 = "JOB" ]] then
vardate=""
fi
if  [[  $var1 = "JOBSET" ]] then
etat="$var2 $var7 $var8 $var12 $var16"
if [[  $var7 = "USERENV=No" ]] then
etat="$var2 $var10 $var15"
fi
fi
if [[  $var1 = "JOBSETPRED" ]] then
etat="$var2 $var1 $var3 $var4 $var5 $var6"
fi
if  [[  $var1 = "JOBSET" ]] then
jobs=$(echo $var2|cut -c 4-11)
#vardate=$(cautil list jobset id=$jobs|grep -iE 'update'|awk '  {print var,$5}')
vardate=$(/apps/unicenter/EM/3.1/bin/cautil list jobset id=$jobs|grep -iE $datemj| wc -l)
fi
#if [[ $vardate -ge $datemj ]] then
if [[ $vardate -ne "0" ]] then
echo $etat >>/ficsav/tt.tmp
fi
done </ficsav/jobset.list2
more tt.tmp |sed -e "s/^\([A-Za-z0-9 .:,+=()]*\)HISTORY[-A-Za-z0-9 =]*\(CALENDAR[A-Za-z0-9 :,+=]*\)/\1\2/" >jobset.list2
zblanc="                                                                  "
echo "">/ficsav/ficres.xls
echo "                         COMPTE RENDU M.A.J BASE TNG" $A2_LIBENV  au     $datemj >>/ficsav/ficres.xls               
echo "">>/ficsav/ficres.xls
echo " NOM JOBSET  Mode charg. Calendrier  Heure Début  Heure Fin              Prédécesseurs  " >>/ficsav/ficres.xls

while read var1 var2 var3 var4 var5 var6 
do
jobs=$(echo $var1|cut -c 4-11)
auto=$(echo $var4|cut -c 1-7)
auto1=$(echo $var2|cut -c 1-7)
auto2=$(echo $var2|cut -c 1-7)
if [[ $auto = "AUTOSEL" ]] then
earl=$(echo $var2|cut -c 11-18)
must=$(echo $var3|cut -c 14-21)
cald=$(echo $var5|cut -c 10-15)
sele=$(echo $var4|cut -c 9-11)
if [[ $auto1 = "MUSTSTA" ]] then
earl=$(echo $var2|cut -c 15-22)
fi
fi
if [[ $auto1 = "AUTOSEL" ]] then
sele=$(echo $var2|cut -c 9-11)
cald=$(echo $var3|cut -c 10-15)
earl="        "
must="        "
fi
if [[ $var4 = "WORKDAY=CURRENT" ]] then
var4=""
fi
#if [[ $var2 = "JOBSETPRED" && $cald = "wday01" ]] then
if [[ $var2 = "JOBSETPRED" ]] then
echo "$zblanc" $var3 $var4  >>/ficsav/ficres.xls
else 
#if [[ $cald = "wday01" ]] then
echo " " $jobs "     " $sele "      " $cald "    " $earl "  "  $must  >>/ficsav/ficres.xls
#fi
fi
done </ficsav/jobset.list2
#exit
export A2_LIBENV=atcald-prd  
(echo "Subject : COMPTE RENDU M.A.J TNG $A2_LIBENV $datemj";uuencode ficres.xls ficres.xls) |sendmail  -f paris_sig_pbcb2_atlas@bnpparibas.com -v mohamed.abaach@externe.bnpparibas.com sebastien.couasnon@externe.bnpparibas.com christian.llavador@bnpparibas.com mathieu.gouineau@bnpparibas.com


