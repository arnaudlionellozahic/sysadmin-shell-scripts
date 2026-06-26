#!/usr/bin/perl
#===========================================================================================
#                                  vtom_dates_partagees.pl
#                                  -----------------------
#
# Controle des dates partagees             
#
# Usage : /u/perl/vtom_dates_partagees.pl  
#
#
# CREATION : 29/03/2010 D. QUIMERCH
#
# MODIFICATIONS :
# jj/mm/ssaa XX :                               
#===========================================================================================


#-------------------------------------------------------------------------------
#                                     FONCTIONS
#-------------------------------------------------------------------------------

#------------------
# Erreurs
#------------------
sub f_erreur {
	print "============================================================\n";
	print " ERREUR : $_[0]\n";
	print "============================================================\n";
	exit 4;
}


#-------------------------------------------------------------------------------
#                                    TRAITEMENT
#-------------------------------------------------------------------------------

# Affectation des variables
$FICTXT="/home/fcharbon/coopagri/vtom_dates_partagees.txt";
$FICSML="/home/fcharbon/coopagri/vtom_dates_partagees.sml";



# Date du jour
@ladate=localtime(time);
# Heure, minute, seconde
if ($ladate[2] < 10) {$lheure='0'.$ladate[2]} else {$lheure=$ladate[2]};
if ($ladate[1] < 10) {$laminute='0'.$ladate[1]} else {$laminute=$ladate[1]};
if ($ladate[0] < 10) {$laseconde='0'.$ladate[0]} else {$laseconde=$ladate[0]};
# Annee, mois, jour
$lannee=$ladate[5]+1900;
#$lannee=substr($lannee,2);
$lemois=$ladate[4]+1;
if ($lemois < 10) {$lemois='0'.$lemois};
if ($ladate[3] < 10) {$lejour='0'.$ladate[3]} else {$lejour=$ladate[3]};
$AMJ_HMS=$lannee.$lemois.$lejour."_".$lheure.$laminute.$laseconde;
$DAT_TRT="$lejour\/$lemois\/$lannee 08H00";


#------------------------------------
# Consultation de l'historique VTOM
#------------------------------------
$status=system("tlist env\/date >$FICTXT");
if ($status != 0) {&f_erreur("ERREUR tlist\n")};


#-----------------------------
# Chargement en tableau 
#-----------------------------
open(FICIN,"$FICTXT");
while (<FICIN>)
{

   chop;   
   # Remplacement du premier caractere espace par ";"
   s/ /\;/;
   # Suppression des caracteres espace
   s/ //g;
   
   ($environnement,$date,$reste)=split(/;/,$_);

   # Exclusion des environnements/applications 
   #$presence=0;
   #foreach $element (@ENV_PAS_A_TRAITER){if ($element eq $environnement) {$presence=1}};
   #next if ($presence==1);

   push(@DONNEES,$date.";".$environnement."\n");
   
}
close FICIN;


# Analyse des informations
$date_memo="";
foreach $ligne (sort @DONNEES)
{

   @Date_Env=split(/;/,$ligne);
   $date=$Date_Env[0];
   $environnement=$Date_Env[1];

   ($date_m,$env_m)=split(/;/,$date_memo);

   if ("$date" eq "$date_m") 
   {
      push(@DATES_PARTAGEES,"$date_memo");
      push(@DATES_PARTAGEES,"$ligne");
      push(@DATES_PARTAGEES,"");
   }
   $date_memo="$ligne";
}



#-----------------------------------
# Creation mailbox SML pour le PCP 
#-----------------------------------
if (@DATES_PARTAGEES != "")
{
   open(FICOT,">$FICSML");
   print FICOT "######SMI PCP;VTOM : Controle des dates d\'exploitation\n";
   print FICOT "                     Visual TOM : Controle des dates d\'exploitation\n\n";
   print FICOT "=================================================================================================\n\n"; 
   print FICOT " Liste des dates d\'exploitation partagees : \n";  
   print FICOT "\n\n";  
   print FICOT "             Dates                      Environnements\n";
   print FICOT "         -------------               ---------------------\n\n";  
   foreach $ligne (@DATES_PARTAGEES) 
   {
      @Date_Env=split(/;/,$ligne);
      $date=$Date_Env[0];
      $environnement=$Date_Env[1];
      print FICOT "         $date               $environnement\n";	
   }
   print FICOT " \n";
   close FICOT;

   print "Creation mailbox SML pour PCP\n";
#   $status=system("/u/prc/mbxcre.prc -mSML -f$FICSML -a180 -pVTOM");
   $status=system("ls");   
   if ($status != 0) {&f_erreur("ERREUR mbxcre PCP status=$status\n")};
}




exit 0;
