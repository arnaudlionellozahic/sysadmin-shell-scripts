CHEMIN=/apps/hp3/resdata/uf1/packages/MEP
DATE=$(date "+%Y%m%d")
exec 1>${CHEMIN}/CompApp/misenplace.log
exec 2>&1
cd $CHEMIN/Composants
if [[ ! -d $CHEMIN/Composants/definitif ]]
then
mkdir ${CHEMIN}/Composants/definitif
chmod 777 ${CHEMIN}/Composants/definitif
fi

cd ${CHEMIN}/Composants/definitif
gtar xzvf ${CHEMIN}/Composants/job.tgz

 for i in $(ls)
 do
 a=$(type $i |awk '{print $3}')
 arbo=$(echo $a |sed s/$i//g)
 cp -p $a ${a}_$DATE
 echo "cp -p $a ${a}_$DATE"

  if [[ $? -eq 0 ]]
  then
  cp -p $i $arbo
	if [[ $? -eq 0 ]]
	then
  	echo "job $i : $arbo ok"
	else
	echo "job $i : $arbo KO"
	fi
  fi

 done
