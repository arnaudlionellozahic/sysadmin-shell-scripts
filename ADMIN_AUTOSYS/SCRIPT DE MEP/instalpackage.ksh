 
 while [[ $sauv != o && $sauv != O &&  $sauv != n &&  $sauv != N ]]
 do
 read sauv?"Voules-vous sauvegarder les composants avant mise en place O/N : "
 done
 rep_job=/apps/hp3/resdata/uf1/packages/MEP/CompApp
 >$rep_job/jobset_en_erreur.log
 date_=$(date +".%Y%m%d.%H%M")
 >$0".log"
 cat $rep_job/liste_package |while read ligne 
  do
     rep=$(echo $ligne |awk '{gsub("au1","uf1",$1);print $1'})
     jobset_tar=$(echo $ligne |awk '{print $2'})
     jobset=$(echo $ligne |awk '{gsub("Nau1","Maro",$2);print $2'})
     if [[ -d $rep ]] then 
         cd $rep 
#         echo $jobset
         # sauvegarde jobset avant extraction
          if [[ -a $jobset ]] then 
          [[ $sauv = O || $sauv = o ]] && cp -p $jobset $jobset".miga6"$date_
            chmod 777 $jobset
          else
            echo $jobset |egrep -q "parm|-irb-|-sp-" 2>&1
            [ $? -ne 0 ] && echo Error 1 $rep $jobset >>$rep_job/jobset_en_erreur.log
          fi
          tar -xvf $rep_job/archives/package_A6.tar $jobset_tar >>$0".log"
          if [[ $? -eq 0 ]] then
            grep -q Nau1 $jobset_tar 
            if  [[ $? -eq 0 ]] then 
               cp  $jobset_tar  $jobset_tar.tmp
               sed "s/Nau1/Maro/g" < $jobset_tar.tmp > $jobset_tar
            fi
            echo $jobset_tar |grep -q "parm" 2>&1
            [ $? -eq 0 ] && mv $jobset_tar $jobset 
          else
           echo Error tar $jobset_tar >>$0".log"
          fi
     else
         echo Error 2 $rep $jobset >>$rep_job/jobset_en_erreur.log
     fi
  done
  cat $rep_job/jobset_en_erreur.log |grep -v "Error 1"
  cd /apps/atlas/atlas2v0/$A2_ENV/site/jobset
#  mv ex-j9f2 ex-j9f2.supprimer
#  mv ex-j9f1 ex-j9f1.supprimer
#  mv ex-dort ex-dort.supprimer
#  mv mwt2.b mwt2
