#!/bin/ksh

_APPDIR=$(cd `dirname ${0}`/.. ; pwd )
REP_DEST=${_APPDIR}/PATCHS
REP_DEP=${_APPDIR}

InfoMsg()
{
typeset  MSG=$1
echo
echo ">>>  ${MSG}  <<<"
echo
}

MODE=""
[ $# -eq 0 ] && MODE="INTERACTIF"

if [ -x ${_APPDIR}/make_install/MEP_config ]
then 
  . "${_APPDIR}/make_install/MEP_config"
else 
  InfoMsg "#### Pb sur Fichier $_APPDIR/make_install/MEP_config\n" 
  exit 1
fi

FILTRE=${FILTRE:=PATCH*}
ARCHIVE=${ARCHIVE:=tar}
RCP=${RCP:=rcp}
RSH=${RSH:=rsh}
typeset -u ECR_ROLLBACK=${ECR_ROLLBACK:=N}

############ Fonctions Internes ##############

AskChoice()
{
if [ "${MODE}" = "INTERACTIF" ]
  then
    printf " What ? "
    ${DEBUG} read ${1}
  else
    echo "Mode auto"
    eval "${1}"="$2"
fi
}

InstallPatch()
{
if [ "$CHOICE" = "I" ]
  then
  InfoMsg "Recopie du Patch sous ${REP_DEST} de ${PATCH_NAME}"
  ${DEBUG} ${RCP} -p ${USER_SOURCE}@${HOST_SOURCE}:${REP_SOURCE}/${PATCH_NAME} ${REP_DEST}/${PATCH_NAME} > ${ERROR_FILE}
        Error $?
fi

InfoMsg 'Verification de la presence du Patch'
if [ -f ${REP_DEST}/${PATCH_NAME} ]
then
  ${DEBUG} ls -lisa ${REP_DEST}/${PATCH_NAME}
else
  printf "\n\n#### File Patch Absent ${REP_DEST}/${PATCH_NAME} !!!" ; exit 5 
fi

if [ -d ${REP_DEP} ]
then
  ${DEBUG} cd ${REP_DEP}
else
  InfoMsg '#### Repertoire de deploiement KO: ${REP_DEP}'; exit 15;
fi

if [ -f ${REP_DEST}/${PATCH_NAME}.ROLLBACK ]
then
  InfoMsg "#### File .ROLLBACK already here!!" 
  if  [ "x${ECR_ROLLBACK}" != "xY" ]
  then
    ${DEBUG} mv ${REP_DEST}/${PATCH_NAME}.ROLLBACK ${REP_DEST}/${PATCH_NAME}.ROLLBACK.$$
  else
    InfoMsg " Exiting now...\n" ; exit 15
  fi
fi

${DEBUG} touch ${REP_DEST}/${PATCH_NAME}.ROLLBACK || exit 15

$ARCHIVE tf ${REP_DEST}/${PATCH_NAME} | sed s#/$SRC_TRIGRAMME#/$TRIGRAMME#g | sed s/$SRC_DIR/$DIR/g |
        while read f
        do
        if test -f "$f"
        then
           InfoMsg "Insert $f into <<<\n>>>"${PATCH_NAME}".ROLLBACK"
     ${DEBUG} $ARCHIVE uf ${REP_DEST}/${PATCH_NAME}.ROLLBACK $f || exit 15
        fi
        if [ "x$CHOICE" = "xR" ]
        then
           echo "$f" >> ${REP_DEST}/${PATCH_NAME}.listfic
        fi
        done

InfoMsg 'Verification de la presence du Patch de ROLLBACK'
${DEBUG} ls -lisa ${REP_DEST}/${PATCH_NAME}.ROLLBACK

OPT_DECOMP=xvf
if [ "$ARCHIVE" = "tar" ]
then 
  OPT_DECOMP=${OPT_DECOMP}p
fi

InfoMsg "Deploiement de ${PATCH_NAME} <<<\n>>>\t\t dans ${REP_DEP}"
if [ -s ${REP_DEST}/${PATCH_NAME} ]
then
  
  ${DEBUG} pax -r -f ${REP_DEST}/${PATCH_NAME} -s/$SRC_DIR/$DIR/g 
  RETOUR=$?
  if [ $RETOUR -eq 0 ]
  then
    tar tf ${REP_DEST}/${PATCH_NAME} | 
    while read f
    do
      filetomove=`echo $f | sed s/$SRC_DIR/$DIR/`
      filedest=`echo $filetomove | sed s#/$SRC_TRIGRAMME#/$TRIGRAMME#`
      if [ $filetomove != $filedest ]
      then
      mv $filetomove $filedest 2>/dev/null
      fi
      let RETOUR=$RETOUR+$?
    done
  fi
else
  InfoMsg "#### ${REP_DEST}/${PATCH_NAME} est vide !!" 
  exit 21
fi

if [ $RETOUR -ne 0 ]
then
  InfoMsg "#### Erreur lors de la decompression dans la cible ($RETOUR)"
  exit 16
else
  InfoMsg "Deploiement OK de ${PATCH_NAME}"  
fi

if [ "$CHOICE" = "R" ]  # suppression des fichiers en trop
then
  ORI_PATCH_NAME=`basename ${PATCH_NAME} .ROLLBACK`
  #echo "ORI_PATCH_NAME  : $ORI_PATCH_NAME"
  $ARCHIVE tf ${REP_DEST}/${ORI_PATCH_NAME} > ${REP_DEST}/${ORI_PATCH_NAME}.listfic
  diff  ${REP_DEST}/${ORI_PATCH_NAME}.listfic ${REP_DEST}/${PATCH_NAME}.listfic | grep "<" | cut -d " " -f2 |
  while read f
  do
    #echo $f
    if test -f "$f"
    then
    InfoMsg "Delete $f "
    $DEBUG rm -rf $REP_DEP/$f
    fi
  done

  
fi

rm -f ${ERROR_FILE} ${REP_DEST}/${ORI_PATCH_NAME}.listfic ${REP_DEST}/${PATCH_NAME}.listfic

}

function Error
{
  RSHRETOUR=$1
  chmod 777 ${ERROR_FILE}
  #ls -ltra  ${ERROR_FILE}
  #cat  ${ERROR_FILE}
  if [ $RSHRETOUR -ne 0 ]
  then 
        InfoMsg "#### Code Retour de remote command :  $RSHRETOUR"
  exit 6
  fi
  if [ -s ${ERROR_FILE} ]
  then
    egrep -e "No match|No such file or directory|No space|truncate|denied|incorrect" ${ERROR_FILE} > /dev/null
    RETURN=$?
    if [ $RETURN -eq 0 ]
    then
      egrep -e "No match|No such file or directory|No space|truncate|denied|incorrect" ${ERROR_FILE}
      exit 5
    else
      rm -f ${ERROR_FILE}
    fi
  else
    rm -f ${ERROR_FILE}
  fi
}


##############################################

#### MAIN ####

InfoMsg "Liste des Patchs disponibles"
${DEBUG} ${RSH} ${HOST_SOURCE} -l $USER_SOURCE "cd ${REP_SOURCE};ls -ltra ${FILTRE}.${ARCHIVE} | tail -20 "

InfoMsg "Selection du Patch"
AskChoice 'PATCH_NAME' $1

InfoMsg "Installation (i) or RollBack (r)"
AskChoice 'CHOICE' 'i'
typeset -u CHOICE=${CHOICE}

ERROR_FILE=$_APPDIR/make_install/`basename ${PATCH_NAME}`.$$.err
rm -rf ${ERROR_FILE}

export CHOICE PATCH_NAME REP_DEST ARCHIVE

InfoMsg "Visualisation du Patch"
${DEBUG} $RSH ${HOST_SOURCE} -l $USER_SOURCE "$ARCHIVE tvf ${REP_SOURCE}/${PATCH_NAME}" | tee -a ${ERROR_FILE}
Error $?

if [ "$CHOICE" = "R" ]
then
  PATCH_NAME=${PATCH_NAME}.ROLLBACK
fi

if  [ "$CHOICE" = "I" ] ||  [ "$CHOICE" = "R" ] 
then
  InstallPatch
else
  InfoMsg "#### Choix d'option incorrect"
  exit 15
fi

