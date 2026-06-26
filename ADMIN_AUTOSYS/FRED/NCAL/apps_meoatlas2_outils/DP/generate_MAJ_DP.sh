#!/bin/sh
#
# CREATION DU DE
#
# Auteur : T. PETITPRE
#
# Date : 09-12-2013
#
#


export HOSTNAME=$(echo $(hostname))
export DATE=$(date +"%d\/%m\/%Y")


#-----------------------------------------------------------
# Controle de presence des fichiers necessaires
#-----------------------------------------------------------

if [[ -a DE_template_source.htm && -a DE_template_ender.htm && -a DE_template_cartouche.htm && -a Alertes_a_ajouter.lst && -a DE_template_header.htm && -a DE_template_consigne.htm ]]
then
echo "Tous les fichiers nécessaires sont presents"
else
echo "Tous les fichiers nécessaires ne sont pas presents :"
ls DE_template_source.htm DE_template_ender.htm DE_template_cartouche.htm Alertes_a_ajouter.lst DE_template_header.htm DE_template_consigne.htm | grep "not found"
exit 1
fi


#-----------------------------------------------------------
# renseigner la date de prise d'effet du DE
#-----------------------------------------------------------

#echo "Entrez la date de prise d'effet (jj/mm/aaaa) :"
#read DATE_E
#export DATE_EFFET=$(echo ${DATE_E} | sed 's/\//\\\//g')
echo "date d'effet = date du jour"
export DATE_EFFET=$(echo ${DATE})

#-----------------------------------------------------------
# renseigner le libelle de la consigne generique
#-----------------------------------------------------------

echo "Choisissez le libelle de la consigne liee (par ex. ATLAS2_MALI_tous_jobs) :"
read CONSIGNE
export CONSIGNE
#-----------------------------------------------------------
# rm du dernier DE puis creation du nouveau avec header
#-----------------------------------------------------------

touch DE_MAJ.htm
>DE_MAJ.htm
touch DE_CONSIGNE_GENERIQUE.htm
>DE_CONSIGNE_GENERIQUE.htm
cp DE_template_header.htm DE_MAJ.htm

#-----------------------------------------------------------
# Remplissage du DE avec la fiche de la consigne generique
#-----------------------------------------------------------

sed -e 's/DATE_J/'$DATE'/g' -e 's/CONSIGNE_/'$CONSIGNE'/g'  -e 's/DATE_EFFET/'$DATE_EFFET'/g' DE_template_consigne.htm >> DE_CONSIGNE_GENERIQUE.htm

#-----------------------------------------------------------------
# Ajout des cartouches pour les jobsets de Alertes_a_ajouter.lst
#-----------------------------------------------------------------

for i in $(cat Alertes_a_ajouter.lst)
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
        -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_MAJ.htm


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
        -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_MAJ.htm


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
        -e 's/SERVEUR_/'$HOSTNAME'/g' DE_template_cartouche.htm >> DE_MAJ.htm

else
     echo "\nErreur dans le script generate_DP.sh :"
     echo "le jobset ${JOBSET} est mal renseigne (consignes specifique)"
     echo "Vérifiez votre \"if \( echo \$JOBSET ... \"\n"
     exit 1

fi

done

cat DE_template_ender.htm >> DE_MAJ.htm

#-----------------------------------------------------------
# Instructions finales
#-----------------------------------------------------------

echo "\n-------------------------------------------------------------------------------"
echo "La consigne generique DE_CONSIGNE_GENERIQUE.htm a ete cree"
echo "Le fichier DE_MAJ.htm a ete cree, veuillez le renommer avec le nom souhaite"
echo "Merci de l'ouvrir sur votre machine pour verification"
echo "Il faut ensuite soumettre la DE_CONSIGNE_GENERIQUE.htm dans l'AEL si elle n'existe pas"
echo "puis soumettre le DE_MAJ.htm une fois la consigne présente dans l'AEL"
echo "\n--------------------------------------------------------------------------------"

