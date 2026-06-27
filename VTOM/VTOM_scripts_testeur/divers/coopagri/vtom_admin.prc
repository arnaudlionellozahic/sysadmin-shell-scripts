#!/bin/ksh
# @(#)#########################################################################
# @(#)# COMMANDE       vtom_admin.prc  
# @(#)#
# @(#)# FONCTION       Administration serveur et moteurs VTOM 
# @(#)#
# @(#)#                   
# @(#)# CREATION       11/01/2009 
# @(#)# AUTEUR         D. QUIMERCH
# @(#)#
# @(#)#
# @(#)# MODIFICATIONS :
# @(#)# JJ/MM/SSAA XX :                                         
# @(#)#
# @(#)#
# @(#)#########################################################################


#========================================================================
#                               FONCTIONS 
#========================================================================
erreur()
{
   DATESOS=`date '+%d/%m/%Y %Hh%Mm%Ss'`
#   NOMFIC=$GENMAN/$PROCED.sos
   NOMFIC=/home/fcharbon/coopagri/vtom_admin.txt
   cp /dev/null $NOMFIC
   echo "MACHINE = $MACHINE" >>$NOMFIC
   echo "NOMAPPLI = Visual TOM" >>$NOMFIC
   echo "CODEAPPLI = $APPLIC" >>$NOMFIC
   echo "PROCEDURE = $PROCED" >>$NOMFIC
   echo "DATE = $DATESOS" >>$NOMFIC
   echo "LIBERR = $LIBERR" >>$NOMFIC
   echo "COMPTE = vtom" >>$NOMFIC
   echo "CAUSE = inconnue" >>$NOMFIC
   echo "STATUS = 04" >>$NOMFIC
   echo "REFER = Pas de reference" >>$NOMFIC
   echo "ACTPUPIT =  Aucune" >>$NOMFIC
   echo "PERSJOUR = Groupe Technique" >>$NOMFIC
   echo "PERSNUIT = personne" >>$NOMFIC
   echo "CCMAIL = SMI PCP" >>$NOMFIC
   echo "CONSEQ = $CONSEQ " >>$NOMFIC
   echo "ENVPUPIT = N" >>$NOMFIC
   echo "FIN = fin" >>$NOMFIC
#    $GENPRC/mbxcre.prc -mSOS -f$NOMFIC -l"Visual TOM" -p$PROCED
}
         


#========================================================================
#                               TRAITEMENT 
#========================================================================

#------------------------------------------------------------
# Variables d'environnement
# Appel des variables generales
# et appel des variables specifiques de l'application
#------------------------------------------------------------
#. /u/default/envgen.env
# Declaration des variables obligatoires
APPLIC=180
SSAPPLIC=vtom
PROCED=`basename $0`
       

#------------------------------------------------------------
# Variables applicatives   
#------------------------------------------------------------
LOGVTPING="/home/fcharbon/coopagri/$PROCED.vtping$$"
LOGMOTEURS="/home/fcharbon/coopagri/$PROCED.moteurs$$"
FIC_MSG="$GENMAN/$PROCED.msg"
TEL_MSG="0684039600"
PARAMETRE=" Parametres : [start|stop|status|presence] [serveur|moteurs|all] [nom_moteur]"



#--------------------------
# Variables Nagios   
#--------------------------
ETAT_CRITICAL=2
ETAT_WARNING=1
ETAT_OK=0


#-------------------------------
# Controle des parametres                                
#-------------------------------
if test $# = 0  
then
   echo ""
   echo "$PARAMETRE"
   exit 4
fi
if test "$1" != "start" -a "$1" != "stop" -a "$1" != "status" -a "$1" != "presence"
then
   echo ""
   echo "$PARAMETRE"
   exit 4
fi
if test "$2" != "serveur" -a "$2" != "moteurs" -a "$2" != "all"
then
   echo ""
   echo "$PARAMETRE"
   exit 4
fi
ACTION="$1"
SM="$2"
test "$3" != "" && MOTEUR="$3"


#----------------
# Status                   
#----------------
if test "$ACTION" = "status"
then
   
   # vtping 
   vtping > $LOGVTPING
   
   # Serveur                  
   if test "$SM" = "serveur" -o "$SM" = "all"
   then
      test_serveur="OK"
      liste_KO=""
      for process in vtsgbd vtserver vtnotifier vtlicense dserver gserver pserver 
      do
         grep $process $LOGVTPING|grep actif >/dev/null 2>&1  
         if test $? -ne 0
         then
            liste_KO="$liste_KO $process"
            test_serveur="KO"
         fi
      done
      if test "$MOTEUR" = "nagios"
      then
         if test "$test_serveur" != "OK"
         then
            echo "VTOM : Alerte serveur HS" >$FIC_MSG
#            $GENPRC/mbxcre.prc -mMSG -f$FIC_MSG -a180 -pVTOM -l"ADRMAIL=$TEL_MSG"
  
            echo "CRITICAL - process $liste_KO inactif"
            exit $ETAT_CRITICAL
         else
            if test "$SM" = "serveur"
            then
               echo "Tous les process serveur sont actifs"
               exit $ETAT_OK 
            fi
         fi
      else
         if test "$test_serveur" != "OK"
         then
            echo "CRITICAL - process $liste_KO inactif"
            exit 4
         else
            echo "Tous les process serveur sont actifs"
         fi
      fi 
   fi

   # Moteurs
   if test "$SM" = "moteurs" -o "$SM" = "all"
   then
      test_moteur="OK" 
      liste_KO=""
      liste_ko=""
      grep tengine $LOGVTPING > $LOGMOTEURS
      cat $LOGMOTEURS|while read tengine moteur etat suite
      do
         if test "$etat" != "actif"
         then
            if test "$moteur" = "APPLIS_METIER" -o "$moteur" = "SRV_AIX_UTIL" -o "$moteur" = "SRV_LIN_UTIL" -o "$moteur" = "SRV_WIN_UTIL"
            then
               test_moteur="KO"
               liste_KO="$liste_KO $moteur"
            elif test "$moteur" = "VTOM_EXPLOIT"
            then
               test_moteur="ko"
               liste_ko="$liste_ko $moteur"
            fi 
         fi
      done
      if test "$MOTEUR" = "nagios"
      then
         if test "$test_moteur" = "OK"
         then
            if test "$SM" = "all"
            then 
               echo "Tous les services et moteurs sont actifs"
            else
               echo "Tous les moteurs sont actifs"
            fi
            exit $ETAT_OK
         fi
         if test "$test_moteur" = "ko" 
         then
            echo "WARNING - moteur $liste_ko arrete"
            exit $ETAT_WARNING
         fi
         if test "$test_moteur" = "KO"
         then
            echo "VTOM : Alerte moteurs HS" >$FIC_MSG
#            $GENPRC/mbxcre.prc -mMSG -f$FIC_MSG -a180 -pVTOM -l"ADRMAIL=$TEL_MSG"
            echo "CRITICAL - moteur $liste_KO arrete"
            exit $ETAT_CRITICAL
         fi
      else
         if test "$test_moteur" = "OK"
         then
            if test "$SM" = "all"
            then 
               echo "Tous les services et moteurs sont OK"
            else
               echo "Tous les moteurs sont OK"
            fi
            exit 0
         fi
         if test "$test_moteur" = "ko" 
         then
            echo "WARNING - moteur $liste_ko arrete"
            exit 2
         fi
         if test "$test_moteur" = "KO"
         then
            echo "CRITICAL - moteur $liste_KO arrete"
            exit 4
         fi
      fi
   fi
fi


#----------------
# Presence                 
#----------------
if test "$ACTION" = "presence"
then
   # Moteurs
   if test "$SM" = "moteurs"
   then
      for MOTEUR in VTOM_EXPLOIT APPLIS_CALIDIS APPLIS_SINA APPLIS_GENERAL APPLIS_METIER APPLIS_TEST APPLIS_UTIL SRV_AIX_UTIL SRV_LIN_UTIL SRV_WIN_UTIL
      do
         # Recherche du process tengine
         ps -aef|grep tengine|grep $MOTEUR
         if test $? -ne 0
         then 
            # Attente 60s, puis test du process
            sleep 60 
            ps -aef|grep tengine|grep $MOTEUR
            if test $? -ne 0
            then 
               LOG_MOTEUR="/home/fcharbon/coopagri/presence_moteurs.log"
               echo "Moteur $MOTEUR inactif" >> $LOG_MOTEUR
               echo "Relance automatique a `date '+%d/%m/%Y %Hh%Mm%Ss'`"  >> $LOG_MOTEUR
               estart $MOTEUR
               if test $? -ne 0
               then
                  echo "Erreur start moteur $MOTEUR" >> $LOG_MOTEUR
                  exit 4
               fi
            fi
         fi 
      done
   fi
fi


#-------------------------------
# Stop
#-------------------------------
if test "$ACTION" = "stop"
then

   # Arret client 
   if test "$SM" = "client" -o "$SM" = "all"
   then
      stop_client
      if test $? -ne 0
      then
         echo "Erreur stop client"
      fi
   fi
   
   # Arret moteurs
   # NB : l'arret des moteurs est indispensable avant l'arret du serveur
   # L'arret d'un moteur peut-etre tres long (>2')
   if test "$SM" = "serveur" -o "$SM" = "moteurs" -o "$SM" = "all"
   then
      tlist env | while read moteur suite
      do
         if test "$MOTEUR" != ""
         then
            if test "$moteur" = "$MOTEUR" 
            then 
               estop "$moteur"  
               sleep 2
            fi 
         else
            estop "$moteur"
            sleep 2
         fi 
      

         # Verification de l'arret
         boucle=0  
         while true
         do
            sleep 2
            vtping|grep tengine|grep "$moteur"|grep arrete
            test $? = 0 && break
            boucle=`expr $boucle + 1` 
            if test $boucle -gt 70
            then
               echo "PB arret moteur $moteur"
               echo "VTOM : Erreur arret moteur $moteur" >$FIC_MSG
#               $GENPRC/mbxcre.prc -mMSG -f$FIC_MSG -a180 -pVTOM -l"ADRMAIL=$TEL_MSG"
               break 
            fi
            #estop "$moteur"
         done

      done
   fi
   
   # Arret serveur
   if test "$SM" = "serveur" -o "$SM" = "all"
   then
      # Kill du process sssecure avant l'arret des services
      pid=`ps -aef|grep sssecure|grep -v grep|awk '{print $2}'`
      if test "$pid" -ne ""
      then
         kill -9 $pid
      fi
      sleep 2
      stop_servers
   fi
fi


#-------------------------------
# Start
#-------------------------------
if test "$ACTION" = "start"
then

   # Pas de demarrage si presence du drapeau d'arret
   DRP="/home/fcharbon/coopagri/vtom_arret.drp"
   test -f "$DRP" && exit 0

   # Demarrage serveur
   # Recherche du texte "vtserver ready" dans la log
   # exit 4 si pas trouve 
   if test "$SM" = "serveur" -o "$SM" = "all"
   then
      # 21/05/2010 : lancement en mode securise
      #start_servers 
      nohup sssecure >>$TOM_HOME/serveurs.log 2>&1 &


      # Attente du message "vtserver ready"
      boucle=0  
      while true
      do
         sleep 2
         tail -10 $TOM_HOME/serveurs.log|grep "vtserver ready" 
         test $? = 0 && break
         boucle=`expr $boucle + 1` 
         if test $boucle -gt 60
         then
            echo "PB demarrage serveur"
            echo "VTOM : Alerte moteurs HS" >$FIC_MSG
#            $GENPRC/mbxcre.prc -mMSG -f$FIC_MSG -a180 -pVTOM -l"ADRMAIL=$TEL_MSG"
            break
         fi
      done

      # Attente du retour de la commande vtping
      boucle=0  
      while true
      do
         sleep 2
         vtping|grep tengine 
         test $? = 0 && break
         boucle=`expr $boucle + 1` 
         if test $boucle -gt 60
         then
            echo "PB demarrage serveur"
            echo "VTOM : Alerte moteurs HS" >$FIC_MSG
#            $GENPRC/mbxcre.prc -mMSG -f$FIC_MSG -a180 -pVTOM -l"ADRMAIL=$TEL_MSG"
         fi
      done
   fi
  

  # Affectation du nom du serveur vtom_serveur
  # vtaddmach /machine vtom_serveur /nom_reel $MACHINE
  # if test $? -ne 0
  # then
  #    echo "Erreur vtaddmach $MACHINE"
  #    exit 4
  # fi

 
   # Demarrage  moteurs
   sleep 2
   if test "$SM" = "moteurs" -o "$SM" = "all"
   then
      #tlist env | while read moteur suite
      for MOTEUR in VTOM_EXPLOIT APPLIS_CALIDIS APPLIS_SINA APPLIS_GENERAL APPLIS_METIER APPLIS_SINA APPLIS_TEST APPLIS_UTIL SRV_AIX_UTIL SRV_LIN_UTIL SRV_WIN_UTIL
      do
         #if test "$MOTEUR" != ""
         #then
         #   if test "$moteur" = "$MOTEUR" 
         #   then 
         #      estart "$moteur"  
         #      sleep 2
         #   fi 
         #else
         #   estart "$moteur"  
         #   sleep 2
         #fi
         estart $MOTEUR
         if test $? -ne 0
         then
            echo "Erreur start moteur $moteur"
         fi
      done
   fi
   
   # Demarrage client 
   if test "$SM" = "client" -o "$SM" = "all"
   then
      start_client
      if test $? -ne 0
      then
         echo "Erreur start client"
         exit 4
      fi
   fi
 
fi

