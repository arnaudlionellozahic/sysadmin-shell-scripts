#!/usr/bin/perl -w

use strict;
use warnings;
use POSIX qw/strftime/;
my $rep="/slqdl7bdd01/appli/dl7/sp/tests_ctlm/daily_report/EXPORTS";
my $J_DAY = strftime("%Y%m%d", localtime());
my $out_groups_JDAY="$rep/error_groups_$J_DAY.csv";

chdir("$rep");
opendir(DIR,".");
closedir(DIR);

use Encode qw/encode decode/;

my $Fichier_in="$out_groups_JDAY";

open (TMP,$Fichier_in) || die "Ne peut lire $Fichier_in $!";
open (TMP2, ">", 'outputfile_.txt') || die "Ne peut lire $!";

while ( my $Lire = <TMP> )
{
  select (TMP2);
  chomp $Lire;
   #my $utf8 = encode('utf8', $Lire);
   my $utf8 = Encode::encode('ISO-8859-1', $Lire);
     print "- $utf8 \n";
     #binmode $Lire, ':encoding(utf8)';

}

close(TMP);
close(TMP2);

