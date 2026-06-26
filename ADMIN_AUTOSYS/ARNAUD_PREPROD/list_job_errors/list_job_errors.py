#!/usr/bin/python

import os,sys
import time
import datetime
import subprocess

#lanceur C:\Exploit_BNP\DEV\PYTHON\Portable_Python_3.2.5.1\App\python.exe

DATE = datetime.datetime.now().strftime('%Y-%m-%d at %H:%M:%S')

REP = "/apps/meoatlas2/arnaud";
FILE = "${REP}/auto113_processes.log";

###########################################################################################

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

###########################################################################################

#################
#FUNCTIONS
#################

def entete ():
    with open('/apps/meoatlas2/arnaud/jobs_error.log', mode='w') as f:
        f.write('Report of the autosys jobs the ' + DATE + '\n\n')
        f.write('###################################################################\n\n')

def jobs_report ():
    REP = "/apps/meoatlas2/arnaud";
    REPORT = "${REP}/report.txt";
    print ("JOBS_ERRORS\n")
    os.system('autorep -j ALL | grep FA > /apps/meoatlas2/arnaud/error.txt');
    print ("----------------------------------------------------------------")
    print ("----------------------------------------------------------------")

def verif ():
    error = open('/apps/meoatlas2/arnaud/error.txt')
    out = open('/apps/meoatlas2/arnaud/jobs_error.log' , 'a')

    print ("")
    print ("verif_error_jobs\n")
    toto=0
    for line in error:
        if "FA" in line:    toto+=1

    if (toto) > 1:
        out.write('There are ' +str(toto)+ ' jobs in error, check the file : /apps/meoatlas2/arnaud/error.txt \n\n')
        print ('Il y a ' +str(toto)+ ' jobs en statut FAILED')
        print ("")

        error = open('/apps/meoatlas2/arnaud/error.txt')
        out = open('/apps/meoatlas2/arnaud/jobs_error.log' , 'a')

        for line in error.readlines():
            if "FA" in line:
                out.write(line)

    else:    print ('Pas de jobs en statut FAILED')

    out.write("\n------------------------------------------------------------------- \n\n")


	
##Main:
#######################
##LANCEMENT DU SCRIPT##
#######################
#-------------------------------------------------------------------
# Debut du job
#-------------------------------------------------------------------
#print ("----------------------------------------------------------------------------------------------------------")
#print ("----------------------------------------------------------------------------------------------------------")
print ("\n")
# today = datetime.date.today()
# print today.strftime('We are the %d, %b %Y')
print ("#### DEBUT JOB ####")
print (DATE)
print ("\n")

print ("----------------------------------------------------------------")
print ("----------------------------------------------------------------")
print ("\n################### LIST JOBS BY STATUS #######################\n")
print ("----------------------------------------------------------------")
print ("----------------------------------------------------------------")

entete()
jobs_report()
verif()

print ("\n")
print (DATE)
print ("#### FIN JOB ####\n")
#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#print (exit $?\n")
#exit $?;