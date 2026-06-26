#!/usr/bin/python

import os,sys
import time
import datetime

#lanceur C:\Exploit_BNP\DEV\PYTHON\Portable_Python_3.2.5.1\App\python.exe

DATE = datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S')

REP = "/ficsav/EQUIPE_MEO/arnaud/"
print REP

FILE_FA=REP + "jobs_FA.txt_PY"
FILE_RU=REP + "jobs_RU.txt_PY"
FILE_OH=REP + "jobs_OH.txt_PY"
FILE_OI=REP + "jobs_OI.txt_PY"

FILE_LOG_FA=REP + "report_FA.log_PY"
FILE_LOG_RU=REP + "report_RU.log_PY"
FILE_LOG_OH=REP + "report_OH.log_PY"
FILE_LOG_OI=REP + "report_OI.log_PY"

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

#################
#FUNCTIONS
#################

def entete_FA ():
    with open(FILE_LOG_FA, 'w') as fout:
        fout.write('Report of the autosys jobs le ')
        fout.write(DATE)
        fout.write(' \n\n')
        fout.write('################################################################### \n\n')

        ##TEST
        ##fout = open(FILE_LOG_FA, 'r')
        ##fout.read()
        ##
        ##fout = open(FILE_LOG_FA, 'w')
        ##fout.write('Report of the autosys jobs le ')
        ##fout.write(DATE)
        ##fout.write(' \n\n')
        ##fout.write('################################################################### \n\n')
        ##
        ##LANCER LA FONCTION
        ##print entete_FA()

def entete_RU ():
    with open(FILE_LOG_RU, 'w') as fout:
        fout.write('Report of the autosys jobs le ')
        fout.write(DATE)
        fout.write(' \n\n')
        fout.write('################################################################### \n\n')

def entete_OH ():
    with open(FILE_LOG_OH, 'w') as fout:
        fout.write('Report of the autosys jobs le ')
        fout.write(DATE)
        fout.write(' \n\n')
        fout.write('################################################################### \n\n')

def entete_OI ():
    with open(FILE_LOG_OI, 'w') as fout:
        fout.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        fout.write(' \n\n')
        fout.write('################################################################### \n\n')

		
##################################################################################
#EXTRACTION DES JOBS
##################################################################################

def jobs_report_FA ():
    os.system('autorep -j ALL | grep -w FA > /ficsav/EQUIPE_MEO/arnaud/jobs_FA.txt_PY')
    verif_jobs_FA()

def jobs_report_RU ():
    os.system('autorep -j ALL | grep -w RU > /ficsav/EQUIPE_MEO/arnaud/jobs_RU.txt_PY')
    verif_jobs_RU()

def jobs_report_OH ():
    os.system('autorep -j ALL | grep -w OH > /ficsav/EQUIPE_MEO/arnaud/jobs_OH.txt_PY')
    verif_jobs_OH()

def jobs_report_OI ():
    os.system('autorep -j ALL | grep -w OI > /ficsav/EQUIPE_MEO/arnaud/jobs_OI.txt_PY')
    verif_jobs_OI()

##################################################################################
#VERIFICATIONS
##################################################################################

def verif_jobs_FA ():
    failed = open(FILE_FA)
    out = open(FILE_LOG_FA, 'w')

    # COMPTAGE
    toto=0
    for a_line in failed:
        if "FA" in a_line:    toto += 1

    if (toto) > 1:
        out.write('Report of the autosys jobs le ')
        out.write(DATE)
        out.write(' \n\n')
        out.write('################################################################### \n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs in error, check the file : ')
        out.write(FILE_FA)
        out.write(' \n\n')

        failed = open(FILE_FA)
        out = open(FILE_LOG_FA, 'a')

        # ECRITURE
        for line in failed.readlines():
            if "FA" in line:    out.write(line)

        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')

    else:
        out.write('Pas de jobs en erreur\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')


def verif_jobs_RU ():
    running = open(FILE_RU)
    out = open(FILE_LOG_RU, 'w')

    # COMPTAGE
    toto=0
    for a_line in running:
        if "RU" in a_line:    toto += 1

    if (toto) > 1:
        out.write('Report of the autosys jobs le ')
        out.write(DATE)
        out.write(' \n\n')
        out.write('################################################################### \n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs running, check the file : ')
        out.write(FILE_RU)
        out.write(' \n\n')

        running = open(FILE_RU)
        out = open(FILE_LOG_RU, 'a')

        # ECRITURE
        for line in running.readlines():
            if "RU" in line:    out.write(line)

        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')

    else:
        out.write('Pas de jobs en running\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')


def verif_jobs_OH ():
    onhold = open(FILE_OH)
    out = open(FILE_LOG_OH, 'w')

    # COMPTAGE
    toto=0
    for a_line in onhold:
        if "OH" in a_line:    toto += 1

    if (toto) > 1:
        out.write('Report of the autosys jobs le ')
        out.write(DATE)
        out.write(' \n\n')
        out.write('################################################################### \n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on hold, check the file : ')
        out.write(FILE_OH)
        out.write(' \n\n')

        onhold = open(FILE_OH)
        out = open(FILE_LOG_OH, 'a')

        # ECRITURE
        for line in onhold.readlines():
            if "OH" in line:    out.write(line)
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')

    else:
        out.write("Pas de jobs en hold\n")
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')


def verif_jobs_OI ():
    onice = open(FILE_OI)
    out = open(FILE_LOG_OI, 'w')

    # COMPTAGE
    toto=0
    for a_line in onice:
        if "OI" in a_line:    toto += 1

    if (toto) > 1:
        out.write('Report of the autosys jobs le ')
        out.write(DATE)
        out.write(' \n\n')
        out.write('################################################################### \n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on ice, check the file : ')
        out.write(FILE_OI)
        out.write(" \n\n")

        onice = open(FILE_OI)
        out = open(FILE_LOG_OI, 'a')

        # ECRITURE
        for line in onice.readlines():
            if "OI" in line:    out.write(line)
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        print ("\n")
        print (DATE)
        print ("#### FIN JOB ####\n")
        sys.exit(0)

    else:
        out.write("Pas de jobs on ice\n")
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        out.write('#### FIN JOB ')
        out.write(datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        out.write(' ####\n')
        out.write(' \n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        out.write('----------------------------------------------------------------------------------------------------------\n')
        print ("\n")
        print (datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S'))
        print ("#### FIN JOB ####\n")
        sys.exit(0)


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
jobs_report_RU()
jobs_report_OH()
jobs_report_OI()


#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#print (exit $?\n")
#exit $?;
