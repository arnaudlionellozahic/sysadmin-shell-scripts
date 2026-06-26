#!/bin/ksh
#*****************************************************************************
# Nom	:	  verif_RESSOURCE.ksh V1.1
# Description	: Verification de l'etat des ressources.
#
# Creation	: Le 11/08/1999 par T. DEVIGNE
# Modification	: 12/10/1999 par Daniel DOCHEZ (verification selon ${ETC}/Parametre_RESSOURCE.lst).
# Modification	: 5/9/2000 par Daniel DOCHEZ (rajout d'une consigne).
# Modification	: 16/10/2000 par Daniel DOCHEZ (remise automatique de la valeur mini).
# Modification	: 13/08/2004 par Pierre Castelain (Migration sysauto --> vtom)
#*****************************************************************************
#
CONTROL=0
NB=0

# Corps du programme principal.
echo "\n	@ Controle des ressources : @\n\n"
cat Parametre_RESSOURCE.lst | grep -v "^#" | while read LINE
do
	NOM=$(echo ${LINE} | awk '{print $1}')
	ENV=$(echo ${LINE} | awk '{print $6}')
	if test "${ENV}"
		then
		ENVIRONMENT="-env ${ENV}"
	fi
	RESSOURCE=$(tval ${ENVIRONMENT} -name ${NOM})
	TEST=$(echo ${LINE} | awk '{print $2}')
	VALEUR=$(echo ${LINE} | awk '{print $3}')
	if [ "${RESSOURCE}" ${TEST} ${VALEUR} ]
		then
		echo "	##### ${NOM} = ${RESSOURCE} (${TEST} ${VALEUR}). #####"
		if [ "${RESSOURCE}" -lt 0 ] && [ ${TEST} = "-lt" ] && [ ${VALEUR} = "0" ]
			then
			echo "	@ Remise a $(tval ${ENVIRONMENT} -name ${NOM} -value 0) automatique de ${NOM}. @"
		else
			((CONTROL+=1))
		fi
	else
		TEST2=$(echo ${LINE} | awk '{print $4}')
		VALEUR2=$(echo ${LINE} | awk '{print $5}')
		if [ "${RESSOURCE}" ${TEST2} ${VALEUR2} ]
			then
			echo "	##### ${NOM} = ${RESSOURCE} (${TEST2} ${VALEUR2}). #####"
			((CONTROL+=1))
		elif [ "${RESSOURCE}" -gt 0 ]
			then
			echo "	@ ${NOM} = ${RESSOURCE}. @"
		fi
	fi
	((NB+=1))
done
echo "\n	@ Controle de ${NB} ressource(s). @"

if [ ${CONTROL} -ne 0 ]
	then
	echo "CONSIGNE 1"
fi

# Appel de la date de fin de programme.
