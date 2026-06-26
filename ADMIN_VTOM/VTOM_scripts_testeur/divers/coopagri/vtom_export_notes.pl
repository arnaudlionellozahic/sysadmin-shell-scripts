#!/usr/bin/perl
#===========================================================================================
#                               vtom_export_notes.pl
#                               --------------------
#
# Formatage du fichier export pour integration dans Notes
#
# Usage : /u/perl/vtom_export_notes.pl     
#
# CREATION : 10/05/2010 D. QUIMERCH
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
$FIC_EXP="/home/fcharbon/coopagri/vtom_export.txt";
$FIC_MBX="/home/fcharbon/coopagri/vtom_notes.txt";


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
$env_a_traiter="non";
$app_a_traiter="non";
$res_a_traiter="non";
$obj_a_traiter="non";
$plan_a_traiter="non";
open(FICIN,"$FIC_EXP");
while (<FICIN>)
{
   chop; 

   #----------------------------------------
   # Traitement des donnees Environnements 
   #----------------------------------------
   if ($_=~/^\[env\:APPLIS/)
   {
      $env_a_traiter="oui"; 
      $machine="";
      $utilisateur="";
      $planning=""; 
   }

   if ($env_a_traiter eq "oui")
   {
      if ($_=~/^\[env\:APPLIS/) 
      { 
         ($deb,$env)=split(/\:/,$_);
         $env=substr($env,0,length($env)-1);
      }
      if ($_=~/^machine\=/) {$machine=substr($_,8)};
      if ($_=~/^utilisateur\=/) {$utilisateur=substr($_,12)};
      if ($_=~/^planning\=/) {$planning=substr($_,9)};

      # Memorisation
      if ($_=~/^$/) 
      {
         push(@INFOS_ENV,"$env;$machine;$utilisateur;$planning;\n");  
         $env_a_traiter="non";
      }
   }


   #----------------------------------------
   # Traitement des donnees Applications
   #----------------------------------------
   if ($_=~/^\[app\:APPLIS/)
   {
      $app_a_traiter="oui"; 
      $machine="";
      $utilisateur="";
      $planning=""; 
   }

   if ($app_a_traiter eq "oui")
   {
      if ($_=~/^\[app\:APPLIS/) 
      { 
         ($env,$appli)=split(/\//,substr($_,5));
         $appli=substr($appli,0,length($appli)-1);
      }
      if ($_=~/^machine\=/) {$machine=substr($_,8)};
      if ($_=~/^utilisateur\=/) {$utilisateur=substr($_,12)};
      if ($_=~/^planning\=/) {$planning=substr($_,9)};

      # Memorisation
      if ($_=~/^$/) 
      {
         push(@INFOS_APPLIS,"$env$appli;$machine;$utilisateur;$planning;\n");  
         $app_a_traiter="non";
      }
   }

   #----------------------------------------
   # Traitement des ressources fichier 
   #----------------------------------------
   if ($_=~/^\[res\:/)
   {
      $res_a_traiter="oui"; 
      $ressource=substr($_,5,length($_)-6);
   }
   if ($res_a_traiter eq "oui" && $_=~/^type\=/)
   {
      # On ne traite que les ressources fichier et poids (exclusion)
      $res_a_traiter="non";
      if ($_=~/^type\=fichier/) {$res_a_traiter="fic";} 
      # Memorisation des ressources poids  
      #if ($_=~/^type\=poids/) {$POIDS{$ressource}="B");}
      if ($_=~/^type\=poids/) {push(@LES_POIDS,"$ressource");}
   }
   # Memorisation 
   if ($res_a_traiter eq "fic" && $_=~/^valeur/)
   {
      $valeur=substr($_,7);
      # Ressources mailbox
      if ($valeur=~/\/u\/ftp\/pub\/mbx\/drp\// || $valeur=~/\/mbxdrp\//) 
         {$INFOS_RES_MBX{$ressource}=$valeur;}
      # ressources oracle
      elsif ($valeur=~/\/u\/drp\/ORA(.*)\.OK/ || $valeur=~/\/u\/drp\/ORA(.*)\.aft/ || $valeur=~/\/u\/drp\/ORAstop(.*)\.drp/) 
         {  
            ($mach,$res)=split(/\)/,$valeur);
            $INFOS_RES_ORA{$ressource}=$res;
         }
      # Autres ressources fichier
      else
         {$INFOS_RES_FIC{$ressource}=$valeur;}
      $res_a_traiter="non";
   }

   #----------------------------------------
   # Traitement des plannings
   #----------------------------------------
   if ($_=~/^\[planning\:/)
   {
      $plan_a_traiter="oui"; 
      $planning=substr($_,10,length($_)-11);
   }
   if ($plan_a_traiter eq "oui" && $_=~/^calendrier/)
   {
      $valeur=substr($_,11);
      $INFOS_PLANNINGS{$planning}="$valeur";
   }
   if ($plan_a_traiter eq "oui" && $_=~/^formule\=/)
   {
      $valeur=substr($_,8);
      $INFOS_PLANNINGS{$planning}=$INFOS_PLANNINGS{$planning}."\;$valeur";
   }

   # Reinitialisations en fin de paragraphe 
   if ($_=~/^$/)
   {
      $plan_a_traiter="non";
   }

}
close FICIN;   


#--------------------------------------------------
# Chargement du fichier export
# Deuxieme lecture pour les ressources poids
# On constitue un tableau de hashage avec le nom de la ressource poids en cle  
# et le nom des traitements associes en valeur
#--------------------------------------------------
$trt_a_traiter="non";
open(FICIN,"$FIC_EXP");
while (<FICIN>)
{
   chop; 
   if ($_=~/^\[job\:APPLIS/) 
   {
      $trt_a_traiter="oui";
      $traitement=substr($_,5,length($_)-6);
   }
   if ($trt_a_traiter eq "oui" && $_=~/^ressources\=/)
   {
      ($r1,$r2,$r3,$r4,$r5,$r6,$r7,$r8,$r9,$r10)=split(/\,/,substr($_,11));
      ($r1,$t1)=split(/ /,$r1);
      ($r2,$t2)=split(/ /,$r2);
      ($r3,$t3)=split(/ /,$r3);
      ($r4,$t4)=split(/ /,$r4);
      ($r5,$t5)=split(/ /,$r5);
      ($r6,$t6)=split(/ /,$r6);
      ($r7,$t7)=split(/ /,$r7);
      ($r8,$t8)=split(/ /,$r8);
      ($r9,$t9)=split(/ /,$r9);
      ($r10,$t10)=split(/ /,$r10);
      foreach $res ($r1,$r2,$r3,$r4,$r5,$r6,$r7,$r8,$r9,$r10)
      {
         if ($res ne "")
         {
            foreach $i (@LES_POIDS) 
            {
               if ("$i" eq "$res")
               {
                  $INFOS_RES_POIDS{$i}=$INFOS_RES_POIDS{$i}."\;$traitement";
                  last;
               }   
            }
         }
      }
      $trt_a_traiter="non";   
   }
}
close FICIN;   




#print "tableau\n";
#while (($c,$v) = each(%INFOS_RES_POIDS)) 
#{
#  print "Cle : $c, Valeur : $v\n";
#}



#----------------------------------------
# Chargement du fichier export
#----------------------------------------
$a_traiter="non";
open(FICIN,"$FIC_EXP");
while (<FICIN>)
{
   chop; 
   if ($_=~/^\[job\:APPLIS_/) {$a_traiter="oui"};

   
   if ($a_traiter eq "oui")
   {

      if ($_=~/^\[job\:APPLIS_/) 
      { 
      
         # Initialisation des variables facultatives
         $p1="";$p2="";$p3="";$p4="";$p5="";$p6="";$p7="";$p8="";$p9="";$p10="";
         $rf1="";$rf2="";$rf3="";$rf4="";$rf5="";
         $rft1="";$rft2="";$rft3="";$rft4="";$rft5="";
         $rm1="";$rm2="";$rm3="";$rm4="";$rm5="";
         $re1="";$re2="";$re3="";$re4="";$re5="";
         $roracle=""; $roracle_num="";
         $commentaire="";
         $type_periodicite="";
         $cyclique="";
         $cycle="";            
         $utilisateur="";
         $machine="";
         $planning="";
         $formule="";
         # Type periodicite : A automatique, D demande 
         $type_periodicite="A";

         # Affectation des variables de la premiere ligne
         $env_app_trt=substr($_,5,length($_)-6);
         ($env,$appli,$traitement)=split(/\//,substr($_,5));
         $code_app=substr($appli,0,3);   
         $trt=substr($traitement,0,length($traitement)-1);   
      }

      if ($_=~/^commentaire\=/) {$commentaire=substr($_,12)};
      $commentaire=~s/\;/\:/;
      if ($_=~/^heure_debut\=/) {$hdeb=substr($_,12)};
      if ($_=~/^heure_fin\=/) {$hfin=substr($_,10)};
      if ($_=~/^type_periodicite\=demande/) {$type_periodicite="D"};
      if ($_=~/^cyclique\=/) {$cyclique=substr($_,9)};
      if ($_=~/^cycle\=/) {$cycle=substr($_,6)};
      if ($_=~/^utilisateur\=/) {$utilisateur=substr($_,12)};
      if ($_=~/^machine\=/) {$machine=substr($_,8)};
      if ($_=~/^planning\=/) {$planning=substr($_,9)};
      # Determiner le repertoire d'execution et le script 
      if ($_=~/^script\=/) 
      {
         $script=substr($_,7);
         # Caractere pour scripts sous aix/linux
         $car_a_chercher="\/";  
         $result=index($script,"\/");   
         # Caractere pour scripts sous windows
         if ($result == -1) 
         {
            # Caractere pour scripts sous windows
            $car_a_chercher="\/";  
            $result=index($script,"\\");   
         }
         while ($result != -1)
            {
               $offset=$result+1;
               $result=index($script,"$car_a_chercher",$offset);   
            } 
         $repertoire=(substr($script,0,$offset));
         $script=(substr($script,$offset));         
         if ($repertoire=~/^\#/) {$repertoire=substr($repertoire,1)};         

         # Suppression du caractere ";"
         $script=~s/\;/\:/;
         $repertoire=~s/\;/\:/;
      };
      if ($_=~/^ressources\=/) 
      {  
      
      
         ($r1,$r2,$r3,$r4,$r5,$r6,$r7,$r8,$r9,$r10)=split(/\,/,substr($_,11));
         ($r1,$t1)=split(/ /,$r1);
         ($r2,$t2)=split(/ /,$r2);
         ($r3,$t3)=split(/ /,$r3);
         ($r4,$t4)=split(/ /,$r4);
         ($r5,$t5)=split(/ /,$r5);
         ($r6,$t6)=split(/ /,$r6);
         ($r7,$t7)=split(/ /,$r7);
         ($r8,$t8)=split(/ /,$r8);
         ($r9,$t9)=split(/ /,$r9);
         ($r10,$t10)=split(/ /,$r10);
         
         # Eclatement entre ressources fichier (rf), ressources exclusion (re), ressources mailbox (rm))
         $ind=0;
         $ind_rf=0;
         $ind_rm=0;
         $ind_re=0;
         foreach $res ($r1,$r2,$r3,$r4,$r5,$r6,$r7,$r8,$r9,$r10)
         {
            $ind++;
            # On memorise le type (Presence, Absence) de la ressource traitee;
            if ($ind==1) {$rtype=$t1};
            if ($ind==2) {$rtype=$t2};
            if ($ind==3) {$rtype=$t3};
            if ($ind==4) {$rtype=$t4};
            if ($ind==5) {$rtype=$t5};
            if ($ind==6) {$rtype=$t6};
            if ($ind==7) {$rtype=$t7};
            if ($ind==8) {$rtype=$t8};
            if ($ind==9) {$rtype=$t9};
            if ($ind==10) {$rtype=$t10};
       

            if ($res ne "")
            {
               # On verifie si c'est une ressource d'exclusion
               $c_est_un_poids="non";
               if ($INFOS_RES_POIDS{$res})
               {
                  $c_est_un_poids="oui";
                  ($ex1,$ex2,$ex3,$ex4,$ex5)=split(/;/,$INFOS_RES_POIDS{$res});
                  foreach $i ($ex1,$ex2,$ex3,$ex4,$ex5)
                  {
                     if ($i ne "" && $env_app_trt ne $i)
                     {     
                        $ind_re++;
                        if ($ind_re==1) {$re1=$i;}
                        if ($ind_re==2) {$re2=$i;}
                        if ($ind_re==3) {$re3=$i;}
                        if ($ind_re==4) {$re4=$i;}
                        if ($ind_re==5) {$re5=$i;}
                     }
                  }
               } 
               if ($c_est_un_poids eq "non")    
               {
                  # C'est une ressource mailbox
                  if ($INFOS_RES_MBX{$res})
                  {
                     $ind_rm++;
                     $cod_mbx=$INFOS_RES_MBX{$res};
                     $cod_mbx=substr($cod_mbx,length($cod_mbx)-7,3);
                     if ($ind_rm==1) {$rm1=$cod_mbx;}
                     if ($ind_rm==2) {$rm2=$cod_mbx;}
                     if ($ind_rm==3) {$rm3=$cod_mbx;}
                     if ($ind_rm==4) {$rm4=$cod_mbx;}
                     if ($ind_rm==5) {$rm5=$cod_mbx;}
                  }
                  # C'est une ressource oracle
                  elsif ($INFOS_RES_ORA{$res})
                  {
                     $roracle=$INFOS_RES_ORA{$res};
                     if ($roracle=~/\/u\/drp\/ORA(.*)\.OK/) {$roracle_num="1"};
                     if ($roracle=~/\/u\/drp\/ORA(.*)\.aft/) {$roracle_num="2"};
                     if ($roracle=~/\/u\/drp\/ORAstop(.*)\.drp/) {$roracle_num="3"};
                     # formatage pour afficher "$GENDRP"
                     $roracle=~s/\/u\/drp/\$GENDRP/;   
                  }
                  # C'est une banale ressource fichier
                  else
                  {
                     $ind_rf++;
                     if ($ind_rf==1) {$rf1=$INFOS_RES_FIC{$res}; $rft1=substr($rtype,0,1);}
                     if ($ind_rf==2) {$rf2=$INFOS_RES_FIC{$res}; $rft2=substr($rtype,0,1);}
                     if ($ind_rf==3) {$rf3=$INFOS_RES_FIC{$res}; $rft3=substr($rtype,0,1);}
                     if ($ind_rf==4) {$rf4=$INFOS_RES_FIC{$res}; $rft4=substr($rtype,0,1);}
                     if ($ind_rf==5) {$rf5=$INFOS_RES_FIC{$res}; $rft5=substr($rtype,0,1);}
                  }
               }
            }
         } 
      }
      if ($_=~/^parametres\=/) 
      {     
         ($p1,$p2,$p3,$p4,$p5,$p6,$p7,$p8,$p9,$p10)=split(/;/,substr($_,11));
      }
      if ($_=~/^liens_vers\=/) 
      {     
         ($l1,$l2,$l3,$l4,$l5)=split(/,/,substr($_,11));
         ($lvl1,$lvt1)=split(/\[/,$l1);
         ($lvl2,$lvt2)=split(/\[/,$l2);
         ($lvl3,$lvt3)=split(/\[/,$l3);
         ($lvl4,$lvt4)=split(/\[/,$l4);
         ($lvl5,$lvt5)=split(/\[/,$l5);
         if (substr($lvt1,0,4) eq "obli") {$lvt1="O"} 
         if (substr($lvt1,0,4) eq "facu") {$lvt1="F"};             
         if (substr($lvt2,0,4) eq "obli") {$lvt2="O"};             
         if (substr($lvt2,0,4) eq "facu") {$lvt2="F"};             
         if (substr($lvt3,0,4) eq "obli") {$lvt3="O"};             
         if (substr($lvt3,0,4) eq "facu") {$lvt3="F"};             
         if (substr($lvt4,0,4) eq "obli") {$lvt4="O"};             
         if (substr($lvt4,0,4) eq "facu") {$lvt4="F"};             
         if (substr($lvt5,0,4) eq "obli") {$lvt5="O"};             
         if (substr($lvt5,0,4) eq "facu") {$lvt5="F"};             
      };
      if ($_=~/^liens_de\=/) 
      {     
         ($l1,$l2,$l3,$l4,$l5)=split(/,/,substr($_,9));
         ($ldl1,$ldt1)=split(/\[/,$l1);
         ($ldl2,$ldt2)=split(/\[/,$l2);
         ($ldl3,$ldt3)=split(/\[/,$l3);
         ($ldl4,$ldt4)=split(/\[/,$l4);
         ($ldl5,$ldt5)=split(/\[/,$l5);
         if (substr($ldt1,0,4) eq "obli") {$ldt1="O"} 
         if (substr($ldt1,0,4) eq "facu") {$ldt1="F"};             
         if (substr($ldt2,0,4) eq "obli") {$ldt2="O"};             
         if (substr($ldt2,0,4) eq "facu") {$ldt2="F"};             
         if (substr($ldt3,0,4) eq "obli") {$ldt3="O"};             
         if (substr($ldt3,0,4) eq "facu") {$ldt3="F"};             
         if (substr($ldt4,0,4) eq "obli") {$ldt4="O"};             
         if (substr($ldt4,0,4) eq "facu") {$ldt4="F"};             
         if (substr($ldt5,0,4) eq "obli") {$ldt5="O"};             
         if (substr($ldt5,0,4) eq "facu") {$ldt5="F"};             
      };

   
      # Ecriture
      if ($_=~/^$/) 
      {

         # Recherche des informations de l'application
         # Si pas renseigne recherche dans environnement
         foreach my $ligne (@INFOS_APPLIS) 
         {
            ($a_envapp,$a_mach,$a_uti,$a_plan)=split(/\;/,$ligne);
            if ($a_envapp eq "$env"."$appli" )
            {
               if ($utilisateur eq "") {$utilisateur=$a_uti};
               if ($machine eq "") {$machine=$a_mach};
               $planning_app=$a_plan;
               last;
            }
         }
         if ($utilisateur=="" || $machine=="")
         {
            foreach my $ligne (@INFOS_ENV) 
            {
               ($e_env,$e_mach,$e_uti,$e_plan)=split(/\;/,$ligne);
               if ($e_env eq "$env" )
               {
                  if ($utilisateur eq "") {$utilisateur=$e_uti};
                  if ($machine eq "") {$machine=$e_mach};
                  last
               }
            }
         }
   
         # On prend le planning de l'appli s'il n'y a pas de planning specifique pour le traitement
         if ($planning eq "") {$planning=$planning_app};
         ($calendrier,$formule)=split(/\;/,$INFOS_PLANNINGS{$env_app_trt});
         ($deb,$formule)=split(/\{/,$formule);
         ($formule,$fin)=split(/\}/,$formule);
         if ($trt ne "" && $script ne "" && $code_app!~/^U\_/)
         {
            push(@NOTES,"$code_app\;$trt\;$script\;$machine\;$repertoire\;$utilisateur\;$commentaire\;$cyclique\;$cycle\;$hdeb\;$hfin\;$calendrier\;$p1\;$p2\;$p3\;$p4\;$p5\;$p6\;$p7\;$p8\;$p9\;$p10\;$ldl1\;$ldt1\;$ldl2\;$ldt2\;$ldl3\;$ldt3\;$ldl4\;$ldt4\;$ldl5\;$ldt5\;$lvl1\;$lvt1\;$lvl2\;$lvt2\;$lvl3\;$lvt3\;$lvl4\;$lvt4\;$lvl5\;$lvt5\;$rf1\;$rft1\;$rf2\;$rft2\;$rf3\;$rft3\;$rf4\;$rft4\;$rf5\;$rft5\;$rm1\;$rm2\;$rm3\;$rm4\;$rm5\;$roracle_num\;$roracle\;$re1\;$re2\;$re3\;$re4\;$re5\;$type_periodicite\;$formule");  
         }
         $a_traiter="non";
      }  
   }


}
close FICIN;   


if (@NOTES != "")
{
   open(FICOT,">$FIC_MBX");
   foreach $ligne (@NOTES) {print FICOT "$ligne\n"};
   close FICOT;
}


# $status=system("/u/prc/mbxcre.prc -mVTN -f$FIC_MBX -a180 -pvtom_notes");
$status=system("ls");
if ($status != 0) {&f_erreur("ERREUR mbxcre VTN status=$status\n")};

unlink $FIC_EXP;

exit 0;



