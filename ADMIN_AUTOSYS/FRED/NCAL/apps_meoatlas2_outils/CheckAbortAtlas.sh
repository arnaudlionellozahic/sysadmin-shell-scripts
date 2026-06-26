#version 3.0

while :
do
  echo "Quel est le job : "
  read job
 
  if [[ -z $job ]]
  then
    echo "ERREUR : Le paramêtre job est vide"
  fi

  echo "Quel est le jobset : "
  echo "Peut être laissé vide."
  read jobset
  affich_jobset="| grep -i $jobset"
  if [[ -z $jobset ]] ##Si le champ est vide on fait un grep sur atlas et on modifie l'affichage de la commande
  then
    affich_jobset=""
    jobset="atlas"
  fi

  echo "\n"
  date

  echo "Quel est l'heure d'exécution (heure site) : (sous la forme HH)"
  echo "Peut être laissé vide."
  read Hour
  affich_Hour="| grep -i $Hour:"
  if [[ -z $Hour ]] ##Si le champ est vide on fait un grep sur rien et on modifie l'affichage de la commande
  then
    affich_Hour=""
    Hour=""
  fi
  
  while :
  do
## Affichage des logs disponibles
    echo "\n cdi-1"
      echo "Exécution sur /apps/arch/imp-1/ de ls -ltr  | grep -i $job $affich_jobset $affich_Hour"
      ls -ltr /apps/arch/imp-1 | grep -i $job | grep -i $jobset | grep -i $Hour:

    echo "\n cdi-0"
      echo "Exécution sur /apps/arch/imp-0/ de ls -ltr  | grep -i $job $affich_jobset $affich_Hour"
      ls -ltr /apps/arch/imp-0 | grep -i $job | grep -i $jobset | grep -i $Hour:

    echo "\n cdi"
      echo "Exécution sur /apps/atlas/atlas2v0/uf1/data1/imp/ de ls -ltr | grep -i $job $affich_jobset $affich_Hour"
      ls -ltr /apps/atlas/atlas2v0/uf1/data1/imp | grep -i $job | grep -i $jobset | grep -i $Hour:

## Menu de sélection du répertoire de log
    echo "\n"
    echo "Quel est le répertoire?" 
    echo "1 - cdi-1" 
    echo "2 - cdi-0" 
    echo "3 - cdi" 
    echo "s - sortie" 
    echo "q - quit" 
    read Rep

## Sortie de la boucle
    case $Rep in 
    q) exit 0 ;;
    s) break ;;
    esac

    echo "Quel est le fichier à afficher?"
    read Fich
  
    case $Rep in 
    1) more /apps/arch/imp-1/$Fich ;;
    2) more /apps/arch/imp-0/$Fich ;;
    3) more /apps/atlas/atlas2v0/uf1/data1/imp/$Fich ;;
    s) break ;;
    esac
  done
done