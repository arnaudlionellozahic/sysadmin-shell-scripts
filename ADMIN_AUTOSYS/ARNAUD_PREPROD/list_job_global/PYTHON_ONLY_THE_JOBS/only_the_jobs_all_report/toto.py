#!/usr/bin/python

import os,sys
import time
import datetime
from subprocess import Popen,PIPE,STDOUT,call

#lanceur C:\Exploit_BNP\DEV\PYTHON\Portable_Python_3.2.5.1\App\python.exe

DATE = datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S')

REP = "/ficsav/EQUIPE_MEO/arnaud/"
print REP

FILE_FA=REP + "jobs_FA.txt_PY"
FILE_RU=REP + "jobs_RU.txt_PY"
FILE_OH=REP + "jobs_OH.txt_PY"
FILE_OI=REP + "jobs_OI.txt_PY"

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

#################
#FUNCTIONS
#################

def entete ():
    with open(FILE_LOG, 'w') as fout:
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
    os.system("autorep -j ALL | grep -w FA | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_FA.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY")

def jobs_report_RU ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w RU  > /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w RU | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w RU | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")
    os.system("autorep -j ALL | grep -w RU | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_RU.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")

def jobs_report_OH ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w OH  > /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w OH | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w OH | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")
    os.system("autorep -j ALL | grep -w OH | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_OH.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")

def jobs_report_OI ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w OI  > /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w OI | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w OI | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")
    os.system("autorep -j ALL | grep -w OI | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_OI.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")

    #proc=Popen("autorep -j ALL -L0 | grep -w FA | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//'", shell=True, stdout=PIPE, )
    #output=proc.communicate()[0]
    #print output

    #verif_jobs()

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

#########################################################################################

    running = open(FILE_RU)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in running:
        if "RU" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs running, check the file : ')
        out.write(FILE_RU)
        out.write(' \n\n')

        running = open(FILE_RU)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in running.readlines():
            if "RU" in line:    out.write(line)

        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

    else:
        out.write('Pas de jobs en running\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

#########################################################################################

    onhold = open(FILE_OH)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in onhold:
        if "OH" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on hold, check the file : ')
        out.write(FILE_OH)
        out.write(' \n\n')

        onhold = open(FILE_OH)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in onhold.readlines():
            if "OH" in line:    out.write(line)
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

    else:
        out.write("Pas de jobs en hold\n")
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

#########################################################################################

    onice = open(FILE_OI)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in onice:
        if "OI" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on ice, check the file : ')
        out.write(FILE_OI)
        out.write(" \n\n")

        onice = open(FILE_OI)
        out = open(FILE_LOG, 'a')

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

print "sleep 30"
time.sleep(30)

verif_jobs()

os.system("ksh rapport_html_FA.ksh")
os.system("ksh rapport_html_RU.ksh")
os.system("ksh rapport_html_OH.ksh")
os.system("ksh rapport_html_OI.ksh")


#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#print (exit $?\n")
#exit $?;


root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud # ^C
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud #
root@s00vl9941381:/ficsav/EQUIPE_MEO/arnaud # cat toto.py
#!/usr/bin/python

import os,sys
import time
import datetime
from subprocess import Popen,PIPE,STDOUT,call

#lanceur C:\Exploit_BNP\DEV\PYTHON\Portable_Python_3.2.5.1\App\python.exe

DATE = datetime.datetime.now().strftime('%Y-%m-%d a %H:%M:%S')

REP = "/ficsav/EQUIPE_MEO/arnaud/"
print REP

FILE_FA=REP + "jobs_FA.txt_PY"
FILE_RU=REP + "jobs_RU.txt_PY"
FILE_OH=REP + "jobs_OH.txt_PY"
FILE_OI=REP + "jobs_OI.txt_PY"

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

#################
#FUNCTIONS
#################

def entete ():
    with open(FILE_LOG, 'w') as fout:
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
    os.system("autorep -j ALL | grep -w FA | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_FA.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_FA.txt_PY")

def jobs_report_RU ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w RU  > /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w RU | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w RU | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")
    os.system("autorep -j ALL | grep -w RU | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_RU.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_RU.txt_PY")

def jobs_report_OH ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w OH  > /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w OH | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w OH | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")
    os.system("autorep -j ALL | grep -w OH | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_OH.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_OH.txt_PY")

def jobs_report_OI ():
    # grep exclusion written in python

    #os.system("autorep -j ALL | grep -w OI  > /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")

    proc=Popen("autorep -j ALL -L0 | grep -w OI | awk '{print $1}' | awk 1 ORS=',' | sed 's/^/[\"/' | sed 's/,$/\"]/' | sed 's/,/\",\"/g' " , shell=True, stdout=PIPE )
    bad_words=proc.communicate()[0]
    print bad_words

    #SI GREP NON REUSSI
    os.system("autorep -j ALL -L0 | grep -w OI | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//' > /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")
    os.system("autorep -j ALL | grep -w OI | egrep -v 'BOX|sb_' | egrep -v `cat /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY` > /ficsav/EQUIPE_MEO/arnaud/jobs_OI.txt_PY")
    os.system("rm -f /ficsav/EQUIPE_MEO/arnaud/TEMP_OI.txt_PY")

    #proc=Popen("autorep -j ALL -L0 | grep -w FA | awk '{print $1}' | awk 1 ORS='|' | sed 's/|$//'", shell=True, stdout=PIPE, )
    #output=proc.communicate()[0]
    #print output

    #verif_jobs()

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
        os.system("ksh /ficsav/EQUIPE_MEO/arnaud/rapport_html_FA.ksh")
		
    else:
        out.write('Pas de jobs en erreur\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

#########################################################################################

    running = open(FILE_RU)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in running:
        if "RU" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs running, check the file : ')
        out.write(FILE_RU)
        out.write(' \n\n')

        running = open(FILE_RU)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in running.readlines():
            if "RU" in line:    out.write(line)

        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        os.system("ksh /ficsav/EQUIPE_MEO/arnaud/rapport_html_RU.ksh")
		
    else:
        out.write('Pas de jobs en running\n')
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

#########################################################################################

    onhold = open(FILE_OH)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in onhold:
        if "OH" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on hold, check the file : ')
        out.write(FILE_OH)
        out.write(' \n\n')

        onhold = open(FILE_OH)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in onhold.readlines():
            if "OH" in line:    out.write(line)
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
        os.system("ksh /ficsav/EQUIPE_MEO/arnaud/rapport_html_OH.ksh")
		
    else:
        out.write("Pas de jobs en hold\n")
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')

#########################################################################################

    onice = open(FILE_OI)
    out = open(FILE_LOG, 'a')

    # COMPTAGE
    toto=0
    for a_line in onice:
        if "OI" in a_line:    toto += 1

    if (toto) > 1:
        out.write(datetime.datetime.now().strftime('Report of the autosys jobs le %Y-%m-%d a %H:%M:%S'))
        out.write(' \n\n')
        out.write('-------------------------------------------------------------------\n\n')

        out.write('There are ')
        out.write(str(toto))
        out.write(' jobs on ice, check the file : ')
        out.write(FILE_OI)
        out.write(" \n\n")

        onice = open(FILE_OI)
        out = open(FILE_LOG, 'a')

        # ECRITURE
        for line in onice.readlines():
            if "OI" in line:    out.write(line)
        out.write(' \n')
        out.write('###################################################################\n')
        out.write(' \n')
		os.system("ksh /ficsav/EQUIPE_MEO/arnaud/rapport_html_OI.ksh")
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

print "sleep 30"
time.sleep(30)

verif_jobs()


#-------------------------------------------------------------------
# Fin du job proprement dit
#-------------------------------------------------------------------
#print (exit $?\n")
#exit $?;
