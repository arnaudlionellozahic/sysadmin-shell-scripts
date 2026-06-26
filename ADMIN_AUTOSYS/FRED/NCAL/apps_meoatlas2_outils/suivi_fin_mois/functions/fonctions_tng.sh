########################### Récupération de la valeur de l'autoscan  #########################
## Si le script est alors qu'on est proche de l'autoscan, rien ne sera fait ##################

HEURE_MIN_DEC=`echo "(((($CAISCHD0011*3600)+(0*60))-(15*60))/3600)" |bc -l`
HEURE_MAX_DEC=`echo "(((($CAISCHD0011*3600)+(0*60))+(15*60))/3600)" |bc -l`


############################################
HEURE_MIN_H=`echo $HEURE_MIN_DEC |awk -F "." '{print $1}'| xargs printf '%02d'`
HEURE_MIN_M=`echo $HEURE_MIN_DEC |awk -F "." '{print "0."$2}'`
HEURE_MIN_M=`echo "$HEURE_MIN_M * 60 " |bc|xargs printf '%.0f\n'| xargs printf '%02d'`
############################################
HEURE_MAX_H=`echo $HEURE_MAX_DEC |awk -F "." '{print $1}'| xargs printf '%02d'`
HEURE_MAX_M=`echo $HEURE_MAX_DEC |awk -F "." '{print "0."$2}'`
HEURE_MAX_M=`echo "$HEURE_MAX_M * 60 " |bc|xargs printf '%.0f\n'| xargs printf '%02d'`
############################################


HEURE_MAX=$HEURE_MAX_H:$HEURE_MAX_M
HEURE_MIN=$HEURE_MIN_H:$HEURE_MIN_M

MYDATE=`date +"%H:%M"`

if [[ "$MYDATE" > "$HEURE_MIN" && "$MYDATE" < "$HEURE_MAX" ]]
then

	echo "ATTENTION! L'autoscan est à ${CAISCHD0011}h00 et il est $MYDATE"
	echo "Par précaution, merci d'attendre $HEURE_MAX avant de relancer le script de vérification"
	exit 10
fi

########################### Récupération du qualifier de fin de mois #########################
####### Le script va proposer automatiquement un qualifier de JOB !! basé sur la date du jour.
####### Si cela n'est pas satisfaisant, l'utilisateur peut rentrer un qualifier de son choix#

QUALIFIER=`date +"%d"`01

choix_qualifier(){
	echo "Qualifier du jour pour les JOBS : $QUALIFIER"
	echo "Voulez-vous utiliser ce qualifier pour la génération du rapport? (y/n)"
	read ANSWER

	case $ANSWER in 
		y)
			QUALIFIER_JS=`echo $QUALIFIER |sed -e 's/[0-9]$/0/g'`;;
		n)
			echo "Veuillez rentrer un qualifier de votre choix (4 chiffres)"
			echo "ATTENTION!!! Il s'agit ici d'un qualifier pour Jobs (généralement se terminant par 1) et non pour jobsets"
			read MYQUALIFIER
			
			TEST_MYQUAL=`echo $MYQUALIFIER |egrep '^[0-9]{4}$'`
			if [ "$TEST_MYQUAL" = "" ]
			then
				echo "Votre qualifier n'est pas valide. Merci de rentrer un qualifier correct: 4 chiffres"
				choix_qualifier
			else
				QUALIFIER_JS=`echo $MYQUALIFIER |sed -e 's/[0-9]$/0/g'`
				QUALIFIER=$MYQUALIFIER
			fi;;


			
		*)
			echo "Veuillez répondre par y ou n (Yes ou No) à la question..."
			choix_qualifier;;
	esac

}

choix_qualifier
############################################################################################

#La fonction suivante liste les jobs en start avec le qualifier donné par le script père suivi.sh et les renseigne dans un fichier de rapport
jobs_start(){
        cautil select tjob id=*,*,* runstat=START qual=$QUALIFIER list 2> tmp/start_jobs |grep -E "Jobset:|Job:|Status|Jno:" |grep -vE  "Ac|Calendar"  |awk 'NR%3{printf "%s",$0;next;}1' |awk '{print $2";"$4";"$8}' > tmp/final_start_jobs
        rm tmp/start_jobs

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBS EN START ******* " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
        REPORT_START=`cat tmp/final_start_jobs`

        if [ ! "$REPORT_START" = "Job:;Qualifier:;" ]
        then
                cat tmp/final_start_jobs >> report/$MYREPORT
        else
                echo "Il n'y a aucun job en abort pour le moment pour le qualifier $QUALIFIER" >> report/$MYREPORT
				echo " 1/ Si tous les jalons sont terminés, PAS DE PROBLEME. Merci de vérifier avec le qualifier du jour (pour rappel le Qualifier est $QUALIFIER )" >> report/$MYREPORT
				echo " 2/ Si certains jalons ne sont pas terminés, PROBLEMES!!!!! Checker les jobs/jobsets en hold avec déclenchement de trigger et les jobsets en WPRED avec triggers" >> report/$MYREPORT
        fi
        echo "" >> report/$MYREPORT
        echo "" >> report/$MYREPORT

}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####

#La fonction suivante permet de checker les jalons dans le calcul de la dépendance.

verif_jalons(){
	while read line
	do
		nom_jalon=`echo $line |awk -F ";" '{print $1}'`
		test_jalon=`echo $1 |grep $nom_jalon"`
	
		if [ ! $test_jalon = "" ]
		then
			return 1
		fi
	done < conf/jalons.txt

	return 0
	
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####

#La fonction suivante liste les jobs en abort avec le qualifier donné par le script père suivi.sh et les renseigne dans un fichier de rapport
jobs_abort(){
	cautil select tjob id=*,*,* runstat=ABORT qual=$QUALIFIER list 2> tmp/abort_jobs |grep -E "Jobset:|Job:|Status|Jno:" |grep -vE  "Ac|Calendar"  |awk 'NR%3{printf "%s",$0;next;}1' |awk '{print $2";"$4";"$8}' > tmp/final_abort_jobs
	rm tmp/abort_jobs

	echo " ************************* " >> report/$MYREPORT
	echo " *** JOBS EN ABORT ******* " >> report/$MYREPORT
	echo "" >>report/$MYREPORT
	REPORT_ABORT=`cat tmp/final_abort_jobs`
	
	if [ ! "$REPORT_ABORT" = "Job:;Qualifier:;" ]
	then
		cat tmp/final_abort_jobs >> report/$MYREPORT
		ABORTS=y
	else
		echo "Il n'y a aucun job en abort pour le moment pour le qualifier $QUALIFIER" >> report/$MYREPORT
		ABORTS=n
	fi 
	echo "" >> report/$MYREPORT
	echo "" >> report/$MYREPORT

}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


#La fonction suivante liste les jobs en hold avec le qualifier donné par le script père suivi.sh et les renseigne dans un fichier de rapport
jobs_hold(){
	cautil select tjob id=*,*,* runstat=OPHELD qual=$QUALIFIER list 2> tmp/hold_jobs |grep -E "Jobset:|Job:|Status|Jno:" |grep -vE  "Ac|Calendar"  |awk 'NR%3{printf "%s",$0;next;}1' |awk '{print $2";"$4";"$8}' > tmp/final_hold_jobs
        rm tmp/hold_jobs

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBS EN HOLD ******* " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
	REPORT_HOLD=`cat tmp/final_hold_jobs`
               if [ ! "$REPORT_HOLD" = "Job:;Qualifier:;" ]
        then
                cat tmp/final_hold_jobs >> report/$MYREPORT
               HOLDS=y
        else
                echo "Il n'y a aucun job en hold pour le moment pour le qualifier $QUALIFIER" >> report/$MYREPORT
                HOLDS=n
        fi 
	echo "" >> report/$MYREPORT
        echo "" >> report/$MYREPORT
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


jobset_hold(){
        cautil select tjobset id=* runstat=OPHELD qual=$QUALIFIER_JS list 2> tmp/hold_jobset |grep -E "Jobset:|Qual" | awk 'NR%2{printf "%s",$0;next;}1'| awk '{print $2";"$4}' > tmp/final_hold_jobset
        rm tmp/hold_jobset

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBSET EN HOLD ****** " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
        REPORT_HOLDSET=`cat tmp/final_hold_jobset`
               if [ ! "$REPORT_HOLDSET" = "Qualifier:;Original" ]
        then
                cat tmp/final_hold_jobset >> report/$MYREPORT
               HOLDSET=y
        else
                echo "Il n'y a aucun jobset en hold pour le moment pour le qualifier $QUALIFIER" >> report/$MYREPORT
                HOLDSET=n
        fi
        echo "" >> report/$MYREPORT
        echo "" >> report/$MYREPORT

}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


jobset_successors(){
        while read line
        do
                JOBSETNAME=`echo $line |awk -F ';' '{print $1}'`
                QUAL=`echo $line |awk -F ';' '{print $2}'`

        #Rajouter les dépendances ici
        mkdir -p tmp/dependances/$1/$JOBSETNAME 2>/dev/null
	
	cautil sel tjobsetpred pset=$JOBSETNAME pjob=$JOBNAME qual=$QUAL li 2>/dev/null|grep -E "Jobset|Job No" |grep -v Predecessor |awk 'NR%2{printf "%s",$0;next;}1'|awk '{print $2";"$NF}' |sort -u > tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp

	SUCCESSORS=`cat tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp`
	if [ ! "$SUCCESSORS" = "Job;Qual:" ]
        then
        while read line2
        do
                FOLDER_NAME=`echo $line2 |awk -F ';' '{print $1"_"$2}'`
                if  [ ! "$FOLDER_NAME" = ${JOBSETNAME}_${QUAL} ]
                then
                        mkdir -p tmp/dependances/$1/$JOBSETNAME/$FOLDER_NAME 2>/dev/null
                        verif_jalons $FOLDER_NAME

                        if [ $? -eq 0 ]
                        then
			
                        chemin_jobset tmp/dependances/$1/$JOBSETNAME/$FOLDER_NAME 
			fi
                fi
        done < tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp
        else
                echo "le Jobset $JOBSETNAME n'a pas de successeurs"
        fi
        rm -f tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp

        done < $2
        rm -rf $2
	
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


#Il s'agit ici d'une fonction récursive qui permet de remonter le chemin d'un abort pour vérifier si il est sur le chemin critique
chemin_jobset(){
LEVEL=`echo $1 |awk -F"/" '{print NF}'`
		JOBSET_CHEMIN=`echo $1 |awk -F '/' '{print $NF}' |awk -F '_' '{print $1}'`
		QUAL_CHEMIN=`echo $1 |awk -F '_' '{print $NF}'|sed -e 's/[0-9]$/0/g'`			
		cautil sel tjobsetpred pset=$JOBSET_CHEMIN qual=$QUAL_CHEMIN li 2>/dev/null |grep -E "Jobset|Job No" |grep -v Predecessor |awk 'NR%2{printf "%s",$0;next;}1'|awk '{print $2";"$NF}' |sort -u > $1/list_dependances.txt
		#echo "$1/list_dependances.txt"
		#cat $1/list_dependances.txt	
		SUCC_CHEMIN=`cat $1/list_dependances.txt`

		if [[ ! "$SUCC_CHEMIN" = "Job;Qual:"  &&  $LEVEL -lt 13 ]]
		then
		while read line2
        	do
                	FOLDER_NAME_CHEMIN=`echo $line2 |awk -F ';' '{print $1"_"$2}'`
                	mkdir -p $1/$FOLDER_NAME_CHEMIN 2>/dev/null

                        verif_jalons $FOLDER_NAME_CHEMIN

                        if [ $? -eq 0 ]
                        then
				chemin_jobset $1/$FOLDER_NAME_CHEMIN 
			fi

        	done < $1/list_dependances.txt
		rm -f $1/list_dependances.txt	
		fi
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


#La fonction suivante donne les successeurs des jobs en ABORT et en HOLD afin de vérifier si sur le chemin critique
jobs_successors(){
#On passera à cette fonction le fichier de rapport d'aborts ou de hold en fonction
#le paramètre 1 de la fonction est s'il s'agit d'abort ou de hold
	while read line
	do
		JOBSETNAME=`echo $line |awk -F ';' '{print $1}'`
			JOBNAME=`echo $line |awk -F ';' '{print $2}'`
		QUAL=`echo $line |awk -F ';' '{print $3}'`

	#Rajouter les dépendances ici
	mkdir -p tmp/dependances/$1/$JOBSETNAME 2>/dev/null

			
	cautil sel tjobpred pset=$JOBSETNAME pjob=$JOBNAME qual=$QUAL li 2>/dev/null|grep -E "Jobset|Job No" |grep -v Predecessor |awk 'NR%2{printf "%s",$0;next;}1'|awk '{print $2";"$NF}' |sort -u > tmp/dependances/$1/$JOBSETNAME/${JOBNAME}_dependances.tmp

	mkdir -p tmp/dependances/$1/$JOBSETNAME/$JOBNAME 2>/dev/null
	SUCCESSORS=`cat tmp/dependances/$1/$JOBSETNAME/${JOBNAME}_dependances.tmp`
	if [ ! "$SUCCESSORS" = "Job;Qual:" ]
	then
	while read line2
	do
		FOLDER_NAME=`echo $line2 |awk -F ';' '{print $1"_"$2}'`
			mkdir -p tmp/dependances/$1/$JOBSETNAME/$JOBNAME/$FOLDER_NAME 2>/dev/null

			verif_jalons $FOLDER_NAME
		
			if [ $? -eq 0 ]
			then		
				chemin_jobset tmp/dependances/$1/$JOBSETNAME/$JOBNAME/$FOLDER_NAME 
			fi
			
	done < tmp/dependances/$1/$JOBSETNAME/${JOBNAME}_dependances.tmp
	else
		echo "le Job $JOBNAME n'a pas de successeurs"
	fi	
	rm -f tmp/dependances/$1/$JOBSETNAME/${JOBNAME}_dependances.tmp

	done < $2 
	rm -rf $2	
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


#La fonction suivante va effectuer les vérifications sur les jalons de la fin de mois.
#il va checker si pas de blocage par rapport aux aborts ou aux Holds
#Il va également checker les temps
check_jalons() {
	while read line
	do
		JOBSET_NAME=`echo $line |awk -F ';' '{print $1}'`
		JOB_NAME=`echo $line |awk -F ';' '{print $2}'`
		CAUTIL_JOBSET=`cautil sel tjobset id=$JOBSET_NAME qual=$QUALIFIER_JS li 2>/dev/null|grep -E "Jobset:|Run Status|End:" |awk 'NR%3{printf "%s",$0;next;}1'| awk '{print $2";"$5";"$12"_"$13}'`
		CAUTIL_JOB=`cautil sel tjob id=$JOBSET_NAME,$JOB_NAME,* qual=$QUALIFIER li 2>/dev/null |grep -E "Jobset:|Job:|Run Status|End:" |grep -v "Actual" |sed '$d' |awk 'NR%4{printf "%s",$0;next;}1' | awk '{print $2";"$4";"$7";"$17"_"$18}'`

		if [ ! "$CAUTIL_JOBSET" = "Run;Start:;_" ]
		then
			STATUS_JOBSET=`echo $CAUTIL_JOBSET |awk -F ';' '{print $2}'`
			STATUS_JOB=`echo $CAUTIL_JOB |awk -F ';' '{print $3}'`
		else	
			DATE=`date +"%Y %m %d"`
			DATE_YESTERDAY=`functions/datecalc.sh -a $DATE - 1 |awk '{print $3" "$2" "$1}'`

			MONTH=`echo $DATE_YESTERDAY |awk '{print $2}'`
			DAY=`echo $DATE_YESTERDAY |awk '{print $1}'`
			YEAR=`echo $DATE_YESTERDAY |awk '{print $3}'`

			if [ $MONTH -lt 10 ]
			then
				MONTH="0${MONTH}"
			fi

			if [ $DAY -lt 10 ]
			then
				DAY="0${DAY}"
			fi
			
			DATE_YESTERDAY="${DAY}-${MONTH}-${YEAR}"
			if [[ ! -e tmp/myconlog.txt ]]
			then
				cautil sel conlog start=$DATE_YESTERDAY li conlog > tmp/myconlog.txt
			fi

			if [[ ! -e tmp/myconlog_today.txt ]]
                        then
                                cautil sel conlog li conlog > tmp/myconlog_today.txt
                        fi

			STATUS_JOBSET=`grep $JOBSET_NAME tmp/myconlog.txt |grep $QUALIFIER_JS |tail -1` #|awk '{print $8}'`
			STATUS_JOB=`grep $JOBSET_NAME tmp/myconlog.txt |grep $JOB_NAME |grep $QUALIFIER |tail -1` #|awk '{print $10}'`

			TEST_CONLOG_JS=`echo $STATUS_JOBSET |grep "added to workload"`

			if [ ! "$TEST_CONLOG_JS" = "" ]
			then
				STATUS_JOBSET=`grep $JOBSET_NAME tmp/myconlog_today.txt |grep $QUALIFIER_JS |grep -v "Purged" |tail -1 |awk '{print $8}'`
				STATUS_JOB=`grep $JOBSET_NAME tmp/myconlog_today.txt |grep $JOB_NAME |grep $QUALIFIER |grep -v "Purged"|tail -1 |awk '{print $10}'`
			else
				STATUS_JOBSET=`grep $JOBSET_NAME tmp/myconlog.txt |grep $QUALIFIER_JS |tail -1 |awk '{print $8}'`
				STATUS_JOB=`grep $JOBSET_NAME tmp/myconlog.txt |grep $JOB_NAME |grep $QUALIFIER |tail -1 |awk '{print $10}'` 
			fi

			case $STATUS_JOBSET in
				Completed )
					STATUS_JOBSET="COMPL" 
					OLD_JOBSET=y ;;
				Aborted )
					STATUS_JOBSET="ABORT" ;;
				Purged )
					STATUS_JOBSET="PURGED" ;;
				* )
					STATUS_JOBSET="UNDEF" ;;
			esac

                        case $STATUS_JOB in
                                Completed )
                                        STATUS_JOB="COMPL"
					OLD_JOB=y;;
                                Aborted )
                                        STATUS_JOB="ABORT" ;;
                                Purged )
                                        STATUS_JOB="PURGED" ;;
                                * )
                                        STATUS_JOB="UNDEF" ;;
                        esac

		fi

		if [ "$STATUS_JOBSET" = "WPRED" ]
		then	
			find tmp/dependances/ -name *${JOBSET_NAME}* > tmp/blocage_jalons_${JOBSET_NAME}
			SEARCH_BLOCAGE=`cat tmp/blocage_jalons_${JOBSET_NAME}`
			
			if [ ! "$SEARCH_BLOCAGE" = "" ]
			then
				echo " JALON : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
				echo " Il y a des blocages pour ce jalon!!! Vérifier les lignes ci-dessous au tracking" >> report/$MYREPORT
				cat tmp/blocage_jalons_${JOBSET_NAME} |awk -F '/' '{print $4"_"$5  "    STATUT:"$3}' |sort -u >> report/$MYREPORT
			else
				echo " JALON : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
				echo " Pas de blocage détecté dans le tracking actuel. Mensuel en cours..." >> report/$MYREPORT
			fi		

		elif [ "$STATUS_JOBSET" = "START" ]
		then
			if [ "$STATUS_JOB"  = "WPRED" ]
			then
				echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
				echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB" >> report/$MYREPORT
				find tmp/dependances/ -name *${JOB_NAME}* > tmp/blocage_jalons_${JOB_NAME}
				SEARCH_BLOCAGE=`cat tmp/blocage_jalons_${JOB_NAME}`

				if [ ! "$SEARCH_BLOCAGE" = "" ]
				then
					echo " Il y a des blocages pour ce jalon!!! Vérifier les lignes ci-dessous au tracking" >> report/$MYREPORT
					 cat tmp/blocage_jalons_${JOB_NAME} |awk -F '/' '{print $4"_"$5  "    STATUT:"$3}' |sort -u >> report/$MYREPORT
				else
					echo " Pas de blocage détecté dans le tracking actuel. Mensuel en cours..." >> report/$MYREPORT
				fi
			elif [ "$STATUS_JOB"  = "START" ]
			then
                                echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
                                echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB" >> report/$MYREPORT
				echo " Le Jalon est en Cours." >> report/$MYREPORT
			elif [ "$STATUS_JOB"  = "COMPL" ]
			then
                                echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
                                echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB" >> report/$MYREPORT
				echo " le Jalon est terminé avec SUCCES - HEURE DE FIN: `echo $CAUTIL_JOB |awk -F ';' '{print $4}'`"
			elif [ "$STATUS_JOB"  = "ABORT" ]
			then
                                echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
                                echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB" >> report/$MYREPORT
				echo " /!\ ATTENTION /!\ : Le Jalon est EN ABORT!!! Merci de faire le nécessaire!!!!!!! " >> report/$MYREPORT
			else
                                echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET" >> report/$MYREPORT
                                echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB" >> report/$MYREPORT
				echo " Le job est dans un état $STATUS_JOB . Merci de vérifier si tout va bien" >> report/$MYREPORT
			fi
		elif [ "$STATUS_JOBSET" = "COMPL" ]
		then
			if [[ "$OLD_JOB" = "y" && "$OLD_JOBSET" = "y" ]]
			then
				echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET  HEURE_FIN_JOBSET : `grep $JOBSET_NAME tmp/myconlog.txt |tail -1| awk '{print $1"_"$2}'`" >> report/$MYREPORT
				echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB  HEURE_FIN_JOB: `grep $JOBSET_NAME tmp/myconlog.txt |grep $JOB_NAME |tail -1|awk '{print $1"_"$2}'`" >> report/$MYREPORT
			else
				echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET  HEURE_FIN_JOBSET : `echo $CAUTIL_JOBSET |awk -F ';' '{print $3}'`" >> report/$MYREPORT
				echo " JALON_JOB : $JOB_NAME STATUT : $STATUS_JOB  HEURE_FIN_JOB: `echo $CAUTIL_JOB|awk -F ';' '{print $4}'`" >> report/$MYREPORT
			fi
			echo " Le Jobset Entier est terminé!" >> report/$MYREPORT
		else
			echo " JALON_JOBSET : $JOBSET_NAME STATUT : $STATUS_JOBSET " >> report/$MYREPORT
			echo " Le jobset est dans un état $STATUS_JOBSET . Merci de vérifier si tout va bien" >> report/$MYREPORT
		fi	
			
				
		echo "      ==========================================================================     " >> report/$MYREPORT
		echo "      ==========================================================================     " >> report/$MYREPORT	
				
			
			
	done < $FIC_JALONS
}
	
