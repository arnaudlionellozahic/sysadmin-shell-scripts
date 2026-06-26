#!/usr/bin/python

import os,sys
import time
import datetime
from subprocess import Popen,PIPE,STDOUT,call

#lanceur C:\Exploit_BNP\DEV\PYTHON\Portable_Python_3.2.5.1\App\python.exe

DATE = datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S')

REP = "/ficsav/EQUIPE_MEO/arnaud/"
print REP

TEMP_FA=REP + "TEMP_FA.txt_PY"
FILE_FA=REP + "jobs_FA.txt_PY"

FILE_LOG=REP + "report.log_PY"

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

##################################################################################
#EXTRACTION DES JOBS
##################################################################################

def jobs_report_FA ():
    # grep exclusion written in python 
    
    #os.system("autorep -j ALL | grep -w FA  > /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w FA | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words
    
    #with open(TEMP_FA, "r") as oldfile:
        #with open(FILE_FA, "w") as newfile:
            #for line in oldfile:
                #if not any(bad_word in line for bad_word in bad_words):
                     #newfile.write(line)

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w FA | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY")
    os.system("autorep -j ALL | grep -w FA | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_FA.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY")


##################################################################################
#VERIFICATIONS
##################################################################################

def verif_jobs ():
    failed = open(FILE_FA)
    out = open(FILE_LOG, 'w')

    # COMPTAGE
    toto=0
    for a_line in failed:
        if "FA" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs in error, check the file : ')
        out.write(FILE_FA)
        out.write(' \n\n')

        failed = open(FILE_FA)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in failed.readlines():
            if "FA" in line:    out.write(line)

        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

    else:
        out.write('Pas de jobs en erreur\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')


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
print ("\n################### LIST_AUTOSYS_OBJECTS #######################\n")
print ("----------------------------------------------------------------")
print ("----------------------------------------------------------------")


jobs_report_FA()
print "sleep 20"
time.sleep(20)
verif_jobs()


#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#print (exit $?\n")
#exit $?;

