#!/usr/bin/perl -w

use strict; use warnings; use 5.8.8;
no strict 'refs';

use POSIX qw/strftime/;
my $date = strftime("%Y-%m-%d", localtime());
my $time = strftime("%H:%M:%S", localtime());


#################
#FUNCTIONS
#################

sub entete {
my $FILE = "/apps/meoatlas2/arnaud/jobs_error.log";
open $FILE, '>', $FILE or die "cannot open file";
select $FILE;
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
close $FILE;

}

sub jobs_report {
my $FILE = "/apps/meoatlas2/arnaud/report.txt";
system("autorep -j ALL | grep FA > ${FILE}");
}

sub verif {

my $FILE = "/apps/meoatlas2/arnaud/jobs_error.log";
my $TOTO = "/apps/meoatlas2/arnaud/report.txt";
my $FH = "/apps/meoatlas2/arnaud/log.txt";
# initialiser a 1 ou compter le nb de lignes du fichier apres -- sinon 1 job en moins
my $toto=1;

open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open file";
select $TOTO;
    while (my $line = <$TOTO>) {
        if ($line =~ /FA/) {
            open $FILE, '>>', $FILE or die "cannot open file";
            select $FILE;
            #my $DIR = "/apps/meoatlas2/arnaud/";
            #opendir DIR, $DIR or die "could not open directory: $!";
            #system("ksh rapport_html_all.ksh")
            $toto++ while <$TOTO>;
            print "\n";
            print "There are $toto jobs in error, check the file : $TOTO \n";
            print "\n";
            close $FILE;
            system("cat $TOTO >> $FILE");
            open $FILE, '>>', $FILE or die "cannot open file";
            print "\n";
            print "------------------------------------------------------------------- \n";
            print "\n";
            open $FH, '>>', $FH or die "cannot open file";
            select $FH;
            print "\n";
            print "#### FIN JOB ${date}_${time} ####\n";
            # -------------------------------------------------------------------
            # Fin du job proprement dit
            #-------------------------------------------------------------------
            print "exit 5\n";
            close $FILE;
            close $FH;
            close $TOTO;
            exit 5;

                } else {

                       open $FILE, '>>', $FILE or die "cannot open file";
                       select $FILE;
                       print "\n";
                       print "Pas de jobs en erreur\n";
                       print "\n";
                       print "-------------------------------------------------------------------\n";
                       open $FH, '>>', $FH or die "cannot open file";
                       select $FH;
                       print "\n";
                       print "#### FIN JOB ${date}_${time} ####\n";
                       #-------------------------------------------------------------------
                       # Fin du job proprement dit
                       #-------------------------------------------------------------------
                       print "exit 0\n";
                       close $FILE;
                       close $FH;
                       close $TOTO;
                       exit 0;

        }
    }
}


#Main:
#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------
open (FH, '>', '/apps/meoatlas2/arnaud/log.txt') or die "cannot open file";
select FH;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
close FH;

& entete;
& jobs_report;
& verif;
