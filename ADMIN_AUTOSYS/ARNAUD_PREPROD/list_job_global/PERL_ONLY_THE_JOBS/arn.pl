#!/usr/bin/perl -w

use strict; use warnings; use 5.8.8; use autodie;
no strict 'refs';

use POSIX qw/strftime/;
my $date = strftime("%Y-%m-%d", localtime());
my $time = strftime("%H:%M:%S", localtime());


sub jobs_report_FA {
my $FILE = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";
#only the jobs
my @toto = qx{autorep -j ALL -L0 | grep -w FA | awk '{print \$1}' | awk 1 ORS='|' | sed 's/|\$//'};
qx{autorep -j ALL | grep -w FA | grep -v BOX > ${FILE}};

foreach my $truc (@toto) {
   print "####> LES BOXS SUIVANTES SONT EXCLUSES DU RAPPORT <### : $truc";
}

qx{perl -ni -e 'print unless /@toto/;' ${FILE}};

}

& jobs_report_FA;

#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
