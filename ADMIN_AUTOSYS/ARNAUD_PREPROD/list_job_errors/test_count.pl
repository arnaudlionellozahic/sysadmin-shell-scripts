#!/usr/bin/perl -w

use strict; use warnings; use 5.8.8;
no strict 'refs';

use POSIX qw/strftime/;
my $date = strftime("%Y-%m-%d", localtime());
my $time = strftime("%H:%M:%S", localtime());

my $TOTO = "/apps/meoatlas2/arnaud/report.txt";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open file";
$toto++ while <$TOTO>;
close $TOTO;
print $toto, "\n";
