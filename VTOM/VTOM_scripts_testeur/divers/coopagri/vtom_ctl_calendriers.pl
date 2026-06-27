#!/usr/bin/perl
#===========================================================================================
#                            vtom_ctl_calendriers.pl
#                            -----------------------
#
# Controle du calendrier affecte a chaque environnement   
#
# Usage : /u/perl/vtom_ctl_calendriers.pl   
#
# CREATION : 08/06/2010 D. QUIMERCH
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
use File::Copy;

# Affectation des variables
$FIC_EXP="/home/fcharbon/coopagri/vtom_ctl_calendrier.txt";
$FIC_SML="/home/fcharbon/coopagri/vtom_calendrier.sml";


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



#--------------------------------------------------
# Export dans le repertoire /u/man
#--------------------------------------------------
system ("vtexport > $FIC_EXP");


#--------------------------------------------------
# Chargement du fichier export
# Premiere lecture pour memorisation de donnees
#--------------------------------------------------
open(FICIN,"$FIC_EXP");
while (<FICIN>)
{
   chop; 

   #----------------------------------------
   # Traitement des donnees Environnements 
   #----------------------------------------
   if ($_=~/^\[env\:/)
   {
      $env_a_traiter="oui"; 
      ($titre,$environnement)=split (/\:/, $_)
   }

   if ($env_a_traiter eq "oui")
   {
      if ($_=~/^calendrier\=/) 
      { 
         if ($_=!/^calendrier\=Tous_les_jours/)
         {
            open(FICOT,">$FIC_SML");
            print FICOT "######SMI PCP;VTOM : Controle des calendriers au $DAT_TRT\n";
            print FICOT " ATTENTION : calendrier de l'environnement $environnement";
            print FICOT "             different de Tous_les_jours";
            close FICOT;

#            $status=system("/u/prc/mbxcre.prc -mSML -f$FIC_SML -a180 -pVTOM");
             $status=system("ls");
            if ($status != 0) {&f_erreur("ERREUR mbxcre PCP status=$status\n")};
         }
      }

      if ($_=~/^$/)
      {
         $env_a_traiter="non";
      }
   }
}
close FICIN;   

unlink $FIC_EXP;

exit 0;
