#!/usr/bin/perl -w

use strict; use warnings; use 5.8.8; use autodie;
no strict 'refs';

use POSIX qw/strftime/;
my $date = strftime("%Y-%m-%d", localtime());
my $time = strftime("%H:%M:%S", localtime());


#################
#FUNCTIONS
#################

sub counting_FA {
my $TOTO = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
$toto++ while <$TOTO>;
print "\n";
#print $toto, "\n";
print "There are $toto jobs in error, check the file : $TOTO \n";
print "\n";
}

sub counting_RU {
my $TOTO = "/apps/meoatlas2/arnaud/jobs_running.txt_PL";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
$toto++ while <$TOTO>;
print "\n";
#print $toto, "\n";
print "There are $toto jobs running, check the file : $TOTO \n";
print "\n";
}

sub counting_OH {
my $TOTO = "/apps/meoatlas2/arnaud/jobs_hold.txt_PL";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
$toto++ while <$TOTO>;
print "\n";
#print $toto, "\n";
print "There are $toto jobs on hold, check the file : $TOTO \n";
print "\n";
}

sub counting_OI {
my $TOTO = "/apps/meoatlas2/arnaud/jobs_ice.txt_PL";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
$toto++ while <$TOTO>;
print "\n";
#print $toto, "\n";
print "There are $toto jobs on ice, check the file : $TOTO \n";
print "\n";
}

###########################################################################################

sub entete {
my $FILE = "/apps/meoatlas2/arnaud/report.log_PL";
open $FILE, '>', $FILE or die "cannot open '$FILE' : $!";
select $FILE;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
}

###########################################################################################

sub jobs_report_FA {
my $FILE = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";
#only the jobs
my @toto = qx{autorep -j ALL -L0 | grep -w FA | awk '{print \$1}' | awk 1 ORS='|' | sed 's/|\$//'};
qx{autorep -j ALL | grep -w FA | grep -v BOX > ${FILE}};

#foreach my $truc (@toto) {
#   print "####> LES BOXS SUIVANTES SONT EXCLUSES DU RAPPORT <### : $truc";
#}

qx{perl -ni -e 'print unless /@toto/;' ${FILE}};

}

sub jobs_report_RU {
my $FILE = "/apps/meoatlas2/arnaud/jobs_running.txt_PL";
#only the jobs
my @toto = qx{autorep -j ALL -L0 | grep -w RU | awk '{print \$1}' | awk 1 ORS='|' | sed 's/|\$//'};
qx{autorep -j ALL | grep -w RU | grep -v BOX > ${FILE}};

#foreach my $truc (@toto) {
#   print "####> LES BOXS SUIVANTES SONT EXCLUSES DU RAPPORT <### : $truc";
#}

qx{perl -ni -e 'print unless /@toto/;' ${FILE}};

}

sub jobs_report_OH {
my $FILE = "/apps/meoatlas2/arnaud/jobs_hold.txt_PL";
#only the jobs
my @toto = qx{autorep -j ALL -L0 | grep -w OH | awk '{print \$1}' | awk 1 ORS='|' | sed 's/|\$//'};
qx{autorep -j ALL | grep -w OH | grep -v BOX > ${FILE}};

#foreach my $truc (@toto) {
#   print "####> LES BOXS SUIVANTES SONT EXCLUSES DU RAPPORT <### : $truc";
#}

qx{perl -ni -e 'print unless /@toto/;' ${FILE}};

}

sub jobs_report_OI {
my $FILE = "/apps/meoatlas2/arnaud/jobs_ice.txt_PL";
#only the jobs
my @toto = qx{autorep -j ALL -L0 | grep -w OI | awk '{print \$1}' | awk 1 ORS='|' | sed 's/|\$//'};
qx{autorep -j ALL | grep -w OI | grep -v BOX > ${FILE}};

#foreach my $truc (@toto) {
#   print "####> LES BOXS SUIVANTES SONT EXCLUSES DU RAPPORT <### : $truc";
#}

qx{perl -ni -e 'print unless /@toto/;' ${FILE}};

}

###########################################################################################

sub verif_jobs {

my $FILE_LOG = "/apps/meoatlas2/arnaud/report.log_PL";

my $FILE_FA = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";
my $FILE_RU = "/apps/meoatlas2/arnaud/jobs_running.txt_PL";
my $FILE_OH = "/apps/meoatlas2/arnaud/jobs_hold.txt_PL";
my $FILE_OI = "/apps/meoatlas2/arnaud/jobs_ice.txt_PL";

# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $FILE_FA, '<:encoding(UTF-8)', $FILE_FA or die "cannot open file";
select $FILE_FA;
    while (my $line = <$FILE_FA>) {
        if ($line !~ /FA/) {
            open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
            select $FILE_LOG;
            print "\n";
            print "Pas de jobs en erreur\n";
            print "\n";
            print "################################################################### \n";

                } else {

                           open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
                           select $FILE_LOG;
                           #my $DIR = "/apps/meoatlas2/arnaud/";
                           #opendir DIR, $DIR or die "could not open directory: $!";
                           system("ksh rapport_html_FA.ksh")
                           # $toto++ while <$FILE_FA>;
                           & counting_FA;
                           #print "\n";
                           #print "There are $toto jobs in error, check the file : $FILE_FA \n";
                           #print "\n";
                           system("cat $FILE_FA >> $FILE_LOG");
                           print "\n";
                           print "################################################################### \n";
        }
    }

# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $FILE_RU, '<:encoding(UTF-8)', $FILE_RU or die "cannot open file";
select $FILE_RU;
    while (my $line = <$FILE_RU>) {
        if ($line !~ /RU/) {
            open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
            select $FILE_LOG;
            print "\n";
            print "Pas de jobs en running\n";
            print "\n";
            print "################################################################### \n";

                } else {

                           open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
                           select $FILE_LOG;
                           #my $DIR = "/apps/meoatlas2/arnaud/";
                           #opendir DIR, $DIR or die "could not open directory: $!";
                           system("ksh rapport_html_RU.ksh")
                           # $toto++ while <$FILE_RU>;
                           & counting_RU;
                           #print "\n";
                           #print "There are $toto jobs running, check the file : $FILE_RU \n";
                           #print "\n";
                           system("cat $FILE_RU >> $FILE_LOG");
                           print "\n";
                           print "################################################################### \n";
        }
    }

# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $FILE_OH, '<:encoding(UTF-8)', $FILE_OH or die "cannot open file";
select $FILE_OH;
    while (my $line = <$FILE_OH>) {
        if ($line !~ /OH/) {
            open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
            select $FILE_LOG;
            print "\n";
            print "Pas de jobs en hold\n";
            print "\n";
            print "################################################################### \n";

                } else {

                           open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
                           select $FILE_LOG;
                           #my $DIR = "/apps/meoatlas2/arnaud/";
                           #opendir DIR, $DIR or die "could not open directory: $!";
                           system("ksh rapport_html_OH.ksh")
                           # $toto++ while <$FILE_OH>;
                           & counting_OH;
                           #print "\n";
                           #print "There are $toto jobs on hold, check the file : $FILE_OH \n";
                           #print "\n";
                           system("cat $FILE_OH >> $FILE_LOG");
                           print "\n";
                           print "################################################################### \n";
        }
    }

# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $FILE_OI, '<:encoding(UTF-8)', $FILE_OI or die "cannot open file";
select $FILE_OI;
    while (my $line = <$FILE_OI>) {
        if ($line !~ /OI/) {
            open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
            select $FILE_LOG;
            print "\n";
            print "Pas de jobs en ice\n";
            print "\n";
            print "################################################################### \n";

                } else {

                           open $FILE_LOG, '>>', $FILE_LOG or die "cannot open file";
                           select $FILE_LOG;
                           #my $DIR = "/apps/meoatlas2/arnaud/";
                           #opendir DIR, $DIR or die "could not open directory: $!";
                           system("ksh rapport_html_OI.ksh")
                           # $toto++ while <$FILE_OI>;
                           & counting_OI;
                           #print "\n";
                           #print "There are $toto jobs on ice, check the file : $FILE_OI \n";
                           #print "\n";
                           system("cat $FILE_OI >> $FILE_LOG");
                           print "\n";
                           print "################################################################### \n";
                           print "\n";
                           print "#### FIN JOB ${date}_${time} ####\n";
                           print "\n";
                           print "----------------------------------------------------------------------------------------------------------\n";
                           print "----------------------------------------------------------------------------------------------------------\n";

        }
    }
}

###########################################################################################
#
#Main:
#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------

& entete;
& jobs_report_FA;
& jobs_report_RU;
& jobs_report_OH;
& jobs_report_OI;
& verif_jobs;

#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
