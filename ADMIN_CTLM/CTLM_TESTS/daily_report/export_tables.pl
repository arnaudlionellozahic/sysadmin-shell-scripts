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
my $temp_JDAY="$rep/temp_$J_DAY.csv";
my $out_groups_JDAY1="$rep/error_groups_$J_DAY1.csv";
my $temp_JDAY1="$rep/temp_$J_DAY1.csv";
my $out_groups_JDAY2="$rep/error_groups_$J_DAY2.csv";
my $temp_JDAY2="$rep/temp_$J_DAY2.csv";
my $out2="$rep/export_tables_temp.txt";
#ENVI=PREX
my $gen_rapport_html="${rep0}/gen_rapport_html.ksh";
my ($Ligne, $Orderid, $Jobname)="";

chdir("$rep");
opendir(DIR,".");
closedir(DIR);

 sub req {
 if (-e $out2) {
    print "$out2 already exists\n";
 } else { 
   system("touch $out2");
   }  
 open(FIC, ">", "$out2") or die "Couldn't open: $!";
 select (FIC);
 system("ctmpsm -LISTALL > $out2 2>&1");
 close (FIC) or die "Can't close: $!";
}

 sub req_day {
 open(FIC1, ">", "$temp_JDAY") or die "Couldn't open: $!";
 select (FIC1);
 foreach $i (@list_groups) {
   system("cat $out2 | grep $i | grep TBL | grep ${J_DAY} | grep NOTOK >> $temp_JDAY 2>&1");
}
 close (FIC1) or die "Can't close: $!";
 open(IN,$temp_JDAY) or die "$!";
 open(OUT, ">", "$out_groups_JDAY") or die "$!";
 while ($Ligne=<IN>) {
    select (OUT);
    ($Orderid,$Jobname) = split (/\|/,$Ligne);
    print "$Jobname\n";
    print "$Ligne\n";
 }
 close(IN);
 close(OUT);
}

 sub req_day1 {
 open(FIC2, ">", "$temp_JDAY1") or die "Couldn't open: $!";
 select (FIC2);
 foreach $i (@list_groups) {
   system("cat $out2 | grep $i | grep TBL | grep ${J_DAY1} | grep NOTOK >> $temp_JDAY1 2>&1");
}
 close (FIC2) or die "Can't close: $!";
 open(IN,$temp_JDAY1) or die "$!";
 open(OUT, ">", "$out_groups_JDAY1") or die "$!";
 while ($Ligne=<IN>) {
    select (OUT);
    ($Orderid,$Jobname) = split (/\|/,$Ligne);
    print "$Jobname\n";
 }
 close(IN);
 close(OUT)
}

 sub req_day2 {
 open(FIC3, ">", "$temp_JDAY2") or die "Couldn't open: $!";
 select (FIC3);
 foreach $i (@list_groups) {
   system("cat $out2 | grep $i | grep TBL | grep ${J_DAY2} | grep NOTOK >> $temp_JDAY2 2>&1");
}
 close (FIC3) or die "Can't close: $!";
 open(IN,$temp_JDAY2) or die "$!";
 open(OUT, ">", "$out_groups_JDAY2") or die "$!";
 while ($Ligne=<IN>) {
    select (OUT);
    ($Orderid,$Jobname) = split (/\|/,$Ligne);
    print "$Jobname\n";
 }
 close(IN);
 close(OUT)
}

#main
&req;
&req_day;
&req_day1;
&req_day2;

system("rm -f $temp_JDAY $temp_JDAY1 $temp_JDAY2 2>&1");

system(". $gen_rapport_html 2>&1");


