#!/usr/bin/ksh
#Calcul de la duree entre 2 dates
#exemple: duree.sh "14-02-2007 00:00:01" "14-02-2007 02:00:01"
#Auteur: Gilbert BITTA
#-------------------------------------------------------------
deb="$1"
fin="$2"



#--------------------------------------------------
#Convertir une heure (HH:MM:SS) en nbre de secondes
#--------------------------------------------------
function heure_s
{
he=$1
h=$(echo $he | awk -F ":" '{print $1}')
m=$(echo $he | awk -F ":" '{print $2}')
s=$(echo $he | awk -F ":" '{print $3}')

nb_s=$(echo "3600*$h + 60*$m + $s" | bc -l)
}


#---------------------------------------------
#Convertit un nbre de secondes en JJ:HH:MM:SS
#----------------------------------------------
function conversion_date
{
t=$1
typeset -i J=t/86400
typeset -i Rj=t%86400

typeset -i H=Rj/3600
typeset -i Rh=t%3600

typeset -i M=Rh/60
typeset -i Rm=Rh%60

typeset -i S=Rm

#h="${J}j:${H}h:${M}m:${S}s"
h="0${H}:${M}"
}



#----------------------------------------------------
#Determine si une date donnee est une annee bissextile
#-----------------------------------------------------
function bissextile
{ if [ `expr $1 % 400` -eq 0 ] ||
[ `expr $1 % 100` -ne 0 -a `expr $1 % 4` -eq 0 ]
then ans=1
else ans=0
fi
}


#-------------------------------------------------------
#Nbre de secondes ecoules depuis 01/01/1970
#-------------------------------------------------------
function calcul_date
 {
#aa: annee
# Du 1er janvier 1970 au 31 décembre 1975+4(n-1)
# Le nombre de jours écoulés est : 366*n+365*(2+3*n)

aa1=$(echo $date1| awk -F"/" '{print $3}')
mm1=$(echo $date1| awk -F"/" '{print $2}')
jj1=$(echo $date1| awk -F"/" '{print $1}')
a1=$(echo $aa1 | cut -c 3-)
dt=$mm1$jj1"0000"$a1


j1=$(echo "$jj1/1" | bc -l | awk -F"." '{print $1}')
cal $mm1 $aa1 | grep -wq $j1
if [[ $? -ne 0 ]]
  then
       echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
       echo "$date1 : Ce jour n'existe pas dans le calendrier"
       echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
     #  exit 1
fi


bissextile $aa1

#La date est une année bissextile (366 jours)
if [ $ans -eq 1 ]
then
f_bissextile
total1=$(echo "$total*24*60*60" | bc -l)
#echo "$total j  ==  $total1 s"
fi

#La date n'est pas une année bissextile (365 jours)
if [ $ans -eq 0 ]
then
f_non_bissextile
fi

}




#----------------------------------------------------------------------------
#Nbre de jours ecoules entre 01/01/1970 et l'annee bissextile la plus recente
#-----------------------------------------------------------------------------
function f_bissextile
{
#Du 01/01/1970 au 31/12/1999)
#1999=1975 + 4(n-1) Ò n=(1999-1975)/4 + 1
aa1_1=$(echo "$aa1 - 1" | bc -l )
n=$(echo "($aa1_1 - 1975)/4 + 1" |bc -l | cut -c 1-1)
d1=$(echo "366*$n+365*(2+3*$n)" | bc -l)

#durée écoulée en (j) du 01/01/1970 au 31/12/1999
#le reste du 01/01/2000 au13/05/2000 est de : mm1=05 , donc mois de 01 02 03 04 et 05

mm1_1=$(echo "$mm1 - 1" | bc -l)
i=1
sum=0  # compte le nbre de jours de chaque mois jusqu'à l'avant dernier mois.
while [ $i -le $mm1_1 ]
   do
   dernier_j_mois=$(cal $i $aa1 | grep -v "^$" | tail -1 | awk '{print $NF}')
      i=$(echo "$i + 1" | bc -l)
     sum=$(echo "$sum + $dernier_j_mois" | bc -l)
#  echo "a:$aa1 == dj:$dernier_j_mois == sum:$sum == m:$i/$mm1_1"
done

#donc le total de jour depuis le 01/01/1970 jusqu'au 13/05/2000 est :
total=$(echo "$d1+$sum+$jj1-1" | bc -l)
}




#---------------------------------------------------------
#Recherche de l'anne bissextile juste avant la date donnee
#----------------------------------------------------------
function f_non_bissextile
{
#recherche de l'année bissextile juste avant
temp_aa1=$aa1

while [ $ans -eq 0 ]
  do
    aa1_a=$(echo "$temp_aa1 - 1" | bc -l)
    bissextile $aa1_a
     if [ $ans -eq 1 ]
       then
            break
       else
      temp_aa1=$aa1_a
     fi
done

n_1=$(echo "$aa1 - $temp_aa1" | bc -l)
n1=$(echo "$n_1 - 1" | bc -l)


f_bissextile

total=$(echo "$total+$n_1*365+366" | bc -l)
total1=$(echo "$total*24*60*60" | bc -l)
#echo "$total j  ==  $total1 s"
}




#
d_deb=$(echo $(echo $deb | awk '{print $1}') | sed "s/-/\//g")
h_deb=$(echo $deb | awk '{print $2}')


d_fin=$(echo $(echo $fin | awk '{print $1}') | sed "s/-/\//g")
h_fin=$(echo $fin | awk '{print $2}')



if [[ -z $d_fin ]]
   then
       :
   else

#---------------------------
#Traitement date/heure debut
#---------------------------
date1="$d_deb"
calcul_date
dur_deb=$total1
heure_s $h_deb
dur_deb_s=$nb_s
#nbre de secondes date/heure debut
nb_dur_deb=$(echo "$dur_deb + $dur_deb_s" | bc -l)


#---------------------------
#Traitement date/heure fin
#---------------------------
date1="$d_fin"
calcul_date
dur_fin=$total1
heure_s $h_fin
dur_fin_s=$nb_s
#nbre de secondes date/heure fin
nb_dur_fin=$(echo "$dur_fin + $dur_fin_s" | bc -l)


#nb de secondes date/heure
d_date=$(echo "$nb_dur_fin - $nb_dur_deb" | bc -l)

conversion_date $d_date
duree=$h

echo "$duree"
#echo "${d_deb}_${h_deb} ${d_fin}_${h_fin} $duree"

fi
