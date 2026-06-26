#!/usr/bin/perl
#===========================================================================================
#                                     vtom_ctl_duree.pl
#                                     -----------------
#
# Controle de la duree d'execution des traitements
#
# Usage : /a/vtom/perl/vtom_ctl_duree.pl
#
# Fichier parametre : /a/vtom/fic/vtom_ctl_duree.dta
#                     Liste des traitements a controler avec leur duree maxi d'execution
#
# CREATION : 04/02/2010 D. QUIMERCH
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
        print "============================================================ \n";
        print " ERREUR : $_[0]\n";
        print "============================================================ \n";
        exit 4;
}


#-------------------------------------------------------------------------------
#                                    TRAITEMENT
#-------------------------------------------------------------------------------
# Affectation des variables
$FICCTL="/home/fcharbon/scripts/vtom_ctl_duree.dta";
$FICSML="/home/fcharbon/scripts/vtom_ctl_duree.sml";


# Date du jour
@ladate=localtime(time);
# Heure, minute, seconde
if ($ladate[2] < 10) {$lheure='0'.$ladate[2]} else {$lheure=$ladate[2]}; if ($ladate[1] < 10) {$laminute='0'.$ladate[1]} else {$laminute=$ladate [1]}; if ($ladate[0] < 10) {$laseconde='0'.$ladate[0]} else {$laseconde=$ladate [0]}; # Annee, mois, jour $lannee=$ladate[5]+1900; $lemois=$ladate[4]+1; if ($lemois < 10) {$lemois='0'.$lemois}; if ($ladate[3] < 10) {$lejour='0'.$ladate[3]} else {$lejour=$ladate[3]}; $AMJ_HMS=$lannee.$lemois.$lejour."_".$lheure.$laminute.$laseconde;
# Heure du controle (en secondes)
$CTL_SEC=($lheure*3600)+($laminute*60)+$laseconde;


#----------------------------------------
# Chargement du fichier de controle
#----------------------------------------
open(FICIN,"$FICCTL");
while (<FICIN>)
{
   chop;
   next if ($_=~/^\#/);
   ($environnement,$application,$traitement,$duree_max)=split (/;/, $_) ;

#print $environnement;
#print $application;
#print $traitement;
#print $duree_max;

   # Controle sur les jobs au status ENCOURS

   system("tlist ENCOURS|grep \"$environnement\"|grep \"$application\"|grep \"$traitement\">>/home/fcharbon/scripts/trace.txt");
   $status=0;
   if ("$status" == 0)
   {
#      foreach $_ (`tlist vtstools | grep $environnement | grep $application | grep $traitement`)
      foreach $_ (`tlist vtstools`)
#      foreach $_ (`tlist vtstools -f $environnement/$application/$traitement`)
      {
         ($a,$b,$c,$d,$e,$f,$g,$h,$i,$Hlancement,$reste)=split(/;/, $_);
         ($Hlancement_deb,$Hlancement_fin)=split(/ /,$Hlancement);
         ($Hh,$Hm,$Hs)=split(/:/,$Hlancement_fin);
         $Trt_secondes=($Hh*3600)+($Hm*60)+$Hs;


         # Verification de la duree d'execution
         if (($CTL_SEC-$Trt_secondes) > $duree_max)
         {

            # Information
            print "Traitement                        : $traitement\n";
            print "Duree max                         : $duree_max\n";
            print "Heure de controle (en secondes)   : $CTL_SEC\n";
            print "Heure du traitement (en secondes) : $Trt_secondes\n";

            #---------------------------------------
            # Alarme VTOM
            #---------------------------------------
#            system("vtmsg -w -P120 -Aeffect17 -m \"$environnement\| $application\ |$traitement : duree max d\'execution depassee\"");


            #---------------------------------------
            # Creation mailbox SML pour le PCP
            #---------------------------------------
            open(FICOT,">$FICSML");
            print FICOT "######SMI PCP;VTOM : Controle des traitements en cours\ n";
            print FICOT "                  Visual TOM : Controle des durees d'execution\n\n";
            print FICOT "   Le traitement $environnement\|$application\|$traitement \n";
            print FICOT "   depasse la duree d'execution maxi de $duree_maxsecondes\n";
            close FICOT;

#            $status=system("/u/prc/mbxcre.prc -mSML -f$FICSML -a180 -pVTOM");
            $status=0;
            if ($status != 0) {&f_erreur("ERREUR mbxcre PCP status=$status \n")};

         }
      }
   }
}
close FICIN;


exit 0;


