#***************************************************************
#*               ATLAS-II  UNIX                                *
#*                                                             *
#*  CHAINE   : UTILITAIRES V30x                                *
#*  JOB      : JAXT03                                          *
#*  INTITULE : SAUVEGARDE DES BASES AUTOSYS  AVANT FINJOUR     *
#*                                                             *
#***************************************************************

      #******************************************************************
      #* Test et recuperation de la variable de reprise si passee en $1 *
      #******************************************************************

      #***********************************************************************
      #* Les variables par defaut sont definies dans le fichier valdef       *
      #***********************************************************************


           /apps/oracle/adm/scripts/rman/backupMeo.ksh -s P10973AP10 -t hot -l 0 2>>$A2_LOG
