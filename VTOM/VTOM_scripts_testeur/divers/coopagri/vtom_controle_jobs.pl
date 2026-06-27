#!/usr/bin/perl
#===========================================================================================
#                                  vtom_controle_jobs.pl
#                                  ---------------------
#
# Controle de l'execution de traitements 
# Liste des traitements en erreur                  
#
# Usage : /u/perl/vtom_controle_jobs.pl Date_hier Date_Aujourdhui 
#
# Renseigner les tableaux internes 
#            @ENV_PAS_A_TRAITER
#            @ENV_PAS_AUX_ETUDES
#            @APP_PAS_AUX_ETUDES
#
# CREATION : 02/02/2010 D. QUIMERCH
#
# MODIFICATIONS :
# 05/10/2010 DQ : gestion des aborts pour lesquels il ne faut pas créer de fiche de reprise                              
#                 traitements à stocker dans le fichier parametre 
#                 /a/vtom/fic/vtom_ctl_execution_sans_reprise.dta                            
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

#------------------
# Tri
#------------------

sub f_tri 
{
# Tri sur le champ 1 (environnement) puis sur le champ 2 (date d'execution)
($v101,$v102,$v103,$v104,$v105,$v106,$v107,$v108,$v109,$v110,$v111)=split (/;/,$a) ;
($v201,$v202,$v203,$v204,$v205,$v206,$v207,$v208,$v209,$v210,$v211)=split (/;/,$b) ;

$v101 cmp $v201 || $v110 cmp $v210; 
}


#-------------------------------------------------------------------------------
#                                    TRAITEMENT
#-------------------------------------------------------------------------------
# Affectation des variables
use File::Copy;

# Affectation des variables
$FICPARAM="/home/fcharbon/coopagri/pcp_jobs_abort.env";
$FICABT="/home/fcharbon/coopagri/pcp_jobs_abort.dta";
$FICSML="/home/fcharbon/coopagri/vtom_controle_jobs.sml";
$FICCKL="/home/fcharbon/coopagri/vtom_controle_jobs.ckl";
$FICSTR="/home/fcharbon/coopagri/vtom_strategiques.dta";
$FICJOB="/home/fcharbon/coopagri/vtom_ctl_execution.dta";
$FICJOK="/home/fcharbon/coopagri/vtom_ctl_execution_sans_reprise.dta";
$FICSTA="/home/fcharbon/coopagri/vtom_controle_jobs.txt";


# Les tableaux
@ENV_PAS_A_TRAITER=(VTOM_BAC_A_SABLE);
@ENV_PAS_AUX_ETUDES=(APPLIS_GENERAL,APPLIS_UTIL,SRV_AIX_UTIL,SRV_LIN_UTIL,SRV_WIN_UTIL,SRV_UTIL,VTOM_EXPLOIT);
@APP_PAS_AUX_ETUDES=("U_999");


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

# Recuperation des parametres
if($ARGV[0] ne "")
{
   $Hier = $ARGV[O];
   $Aujourdhui = $ARGV[1];
}
else
{
   die("Syntaxe : /home/fcharbon/coopagri/vtom_en_erreur.pl Date1 Date2");
   print "OK\n";
}

#------------------------------------
# Consultation de l'historique VTOM
#------------------------------------
$status=system("vtstools -x -e \"$Hier 08:00:00 $Aujourdhui 08:00:00\">$FICSTA");
if ($status != 0) {&f_erreur("ERREUR vtstools\n")};


#----------------------------------------
# Chargement du fichier des strategiques 
#----------------------------------------
open(FICIN,"$FICSTR");
while (<FICIN>)
{
   chop; 
   if ($_!~/^#/) {push(@STRATEGIQUES,"$_")};    
}
close FICIN;   


#------------------------------------------------
# Chargement du fichier des jobs dont
# l'execution est a controler
#-------------------------------------------------
open(FICIN,"$FICJOB");
while (<FICIN>)
{
   chop; 
   if ($_!~/^#/) 
   {
      ($environnement,$application,$job)=split(/;/,$_);
      $CONTROLE_EXECUTION{$environnement.':'.$application.':'.$job}="x";
   }
}
close FICIN;   

#------------------------------------------------
# Chargement du fichier des jobs dont
# l'abort ne doit pas generer de fiche de reprise
#------------------------------------------------
open(FICIN,"$FICJOK");
while (<FICIN>)
{
   chop; 
   if ($_!~/^#/) 
   {
      ($environnement,$application,$job)=split(/;/,$_);
      $CTL_SI_FICHE_DE_REPRISE{$environnement.':'.$application.':'.$job}="x";
   }
}
close FICIN;   

#-----------------------------
# Chargement en tableau 
#-----------------------------
$sequence=0;
open(FICIN,"$FICSTA");
while (<FICIN>)
{
   s/\'/\ /g;
   s/\"/\ /g;

   # Memorisation des executions 
   ($environnement,$application,$traitement,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$etat,$reste)=split(/;/,$_);

   if ($CONTROLE_EXECUTION{$environnement.':'.$application.':'.$traitement})
   {
      $CONTROLE_EXECUTION{$environnement.':'.$application.':'.$traitement}="OK";
   }


   # Memorisation des traitements en erreur
   if ($etat eq "EN-ERREUR")
   { 
      # Exclusion des environnements a exclure
      $presence=0;
      foreach $element (@ENV_PAS_A_TRAITER){if ($element eq $environnement) {$presence=1}};
      next if ($presence==1);

      push(@STAT,$_);
   }
}
close FICIN;


# -----------------------------------------------
# TRAITEMENTS AU STATUS "EN-ERREUR"
# -----------------------------------------------

# Tri des donnees
@STAT_TRIE= sort f_tri @STAT;
foreach $ligne (@STAT_TRIE)
{

   @En_erreur=split(/;/,$ligne);

   $job=$En_erreur[2];
   $machine=$En_erreur[6];
   $environnement=$En_erreur[0];
   $application=$En_erreur[1];
   $date_abort=$En_erreur[9];


   # Verification si presence de strategique
   $strategique=0;
   foreach $champ (@STRATEGIQUES) 
   {
      ($domaine,$job_strat)=split(/;/,$champ);
      if ($job_strat eq $job) 
      {
         $strategique=1;
         push(@CHECKLIST,"Reprise job strategique $job");
         #&f_strategiques_bo($domaine,$job);
      }
   };


   # Verification si pas de fiche de reprise a crer
   $pas_de_fiche_de_reprise=0;
   if ($CTL_SI_FICHE_DE_REPRISE{$environnement.':'.$application.':'.$job})
   {
      $pas_de_fiche_de_reprise=1;
   }
  

   # Formatage
   $job=substr($job."               ",0,16); 
   $machine=substr($machine."               ",0,16);
   $environnement=substr($environnement."               ",0,16);
   $application=substr($application."               ",0,16);
   $date_abort=substr($date_abort."                    ",0,20);
   $affichage=" $job   $machine    $environnement    $application   $date_abort";


   # Memorisation en tableau des strategiques
   if ($strategique==1) 
   {
      push(@VTOM_STRAT,"$affichage")
   } 
   # Memorisation en tableau pour les Etudes et pour le PCP
   else 
   {
      # Pas de fiche de reprise pour cet abort
      if ($pas_de_fiche_de_reprise==1)
      {
         push(@PAS_DE_FICHE_DE_REPRISE,"$affichage")
      }
      # Traitement normal pour cet abort
      else
      {
         $presence=0;
         foreach $element (@ENV_PAS_AUX_ETUDES) 
         {
            if ($environnement=~/$element/) {$presence=1};
         }
         foreach $element (@APP_PAS_AUX_ETUDES) 
         {
            if ($application=~/$element/) {$presence=1};
         }
         if ($presence ne 1) {push(@VTOM_ETUDES,"$affichage")}
         else {push(@VTOM_PCP,"$affichage")};
      }
   };

}


# -----------------------------------------------
# RECENSEMENT DES NON EXECUTES
# -----------------------------------------------
while (($cle,$valeur) = each(%CONTROLE_EXECUTION))
{
  if ($valeur ne "OK") {push (@NON_EXECUTE,$cle)};
}


#---------------------------------------
# Creation mailbox SML pour les Etudes
#---------------------------------------
open(FICOT,">$FICSML");
print FICOT "######SMI SVP, SMI Division Etudes Maintenance;VTOM : incidents de Production au $DAT_TRT\n";
#print FICOT "######dq151403;VTOM : incidents de Production au $DAT_TRT\n";
print FICOT "                     Visual TOM : Incidents de Production au $DAT_TRT\n\n";
print FICOT "=================================================================================================\n"; 
if (@VTOM_ETUDES != "" || @VTOM_STRAT != "" || @PAS_DE_FICHE_DE_REPRISE != "")
{
   print FICOT "     job           machine             environnement      application         date d\'execution\n\n";
   if (@VTOM_STRAT != "")
   {
      print FICOT "                           **********************************\n";  
      print FICOT "                           !!!!!      STRATEGIQUES      !!!!!\n";  
      print FICOT "                           **********************************\n";  
      foreach $ligne (@VTOM_STRAT) {print FICOT "$ligne\n"};	
      print FICOT "                           **********************************\n";  
   }
   foreach $ligne (@VTOM_ETUDES) {print FICOT "$ligne\n"};	
   print FICOT " \n";
   if (@PAS_DE_FICHE_DE_REPRISE != "")
   {
      print FICOT "                           ----------------------------------\n";  
      print FICOT "                           -     Pas de fiche de reprise    -\n";  
      print FICOT "                           ----------------------------------\n";  
      foreach $ligne (@PAS_DE_FICHE_DE_REPRISE) {print FICOT "$ligne\n"};	
   }
   print FICOT " \n";
}
else
{
   print FICOT "\n\n";
   print FICOT "                          Aucune detection de traitement en incident\n";
   print FICOT "\n";
}
close FICOT;

print "Creation mailbox SML pour Etudes\n";
#   $status=system("/u/prc/mbxcre.prc -mSML -f$FICSML -a180 -pVTOM");
$status=system("ls");
if ($status != 0) {&f_erreur("ERREUR mbxcre PCP status=$status\n")};


#-----------------------------------
# Creation mailbox SML pour le PCP 
#-----------------------------------
open(FICOT,">$FICSML");
print FICOT "######SMI PCP;VTOM : incidents de Production au $DAT_TRT\n";
#print FICOT "######dq151403;VTOM : incidents de Production au $DAT_TRT\n";
print FICOT "                     Visual TOM : Incidents de Production au $DAT_TRT\n\n";
print FICOT "=================================================================================================\n"; 
print FICOT "     job           machine             environnement      application         date d\'execution\n\n";
if (@VTOM_STRAT != "")
{
   print FICOT "                           **********************************\n";  
   print FICOT "                           !!!!!      STRATEGIQUES      !!!!!\n";  
   print FICOT "                           **********************************\n";  
   foreach $ligne (@VTOM_STRAT) {print FICOT "$ligne\n"};	
   print FICOT "                           **********************************\n";  
}

if (@VTOM_ETUDES != "")
{
   print FICOT "                             ----------------------------------\n";  
   print FICOT "                             -         Jobs applicatifs       -\n";  
   print FICOT "                             ----------------------------------\n";  
   foreach $ligne (@VTOM_ETUDES) {print FICOT "$ligne\n"};	
}
if (@NON_EXECUTE != "")
{
   print FICOT "                             ----------------------------------\n";  
   print FICOT "                             -       Jobs non executes        -\n";  
   print FICOT "                             ----------------------------------\n";  
   foreach $ligne (@NON_EXECUTE) 
   {   
      ($environnement,$application,$traitement)=split(/:/,$ligne);
      print FICOT "           $environnement   $application   $traitement \n";  
   }
}
if (@PAS_DE_FICHE_DE_REPRISE != "")
{
   print FICOT "                             ----------------------------------\n";  
   print FICOT "                             -     Pas de fiche de reprise    -\n";  
   print FICOT "                             ----------------------------------\n";  
   foreach $ligne (@PAS_DE_FICHE_DE_REPRISE) {print FICOT "$ligne\n"};	
}
if (@VTOM_PCP != "")
{
   print FICOT "                             ----------------------------------\n";  
   print FICOT "                             -          Jobs serveurs         -\n";  
   print FICOT "                             ----------------------------------\n";  
   foreach $ligne (@VTOM_PCP) {print FICOT "$ligne\n"};	
}

print FICOT " \n";
close FICOT;

print "Creation mailbox SML pour PCP\n";
#$status=system("/u/prc/mbxcre.prc -mSML -f$FICSML -a180 -pVTOM");
$status=system("ls");
if ($status != 0) {&f_erreur("ERREUR mbxcre PCP status=$status\n")};


#----------------------------------
# Creation mailbox CKL
# pour integration dans Check List 
#----------------------------------
if (@VTOM_STRAT != "")
{
   open(FICOT,">$FICCKL");
   foreach $ligne (@CHECKLIST) {print FICOT "PCP\;$ligne\n"};	
   close FICOT;
#   $status=system("/u/prc/mbxcre.prc -mCKL -f$FICCKL -a180 -pVTOM");
   $status=system("ls");   
   if ($status != 0) {&f_erreur("ERREUR mbxcre CKL status=$status\n")};
}


if (@NON_EXECUTE != "")
{
   open(FICOT,">$FICCKL");
   foreach $ligne (@NON_EXECUTE) {print FICOT "PCP\;Non execution a controler $ligne\n"};	
   close FICOT;
#   $status=system("/u/prc/mbxcre.prc -mCKL -f$FICCKL -a180 -pVTOM");
   $status=system("ls");   
   if ($status != 0) {&f_erreur("ERREUR mbxcre CKL status=$status\n")};
}

exit 0;
