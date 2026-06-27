############################################################################################

#La fonction suivante liste les jobs en start avec le qualifier donné par le script père suivi.sh et les renseigne dans un fichier de rapport
jobs_start(){
        autorep -J ALL |grep _ |grep RU |grep -v ^sb |awk '{print $1}' > tmp/final_start_jobs

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBS EN START ******* " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
        REPORT_START=`cat tmp/final_start_jobs`

        if [ ! "$REPORT_START" = "" ]
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
		test_jalon=`echo $1 |grep -i $nom_jalon"`
	
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
	autorep -J ALL |grep _ |grep FA |grep -v ^sb |awk '{print $1}' > tmp/final_abort_jobs

	echo " ************************* " >> report/$MYREPORT
	echo " *** JOBS EN ABORT ******* " >> report/$MYREPORT
	echo "" >>report/$MYREPORT
	REPORT_ABORT=`cat tmp/final_abort_jobs`
	
	if [ ! "$REPORT_ABORT" = "" ]
	then
		cat tmp/final_abort_jobs >> report/$MYREPORT
		ABORTS=y
	else
		echo "Il n'y a aucun job en abort pour le moment " >> report/$MYREPORT
		ABORTS=n
	fi 
	echo "" >> report/$MYREPORT
	echo "" >> report/$MYREPORT

}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


#La fonction suivante liste les jobs en hold avec le qualifier donné par le script père suivi.sh et les renseigne dans un fichier de rapport
jobs_hold(){
	autorep -J ALL |grep _ |grep OH |grep -v ^sb |awk '{print $1}' > tmp/final_hold_jobs

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBS EN HOLD ******* " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
	REPORT_HOLD=`cat tmp/final_hold_jobs`
               if [ ! "$REPORT_HOLD" = "" ]
        then
                cat tmp/final_hold_jobs >> report/$MYREPORT
               HOLDS=y
        else
                echo "Il n'y a aucun job en hold pour le moment " >> report/$MYREPORT
                HOLDS=n
        fi 
	echo "" >> report/$MYREPORT
        echo "" >> report/$MYREPORT
}
##============================================================================================================================================================================#####
##============================================================================================================================================================================#####


jobset_hold(){
        autorep -J ALL |grep -v _ |grep OH |awk '{print $1}' |grep -v ^sb |grep -v ^t > tmp/final_hold_jobset

        echo " ************************* " >> report/$MYREPORT
        echo " *** JOBSET EN HOLD ****** " >> report/$MYREPORT
        echo "" >>report/$MYREPORT
        REPORT_HOLDSET=`cat tmp/final_hold_jobset`
               if [ ! "$REPORT_HOLDSET" = "" ]
        then
                cat tmp/final_hold_jobset >> report/$MYREPORT
               HOLDSET=y
        else
                echo "Il n'y a aucun jobset en hold pour le moment " >> report/$MYREPORT
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
		JOBSETNAME=`echo $line`
        #Rajouter les dépendances ici
        mkdir -p tmp/dependances/$1/$JOBSETNAME 2>/dev/null
	
	job_depends -c -w -J $line |grep -p "Dependent Job Name" |sed '1,2d' |grep -v "______" | sed '$d'|sort -u |awk '{print $1}'> tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp

	SUCCESSORS=`cat tmp/dependances/$1/$JOBSETNAME/${JOBSETNAME}_dependances.tmp`
	if [ ! "$SUCCESSORS" = "" ]
        then
        while read line2
        do
                if  [ ! "$line" = "$line2" ]
                then
                        mkdir -p tmp/dependances/$1/$JOBSETNAME/$line2 2>/dev/null
                        verif_jalons $line2

                        if [ $? -eq 0 ]
                        then
			
                        chemin_jobset tmp/dependances/$1/$JOBSETNAME/$line2
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
set -x
echo "LE PARM 1 EST : $1"
LEVEL=`echo $1 |awk -F"/" '{print NF}'`
		JOBSET_CHEMIN=`echo $1 |awk -F '/' '{print $NF}' `
		
		job_depends -c -w -J $JOBSET_CHEMIN |grep -p "Dependent Job Name" |sed '1,2d' |grep -v "______" | sed '$d' |sort -u |awk '{print $1}'> $1/list_dependances.txt
		#echo "$1/list_dependances.txt"
		#cat $1/list_dependances.txt	
		SUCC_CHEMIN=`cat $1/list_dependances.txt`

		if [[ ! "$SUCC_CHEMIN" = ""  &&  $LEVEL -lt 13 ]]
		then
		while read line2
        	do
                	FOLDER_NAME_CHEMIN=`echo $line2 `
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
set -x
#On passera à cette fonction le fichier de rapport d'aborts ou de hold en fonction
#le paramètre 1 de la fonction est s'il s'agit d'abort ou de hold
	while read line
	do
		JOBNAME=`echo $line`
	#Rajouter les dépendances ici
	mkdir -p tmp/dependances/$1/$JOBNAME 2>/dev/null

			
	job_depends -c -w -J $JOBNAME |grep -p "Dependent Job Name" |sed '1,2d' |grep -v "______" | sed '$d' |sort -u |awk '{print $1}'> tmp/dependances/$1/$JOBNAME/${JOBNAME}_dependances.tmp

	SUCCESSORS=`cat tmp/dependances/$1/$JOBNAME/${JOBNAME}_dependances.tmp`
	if [ ! "$SUCCESSORS" = "" ]
	then
	while read line2
	do
		FOLDER_NAME=`echo $line2 `
			echo "LE NOM DU DOSSIER EST $FOLDER_NAME"
			mkdir -p tmp/dependances/$1/$JOBNAME/$FOLDER_NAME 2>/dev/null

			verif_jalons $FOLDER_NAME
		
			if [ $? -eq 0 ]
			then		
				chemin_jobset tmp/dependances/$1/$JOBNAME/$FOLDER_NAME 
			fi
			
	done < tmp/dependances/$1/$JOBNAME/${JOBNAME}_dependances.tmp
	else
		echo "le Job $JOBNAME n'a pas de successeurs"
	fi	
	rm -f tmp/dependances/$1/$JOBNAME/${JOBNAME}_dependances.tmp

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
	
