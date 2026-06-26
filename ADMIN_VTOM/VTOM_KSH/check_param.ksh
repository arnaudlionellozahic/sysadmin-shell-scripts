#!/bin/ksh
# --------------------------------------------------------------------------------------------------------------- #
#  Script "check_param.ksh" :											  #
#	- Verification de la coherence des Parametres de Jobs entre deux exports Visual TOM                       #
#														  #
#  Prerequis :                               									  #
#       - Iso perimetre (Jobs) entre les deux fichiers d'Export Visual TOM                                        #														  #
#														  #
#  Parametres d'entree :											  #
#	1 - fichier export Visual TOM source									  #
#	2 - fichier export Visual TOM cible									  #
#														  #
#       Exemple :												  #
#	   ./check_param.ksh export_source.dat export_cible.dat							  #
#														  #
#  Resultat en sortie :												  #
#	- fichier "result.dat" : liste des Jobs dont les parametres sont differents entre la source et la cible	  #
# --------------------------------------------------------------------------------------------------------------- #
#

if [ $# -eq 2 ]
then
  if [[ ! -f $1 || !  -f $2 ]]
  then
    echo "Au moins 1 fichier Export inexistant"
    exit
  fi
else
  echo "Mauvais nombre de parametres"
  exit
fi

if [[ -f ./source.dat ]]; then rm ./source.dat ;fi
if [[ -f ./cible.dat ]]; then rm ./cible.dat ;fi
if [[ -f ./tmp_source.dat ]]; then rm ./tmp_source.dat ;fi
if [[ -f ./tmp_cible.dat ]]; then rm ./tmp_cible.dat ;fi


line=""
for ligne in $(cat $1);  
do  
if [[ $ligne =~ '^[job:' ]]; then line=$ligne ;fi
if [[ $ligne =~ '^parametres=' ]]; then 
   line=$line"-->"$ligne 
   echo $line >> tmp_source.dat
   line=""
fi
done

line=""
for ligne in $(cat $2);
do
if [[ $ligne =~ '^[job:' ]]; then line=$ligne ;fi
if [[ $ligne =~ '^parametres=' ]]; then
   line=$line"-->"$ligne
   echo $line >> tmp_cible.dat
   line=""
fi
done

sort -o ./source.dat ./tmp_source.dat
sort -o ./cible.dat ./tmp_cible.dat

rm ./tmp_source.dat
rm ./tmp_cible.dat

diff ./source.dat ./cible.dat > tmp_result.dat
retour=$?

sort ./tmp_result.dat | grep "parametres" > result.dat

rm ./tmp_result.dat

if [ "$retour" = "0" ] ; then
                clear
                echo "###########################################################"
                echo "OK : Aucune difference detectee entre la source et la cible"
                echo "###########################################################"
                rm ./result.dat
else
                clear
                echo "###################################################################################################################"
                echo "KO : parametres differents sur la cible, veuillez consulter le fichier result.dat pour le detail des Jobs concernes"
                echo "###################################################################################################################"
                echo " "
                cat result.dat | grep "<"
                echo " "
fi

rm ./source.dat
rm ./cible.dat

exit
