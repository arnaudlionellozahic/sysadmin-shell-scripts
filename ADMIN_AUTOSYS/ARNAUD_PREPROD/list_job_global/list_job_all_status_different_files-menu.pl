#!/usr/bin/perl -w

use strict; use warnings; use 5.8.8; use autodie;
no strict 'refs';

use POSIX qw/strftime/;
my $date = strftime("%Y-%m-%d", localtime());
my $time = strftime("%H:%M:%S", localtime());


#################
#MENU
#################

sub printMenu {
print "\n"; print "             AUTOSYS JOB'S STATUS           \n";
print "
0/ JOBS IN FAILED
1/ JOBS IN RUNNING
2/ JOBS ON HOLD
3/ JOBS ON ICE
q/ Quitter l'execution

Veuillez rentrez votre choix:
";
}

my $response = "";
while ($response !~ /[qQ]/ ) {
  printMenu();
  $response = <STDIN>;
  chomp($response);
  print "Vous avez choisi : $response\n";

  if ( $response =~ 0) {
        & jobs_failed;
  } elsif ( $response =~ 1) {
        & jobs_running;
  } elsif ( $response =~ 2) {
        & jobs_hold;
  } elsif ( $response =~ 3) {
        & jobs_ice;
  } elsif ( $response =~ /[qQ]/ ) {
        print "ALLER BOIRE UN CAFE puis VERIFIER que tout soit VERT"; exit 0;
  }
  else {
        print "Choix inconnu !\n";
  }
}


#################
#FUNCTIONS
#################

sub counting_FA {
my $TOTO = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";

my $toto = 0;
open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
$toto++ while <$TOTO>;
close $TOTO;
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
close $TOTO;
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
close $TOTO;
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
close $TOTO;
print "\n";
#print $toto, "\n";
print "There are $toto jobs on ice, check the file : $TOTO \n";
print "\n";
}

###########################################################################################

sub entete_FA {
my $FILE = "/apps/meoatlas2/arnaud/report_error.txt_PL";
open $FILE, '>', $FILE or die "cannot open '$FILE' : $!";
select $FILE;
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
close $FILE;
}

sub entete_RU {
my $FILE = "/apps/meoatlas2/arnaud/report_running.txt_PL";
open $FILE, '>', $FILE or die "cannot open '$FILE' : $!";
select $FILE;
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
close $FILE;
}

sub entete_OH {
my $FILE = "/apps/meoatlas2/arnaud/report_hold.txt_PL";
open $FILE, '>', $FILE or die "cannot open '$FILE' : $!";
select $FILE;
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
close $FILE;
}

sub entete_OI {
my $FILE = "/apps/meoatlas2/arnaud/report_ice.txt_PL";
open $FILE, '>', $FILE or die "cannot open '$FILE' : $!";
select $FILE;
print "Report of the autosys jobs le ${date} a ${time} \n";
print "\n";
print "################################################################### \n";
close $FILE;
}

###########################################################################################

sub jobs_report_FA {
my $FILE = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";
#system("autorep -j ALL | awk '$0 ~/\<FA\>/' > ${FILE}");
system("autorep -j ALL | grep -w FA > ${FILE}");
}

sub jobs_report_RU {
my $FILE = "/apps/meoatlas2/arnaud/jobs_running.txt_PL";
#system("autorep -j ALL | awk '$0 ~/\<RU\>/' > ${FILE}");
system("autorep -j ALL | grep -w RU > ${FILE}");
}

sub jobs_report_OH {
my $FILE = "/apps/meoatlas2/arnaud/jobs_hold.txt_PL";
#system("autorep -j ALL | awk '$0 ~/\<OH\>/' > ${FILE}");
system("autorep -j ALL | grep -w OH > ${FILE}");
}

sub jobs_report_OI {
my $FILE = "/apps/meoatlas2/arnaud/jobs_ice.txt_PL";
#system("autorep -j ALL | awk '$0 ~/\<OH\>/' > ${FILE}");
system("autorep -j ALL | grep -w OI > ${FILE}");
}

###########################################################################################

sub verif_FA {

my $FILE = "/apps/meoatlas2/arnaud/report_error.txt_PL";
my $TOTO = "/apps/meoatlas2/arnaud/jobs_error.txt_PL";
my $FH = "/apps/meoatlas2/arnaud/log_error.txt_PL";
# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
select $TOTO;
    while (my $line = <$TOTO>) {
        if ($line =~ /FA/) {
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            select $FILE;
            #my $DIR = "/apps/meoatlas2/arnaud/";
            #opendir DIR, $DIR or die "could not open directory: $!";
            #system("ksh rapport_html_all.ksh")
            # $toto++ while <$TOTO>;
            & counting_FA;
            #print "\n";
            #print "There are $toto jobs in error, check the file : $TOTO \n";
            #print "\n";
            close $FILE;
            system("cat $TOTO >> $FILE");
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            print "\n";
            print "------------------------------------------------------------------- \n";
            print "\n";
            open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
            #exit 5;

                } else {

                       open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
                       select $FILE;
                       print "\n";
                       print "Pas de jobs en erreur\n";
                       print "\n";
                       print "-------------------------------------------------------------------\n";
                       open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
                       #exit 0;

        }
    }
}

###########################################################################################

sub verif_RU {

my $FILE = "/apps/meoatlas2/arnaud/report_running.txt_PL";
my $TOTO = "/apps/meoatlas2/arnaud/jobs_running.txt_PL";
my $FH = "/apps/meoatlas2/arnaud/log_running.txt_PL";
# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open '$TOTO' : $!";
select $TOTO;
    while (my $line = <$TOTO>) {
        if ($line =~ /RU/) {
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            select $FILE;
            #my $DIR = "/apps/meoatlas2/arnaud/";
            #opendir DIR, $DIR or die "could not open directory: $!";
            #system("ksh rapport_html_all.ksh")
            # $toto++ while <$TOTO>;
            & counting_RU;
            #print "\n";
            #print "There are $toto jobs running, check the file : $TOTO \n";
            #print "\n";
            close $FILE;
            system("cat $TOTO >> $FILE");
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            print "\n";
            print "------------------------------------------------------------------- \n";
            print "\n";
            open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
            #exit 5;

                } else {

                       open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
                       select $FILE;
                       print "\n";
                       print "Pas de jobs en running\n";
                       print "\n";
                       print "-------------------------------------------------------------------\n";
                       open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
                       #exit 0;

        }
    }
}

###########################################################################################

sub verif_OH {

my $FILE = "/apps/meoatlas2/arnaud/report_hold.txt_PL";
my $TOTO = "/apps/meoatlas2/arnaud/jobs_hold.txt_PL";
my $FH = "/apps/meoatlas2/arnaud/log_hold.txt_PL";
# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open $TOTO : $!";
select $TOTO;
    while (my $line = <$TOTO>) {
        if ($line =~ /OH/) {
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            select $FILE;
            #my $DIR = "/apps/meoatlas2/arnaud/";
            #opendir DIR, $DIR or die "could not open directory: $!";
            #system("ksh rapport_html_all.ksh")
            # $toto++ while <$TOTO>;
            & counting_OH;
            #print "\n";
            #print "There are $toto jobs on hold, check the file : $TOTO \n";
            #print "\n";
            close $FILE;
            system("cat $TOTO >> $FILE");
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            print "\n";
            print "------------------------------------------------------------------- \n";
            print "\n";
            open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
            #exit 5;

                } else {

                       open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
                       select $FILE;
                       print "\n";
                       print "Pas de jobs en hold\n";
                       print "\n";
                       print "-------------------------------------------------------------------\n";
                       open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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
                       #exit 0;

        }
    }
}

###########################################################################################

sub verif_OI {

my $FILE = "/apps/meoatlas2/arnaud/report_ice.txt_PL";
my $TOTO = "/apps/meoatlas2/arnaud/jobs_ice.txt_PL";
my $FH = "/apps/meoatlas2/arnaud/log_ice.txt_PL";
# initialiser a 1 ou compter le nb de lignes du fichier apres
#my $toto=0;

open $TOTO, '<:encoding(UTF-8)', $TOTO or die "cannot open $TOTO : $!";
select $TOTO;
    while (my $line = <$TOTO>) {
        if ($line =~ /OI/) {
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            select $FILE;
            #my $DIR = "/apps/meoatlas2/arnaud/";
            #opendir DIR, $DIR or die "could not open directory: $!";
            #system("ksh rapport_html_all.ksh")
            # $toto++ while <$TOTO>;
            & counting_OI;
            #print "\n";
            #print "There are $toto jobs on ice, check the file : $TOTO \n";
            #print "\n";
            close $FILE;
            system("cat $TOTO >> $FILE");
            open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
            print "\n";
            print "------------------------------------------------------------------- \n";
            print "\n";
            open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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

                       open $FILE, '>>', $FILE or die "cannot open '$FILE' : $!";
                       select $FILE;
                       print "\n";
                       print "Pas de jobs en ice\n";
                       print "\n";
                       print "-------------------------------------------------------------------\n";
                       open $FH, '>>', $FH or die "cannot open '$FH' : $!";
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

###########################################################################################
#
#Main:
#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------

sub jobs_failed {
open (FH, '>', '/apps/meoatlas2/arnaud/log_error.txt_PL') or die "cannot open file";
select FH;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
close FH;

& entete_FA;
& jobs_report_FA;
& verif_FA;
}

###########################################################################################

sub jobs_running {
open (FH, '>', '/apps/meoatlas2/arnaud/log_running.txt_PL') or die "cannot open file";
select FH;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
close FH;

& entete_RU;
& jobs_report_RU;
& verif_RU;
}

###########################################################################################

sub jobs_hold {
open (FH, '>', '/apps/meoatlas2/arnaud/jobs_hold.txt_PL') or die "cannot open file";
select FH;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
close FH;

& entete_OH;
& jobs_report_OH;
& verif_OH;
}

###########################################################################################

sub jobs_ice {
open (FH, '>', '/apps/meoatlas2/arnaud/log_ice.txt_PL') or die "cannot open file";
select FH;
print "----------------------------------------------------------------------------------------------------------\n";
print "----------------------------------------------------------------------------------------------------------\n";
print "\n";
print "#### DEBUT JOB ${date}_${time} ####\n";
print "\n";
close FH;

& entete_OI;
& jobs_report_OI;
& verif_OI;
}
