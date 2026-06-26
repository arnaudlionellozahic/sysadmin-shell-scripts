#!/bin/sh
#
# CREATION DU DE
#
# Auteur : T. PETITPRE
#
# Date : 17-09-2012
#
#


export HOSTNAME=$(echo $(hostname))
export DATE=$(date +"%d\/%m\/%Y")

#-----------------------------------------------------------
# Controle de presence des fichiers necessaires 
#-----------------------------------------------------------

if [[ -a DE_template_source.htm && -a DE_template_ender.htm && -a DE_template_cartouche.htm && -a DE_template_header.htm && -a DE_template_consigne.htm ]]
then
echo "Tous les fichiers nécessaires sont presents"
else
echo "Tous les fichiers nécessaires ne sont pas presents :"
ls DE_template_source.htm DE_template_ender.htm DE_template_cartouche.htm DE_template_header.htm DE_template_consigne.htm | grep "not found"
exit 1
fi
 

#-----------------------------------------------------------
# renseigner la date de prise d'effet du DE
#-----------------------------------------------------------

echo "Entrez la date de prise d'effet (jj/mm/aaaa) :"
read DATE_E
export DATE_EFFET=$(echo ${DATE_E} | sed 's/\//\\\//g')

#-----------------------------------------------------------
# renseigner le libelle de la consigne generique 
#-----------------------------------------------------------

echo "Choisissez le libelle de la consigne liee (par ex. ATLAS2_MALI_tous_jobs) :"
read CONSIGNE
export CONSIGNE 
#-----------------------------------------------------------
# rm du dernier DE puis creation du nouveau avec header 
#-----------------------------------------------------------

touch DE_CONSIGNE_GENERIQUE.htm
>DE_CONSIGNE_GENERIQUE.htm
cp DE_template_header.htm DE_CONSIGNE_GENERIQUE.htm

#-----------------------------------------------------------
# Remplissage du DE avec la fiche de la consigne generique 
#-----------------------------------------------------------

sed -e 's/DATE_J/'$DATE'/g' -e 's/CONSIGNE_/'$CONSIGNE'/g'  -e 's/DATE_EFFET/'$DATE_EFFET'/g' DE_template_consigne.htm >> DE_CONSIGNE_GENERIQUE.htm 

#-----------------------------------------------------------
# Ajout des cartouches pour les jobsets de liste_jobs.lst
#-----------------------------------------------------------


for LISTE_JOBS in $(ls liste_jobs.lst_a*)
do

  touch DE_${LISTE_JOBS}.htm
  >DE_${LISTE_JOBS}.htm
  cp DE_template_header.htm DE_${LISTE_JOBS}.htm

  for i in $(cat ${LISTE_JOBS})
  do

  export JOBSET=$(echo ${i} | cut -f1 -d:)
  export JOBS=$(echo ${i} | cut -f2 -d:)

  # prise en compte des jobsets qui ne declenchent pas les astreintes 

  echo $JOBSET | grep -e hbkp -e j9u1 >/dev/null 2>/dev/null

  if [[ $? -ne 0 ]]
  then
      sed -e 's/DATE_J/'$DATE'/g' \
          -e 's/DATE_EFFET/'$DATE_EFFET'/g' \
          -e 's/JOBSET_/'$JOBSET'/g' \
          -e 's/JOB_/'$JOBS'/g' \
          -e 's/ACTION_/Voir la consigne liee/g' \
          -e 's/CONSIGNE_/'$CONSIGNE'/g' \
          -e 's/CRITICITE_/critique/g' \
          -e 's/IMPACT_/bloquant/g' \
          -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_${LISTE_JOBS}.htm

    # CAS DES JOBSETS SANS ASTREINTE A REDIRIGER VERS MEO IRB
    # hbkp
 
  elif ( echo $JOBSET | grep hbkp >/dev/null 2>/dev/null )
      then
       sed -e 's/DATE_J/'$DATE'/g' \
          -e 's/DATE_EFFET/'$DATE_EFFET'/g' \
          -e 's/JOBSET_/'$JOBSET'/g' \
          -e 's/JOB_/'$JOBS'/g' \
          -e 's/ACTION_/transferer le ticket vers MEO IRB. NE PAS APPELER LES ASTREINTES/g' \
          -e 's/CONSIGNE_//g' \
          -e 's/CRITICITE_/non critique/g' \
          -e 's/IMPACT_/non bloquant/g' \
          -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_${LISTE_JOBS}.htm 
   
    # CAS DES JOBSETS SANS ASTREINTE A REDIRIGER VERS LES ETUDES
    # j9u1

  elif ( echo $JOBSET | grep j9u1 >/dev/null 2>/dev/null )
      then
       sed -e 's/DATE_J/'$DATE'/g' \
          -e 's/DATE_EFFET/'$DATE_EFFET'/g' \
          -e 's/JOBSET_/'$JOBSET'/g' \
          -e 's/JOB_/'$JOBS'/g' \
          -e 's/ACTION_/transferer le ticket vers Etudes. NE PAS APPELER LES ASTREINTES/g' \
          -e 's/CONSIGNE_//g' \
          -e 's/CRITICITE_/critique/g' \
          -e 's/IMPACT_/bloquant/g' \
          -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_${LISTE_JOBS}.htm 

  else
       echo "\nErreur dans le script generate_DP.sh :"
       echo "le jobset ${JOBSET} est mal renseigne (consignes specifique)"
       echo "Vérifiez votre \"if \( echo \$JOBSET ... \"\n" 
       exit 1

  fi

  done

cat DE_template_ender.htm >> DE_${LISTE_JOBS}.htm
mv DE_${LISTE_JOBS}.htm DE_jobs_${HOSTNAME}_$(echo ${LISTE_JOBS} | sed s/liste_jobs.lst_a//).htm
done


#-----------------------------------------------------------
# Instructions finales
#-----------------------------------------------------------

echo "\n-------------------------------------------------------------------------------"
echo "La consigne generique DE_CONSIGNE_GENERIQUE.htm a ete cree"
echo "Les fichiers DE_jobs_${HOSTNAME}_*.htm ont ete crees"
echo "Merci de les ouvrir sur votre machine pour verification"
echo "Vous pourrez ensuite les soumettre sur l'AEL avec la consigne"
echo "\n--------------------------------------------------------------------------------"


