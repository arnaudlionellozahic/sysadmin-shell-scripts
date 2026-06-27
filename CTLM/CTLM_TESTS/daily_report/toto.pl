#!/usr/bin/perl -w

use strict;
use warnings;
use POSIX qw/strftime/;

#CALCUL DE J
my $date = strftime("%Y%m%d", localtime());
my $time = strftime("%H:%M:%S", localtime());
my $J_DAY = strftime("%Y%m%d", localtime());

#CALCUL DE J-1
my ($sec, $min, $heure, $jour, $mois,$annee, undef, undef, undef) = localtime(time-3600*24);
$mois += 1 and $annee -= 100;
$jour = sprintf("%02d",$jour);
$mois = sprintf("%02d",$mois);
$annee = sprintf("20%02d",$annee);
my $J_DAY1 = "$annee$mois$jour";
print $J_DAY1,"\n";

#CALCUL DE J-2
my ($sec_, $min_, $heure_, $jour_, $mois_, $annee_, undef, undef, undef) = localtime(time-3600*48);
$mois_ += 1 and $annee_ -= 100;
$jour_ = sprintf("%02d",$jour_);
$mois_ = sprintf("%02d",$mois_);
$annee_ = sprintf("20%02d",$annee_);
my $J_DAY2 = "$annee_$mois_$jour_";
print $J_DAY2,"\n";

my $i;
my @list_groups = qw /P3G_ PAM_ PAJ_ PAH_ PBX_ PCL_ PDQ1_ PEJ_ PFE_ PFG_ PKD_ PKS_ POJ_ PR3_ PRR_ PSR_ PX6A_ PMO_ QM62_ QDL7_ QQ34_ QQ04_/;

my $rep="/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS";
my $rep0="/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report";
my $out_groups_JDAY="$rep/error_groups_$J_DAY.csv";
my $out_groups_JDAY1="$rep/error_groups_$J_DAY1.csv";
my $out_groups_JDAY2="$rep/error_groups_$J_DAY2.csv";
my $out2="$rep/export_tables_temp.txt";
#ENVI=PREX
#export_jobs=${rep0}/export_jobs.ksh
my ($Ligne, $Orderid, $Jobname)="";
my $titi="titi.txt";

chdir("$rep");
opendir(DIR,".");
closedir(DIR);

open(IN,$titi) or die "$!"; 
open(OUT, ">", 'outputfile.txt') or die "$!"; 
while ($Ligne=<IN>) { 
   select (OUT);
   ($Orderid,$Jobname) = split (/\|/,$Ligne);
   print "$Orderid, $Jobname\n"; 
} 
close(IN); 
close(OUT);

#my $str = "root:*:0:0:System Administrator:/var/root:/bin/sh";
#my ($username, $password, $uid, $gid, $real_name, $home, $shell) = split /:/, $str;
#print "$username\n";
#print "$real_name\n"; 
