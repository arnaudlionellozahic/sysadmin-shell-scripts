# !/bin/ksh
# Script de recuperation des statuts des applications et traitements
# Apres export/import et treset des environnements sur l ensemble des dates rattachees
# Cree le 01/10/2003 par Yannick Cotel
# Modif 24/07/2009 P.LAIR :
# - suppression des taddjob /Status=AVENIR
# - taddapp /StatusAppOnly
# - prise en compte jobs retenus  
# - generation script pour treset


[ -a /bin/nawk ] && alias -x awk='/bin/nawk'
# Aide
clear
echo `basename $0`
echo " "
echo "Ce script est a utiliser dans le cadre de la recuperation des statuts des applications et traitements"
echo "apres export/import et treset des environnements sur l ensemble des dates rattachees"
echo 
echo "Procedure :"
echo "- arret des moteurs Vtom"
echo "- export global : texport > referentiel_vtom.exp"
echo "- lancer "$0" (ce dernier va generer le script de mise a jour majstatus_468.ksh)"
echo "- renommer le repertoire 'bases' actuel"
echo "- creer une base vierge"
echo "- importer le fichier d export global : timport referentiel_vtom.exp"
echo "- effectuer le treset des environnements sur l ensemble des dates rattachees (script reseted.ksh genere)"
echo "- lancer le script majstatus.ksh et consultez la log majstatus_468.log"
echo "- Vous pouvez mettre a jour uniquement un environnement ou une application"
echo "  Syntaxe: "
echo "       pour 1 environnement : "$0" <Nom_d_environnement> "
echo "       pour 1 application   : "$0" <Nom_d_environnement> <Nom_d_application> "
echo
echo "ATTENTION !!!, ce script utilise les options apps_status et jobs_status"
echo "               de la commande tlist, verifiez au prealable que ces options sont supportees"
echo "               par votre version de tlist"
echo
# Test de compatibilite de la cmd awk
if [ $# -gt 0 ]
then
	testenv=`echo|awk '{ print ENVIRON["SHELL"] }'`                        
	if [ "${testenv}" != "${SHELL}" ]
	then
	echo 'WARNING !!! Fin du programme'
	echo "Votre version de awk ne permet pas la recuperation des variables d environnement"
	echo "Vous pouvez utilisez genere_status.ksh uniquement sans arguments"
	echo
	exit 1
	fi
fi

# ----- tentative d'optimisation (!)
# on ne fait pas les (v)taddjob pour les jobs au statut AVENIR dans une appli au statut AVENIR (situation post-treset)

# Attribution des variables en fonctions des parametres d entree
case $# in
	0) ;;
	1) export majenv=$1 ;;
	2) export majenv=$1 ; export majapp=$2 ;;
	*) echo "Nbre d arguments invalide, consultez l aide" ; exit 1 ;;
esac

if [ $# -ge 1 ]
then
tlist env|grep "$1 " > /dev/null 2>&1 || {
echo "Environnement $1 inexistant, sortie imperative"
echo
exit 1
}
echo
echo "Environnement : "$1
fi

if [ $# -eq 2 ]
then
tlist apps_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] { print $1$2 }'|grep $1$2 > /dev/null 2>&1 ||{
echo "Application $1/$2 inexistante, sortie imperative"
echo
exit 1
}
echo 
echo "Application : "$2
fi


echo "Continuer ? (Entrer ou Ctrl+c)"
read a

# ----- generation du script pour les treset
if [ $# -eq 0 ]
then
	tlist env/date | awk '{print "treset "$1" "$2}' > reseted.ksh
fi

if [ $# -eq 1 ]
then
	tlist env/date | awk ' $1 == ENVIRON["majenv"] {print "treset "$1" "$2}' > reseted.ksh
fi


# Generation du script de mise a jour
echo
echo "Generation du batch de Mise a jour"
echo "----------------------------------"
echo

echo "# !/bin/ksh" > majstatus_468.ksh 
cr0=$?
if [ $cr0 -gt 0 ]
then             
echo "Incident lors de la creation des batchs de mise a jour"
exit 1
fi

genere () {
echo "echo " 
echo "funcmaj ()" 
echo "{" 

# Recuperation des applications
echo "echo MAJ des Applications " 
echo "echo --------------------" 
echo "echo" 
echo "set -x" 

if [ $# -eq 0 ]
then
tlist apps_status |awk '$3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=ERREUR"
} else {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=" $3
}
}' 
fi

if [ $# -eq 1 ]
then
tlist apps_status|awk ' $1 == ENVIRON["majenv"] && $3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=ERREUR"
} else {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=" $3
}
}' 
fi

if [ $# -eq 2 ]
then
tlist apps_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] && $3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=ERREUR"
} else {
print "taddapp /StatusAppOnly /nom=" $1"/"$2 " /status=" $3
}
}' 
fi


echo "set +x" 
echo "echo" 
echo "echo" 
echo "echo MAJ des Traitements " 
echo "echo -------------------" 
echo "echo"   

# Recuperation des traitements
echo "set -x" 



if [ $# -eq 0 ]
then
tlist jobs_status|awk ' { if ( $4=="PLANTE" ) {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
tlist retenus | awk '{print "taddjob /nom=" $1"/"$2"/"$3" /retenu=oui"}'
fi

if [ $# -eq 1 ]
then
tlist jobs_status|awk ' $1 == ENVIRON["majenv"] { if ( $4=="PLANTE" ) {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
tlist retenus | awk '$1 == ENVIRON["majenv"] {print "taddjob /nom=" $1"/"$2"/"$3" /retenu=oui"}'
fi

if [ $# -eq 2 ]
then
tlist jobs_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] { if ( $4=="PLANTE" ) {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print "taddjob /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
tlist retenus | awk '$1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] {print "taddjob /nom=" $1"/"$2"/"$3" /retenu=oui"}'
fi

echo "set +x" 
echo "echo"                                  
echo "echo Fin de la log" 
echo "echo -------------" 
echo "}" 
echo 


echo "echo Debut de la mise a jour" 
echo "echo -----------------------" 
echo "funcmaj 2>&1 | tee majstatus_468.log" 
echo "echo Fin de la mise a jour" 
echo "echo ---------------------" 
echo "echo" 
echo 'echo "Voulez vous consulter la log majstatus_468.log ? (Entrer ou Ctrl+c)"' 
echo "read a" 
echo "more  majstatus_468.log"

}

genere $* >> majstatus_468_0.ksh
#----- Desactivation des vtaddjob pour les applications a venir"
grep -v "status=AVENIR" majstatus_468_0.ksh > majstatus_468.ksh

chmod a+x majstatus_468.ksh 
echo
echo "Generation terminee"
echo "-------------------"
echo "Une fois effectues le timport et le treset des dates (reseted.ksh),"
echo "vous pouvez lancer majstatus_468.ksh et consulter la log majstatus_468.log"
echo

