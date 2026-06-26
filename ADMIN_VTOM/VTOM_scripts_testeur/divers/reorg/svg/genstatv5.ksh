# !/bin/ksh
# Script de recuperation des statuts des applications et traitements
# Apres export/import et treset des environnements sur l ensemble des dates rattachees
# Cree le 01/10/2003 par Yannick Cotel
# Modif 24/07/2009 P. LAIR (utilisation taddapp /StatusAppOnly + suppression des taddjob /Status=AVENIR)  

[ -a /bin/nawk ] && alias -x awk='/bin/nawk'
# Aide
clear
echo `basename $0`
echo " "
echo "Ce script est a utiliser dans le cadre de la recuperation des statuts des applications et traitements"
echo "apres export/import et treset des environnements sur l ensemble des dates rattachees"
echo "Procedure :"
echo "- arret des moteurs Vtom"
echo "- generation d un export global"
echo "- lancer genere_status.ksh ( Ce dernier va genere le script de mise a jour majstatv5.ksh )"
echo "- creer une base vierge"
echo "- importer le fichier d export global"
echo "- effectuer le treset des environnements sur l ensemble des dates rattachees (script tresetglob.ksh)"
echo "- lancer le script majstatv5.ksh et consultez la log majstatv5.log"
echo "- Vous pouvez mettre a jour uniquement un environnement ou une application"
echo "  Syntaxe: "
echo "       pour 1 environnement : genere_status.ksh <Nom_d_environnement> "
echo "       pour 1 application :   genere_status.ksh <Nom_d_environnement> <Nom_d_application> "
echo
echo "ATTENTION !!!, ce script utilise les options apps_status et jobs_status"
echo "de la commande tlist, verifiez au prealable votre version du tlist"
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
echo "environnement: $1 inexistant, sortie imperative"
echo
exit 1
}
fi

if [ $# -eq 2 ]
then
tlist apps_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] { print $1$2 }'|grep $1$2 > /dev/null 2>&1 ||{
echo "application: $1/$2 inexistante, sortie imperative"
echo
exit 1
}

fi


# ----- PL - 24/07/2009
# on ne fait pas les (v)taddjob pour les jobs au statut AVENIR dans une appli au statut AVENIR (situation post-treset)
# on positionne filtre_avenir a 1 lorsque'on veut realiser ce controle (inutile si on ne recupere le statut que sur une application)
# on utilise /StatusAppOnly pour les taddapp en version 46B8 pour que la mise a jour de statut n'impacte que les applications,
# la mise a jour des statuts des jobs etant faite par les taddjob

filtre_avenir=0

bin_job="taddjob"
bin_app="taddapp"
v5=0

# ----- test V5
if [ "`vtaddjob 2>/dev/null|awk 'NR==2 {print $0}'`" == "Visual TOM" ] ; then
	v5=1
	bin_job="vtaddjob"
	bin_app="vtaddapp"
fi

export bin_job bin_app


echo "Continuer ? (Entrer ou Ctrl+c)"
read a

# Generation du script de mise a jour
echo
echo "Generation du batch de Mise a jour"
echo "----------------------------------"
echo

echo "# !/bin/ksh" > majstatv5.ksh 
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
filtre_avenir=1
tlist apps_status > apps_status.txt
cat apps_status.txt|awk '$3 ~ /^AVENIR/ {print ENVIRON["bin_job"]" /nom="$1"/"$2"/"}' > apps_avenir.txt
cat apps_status.txt|awk ' $3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=ERREUR"
} else {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=" $3
}
}' 
fi

if [ $# -eq 1 ]
then
filtre_avenir=1
tlist apps_status > apps_status.txt
cat apps_status.txt|awk '$3 ~ /^AVENIR/ {print ENVIRON["bin_job"]" /nom="$1"/"$2"/"}' > apps_avenir.txt
cat apps_status.txt|awk ' $1 == ENVIRON["majenv"] && $3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=ERREUR"
} else {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=" $3
}
}' 
fi

if [ $# -eq 2 ]
then
tlist apps_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] && $3 !~ /^AVENIR$/ { if ( $3=="PLANTE" ) {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=ERREUR"
} else {
print ENVIRON["bin_app"]" /nom=" $1"/"$2 " /status=" $3
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
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
fi

if [ $# -eq 1 ]
then
tlist jobs_status|awk ' $1 == ENVIRON["majenv"] { if ( $4=="PLANTE" ) {
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
fi

if [ $# -eq 2 ]
then
tlist jobs_status|awk ' $1 == ENVIRON["majenv"] && $2 == ENVIRON["majapp"] { if ( $4=="PLANTE" ) {
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=ERREUR"
} else {
print ENVIRON["bin_job"]" /nom=" $1"/"$2"/"$3 " /status=" $4
}
}' 
fi

echo "set +x" 
echo "echo"                                  
echo "echo Fin de la log" 
echo "echo -------------" 
echo "}" 
echo 


echo "echo Debut de la mise a jour" 
echo "echo -----------------------" 
echo "funcmaj 2>&1 | tee majstatv5.log" 
echo "echo Fin de la mise a jour" 
echo "echo ---------------------" 
echo "echo" 
echo 'echo "Voulez vous consultez la log majstatv5.log ? (Entrer ou Ctrl+c)"' 
echo "read a" 
echo "more  majstatv5.log"

}

if [ $filtre_avenir -gt 0 ] ; then
	genere $* >> majstatv5_0.ksh
#----- Desactivation des vtaddjob pour les applications a venir"
	fgrep -v -f apps_avenir.txt majstatv5_0.ksh > majstatv5.ksh
else
	genere $* >> majstatv5.ksh
fi

chmod a+x majstatv5.ksh 
echo
echo "Generation terminee"
echo "-------------------"
echo "Une fois effectues le timport et le treset des dates,"
echo "vous pouvez lancer majstatv5.ksh et consulter la log majstatv5.log"
echo

