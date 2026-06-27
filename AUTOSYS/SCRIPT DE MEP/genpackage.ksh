 rep_job=/ficsav/EQUIPE_MEO/outils/A6
 date_="."$(date +"%Y%m%d")
 [ -a $rep_job/package_A6.tar ] && rm $rep_job/package_A6.tar$date_
 >$rep_job/liste_package
 >$rep_job/non_trouve
 cat $rep_job/superbox.csv.Nau1.new| awk '{print $1}' |while read jobset
  do


     car_=$(echo $line  |cut -c 1-1)
     if [[ ! $car_ = "#" ]] then
       [[ -s /apps/atlas/atlas2v0/au1/jobset/$jobset ]] && rep_jobset=/apps/atlas/atlas2v0/au1/jobset           
       [[ -s /apps/orion/031/au1/jobset/$jobset ]] && rep_jobset=/apps/orion/031/au1/jobset                     
       [[ -s /apps/orion/031/au1/site/jobset/$jobset ]] && rep_jobset=/apps/orion/031/au1/site/jobset           
       [[ -s /apps/atlas/atlas2v0/au1/site/jobset/$jobset ]] && rep_jobset=/apps/atlas/atlas2v0/au1/site/jobset 
       [[ -s /apps/ptcom/041/au1/jobset/$jobset ]] && rep_jobset=/apps/ptcom/041/au1/jobset                 
       [[ -s /apps/ptcom/041/au1/site/jobset/$jobset ]] && rep_jobset=/apps/ptcom/041/au1/site/jobset           
       [[ -s /apps/rfper/040/au1/jobset/$jobset ]] && rep_jobset=/apps/rfper/040/au1/jobset                     
       [[ -s /apps/rfper/040/au1/site/jobset/$jobset ]] && rep_jobset=/apps/rfper/040/au1/site/jobset           
       [[ -s /apps/argos/020/au1/jobset/$jobset ]] && rep_jobset=/apps/argos/020/au1/jobset                     
       [[ -s /apps/inter/010/au1/jobset/$jobset ]] && rep_jobset=/apps/inter/010/au1/jobset                     
       [[ -s /apps/inter/010/au1/site/jobset/$jobset ]] && rep_jobset=/apps/inter/010/au1/site/jobset           
       [[ -s /apps/sonar/020/au1/jobset/$jobset ]] && rep_jobset=/apps/sonar/020/au1/jobset                     
       [[ -s /apps/sonar/020/au1/site/jobset/$jobset ]] && rep_jobset=/apps/sonar/020/au1/site/jobset           
       [[ -s /apps/evatl/001/au1/jobset/$jobset ]] && rep_jobset=/apps/evatl/001/au1/jobset
       [[ -s /apps/atlas/atlas2v0/au1/dwhexeunl047/unicenter/jobsets/$jobset ]] && rep_jobset=/apps/atlas/atlas2v0/au1/dwhexeunl047/unicenter/jobsets
       
       echo $rep_jobset $jobset >>$rep_job/liste_package
      
      [ -a /apps/atlas/atlas2v0/au1/jobset/parm/$jobset"Nau1.parm" ] && echo /apps/atlas/atlas2v0/au1/jobset/parm $jobset"Nau1.parm" >>$rep_job/liste_package
      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-$jobset ] && echo /apps/atlas/atlas2v0/au1/site/jobset ex-$jobset >>$rep_job/liste_package
      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-irb-$jobset ] && echo /apps/atlas/atlas2v0/au1/site/jobset ex-irb-$jobset >>$rep_job/liste_package
      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-sp-$jobset ] && echo /apps/atlas/atlas2v0/au1/site/jobset ex-sp-$jobset >>$rep_job/liste_package


#      if [[ ! -a $rep_job/package_A6.tar ]] then
#       tar -cvf $rep_job/package_A6.tar $rep_jobset/$jobset
#      else    
#        tar -uvf $rep_job/package_A6.tar $rep_jobset/$jobset
#      fi
#      [ -a /apps/atlas/atlas2v0/au1/jobset/parm/$jobset"Nau1.parm" ] && tar -uvf $rep_job/package_A6.tar /apps/atlas/atlas2v0/au1/jobset/parm/$jobset"Eau1.parm"
#      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-$jobset ] && tar -uvf $rep_job/package_A6.tar /apps/atlas/atlas2v0/au1/site/jobset/ex-$jobset
#      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-irb-$jobset ] && tar -uvf $rep_job/package_A6.tar /apps/atlas/atlas2v0/au1/site/jobset/ex-irb-$jobset
#      [ -a /apps/atlas/atlas2v0/au1/site/jobset/ex-sp-$jobset ] && tar -uvf $rep_job/package_A6.tar /apps/atlas/atlas2v0/au1/site/jobset/ex-sp-$jobset
     fi
  done
  cat $rep_job/liste_package |while read rep jobset 
do 
  if [[ ! -a $rep_job/package_A6.tar$date_ ]] then 
     cd $rep
     [ -a $rep/$jobset ] && tar -cvf $rep_job/package_A6.tar$date_ -C $rep $jobset 
     [ -a $rep/ex-$jobset ] && tar -cvf $rep_job/package_A6.tar$date_ -C $rep ex-$jobset 
     [ -a ex-*-$jobset ] && tar -cvf $rep_job/package_A6.tar$date_ -C $rep ex-*-$jobset
     [ -a $jobset".parm" ] && tar -cvf $rep_job/package_A6.tar$date_ -C $rep $jobset".parm"
  else
     cd $rep
     [ -a $rep/$jobset ] && tar -uvf $rep_job/package_A6.tar$date_ -C $rep $jobset 
     [ -a $rep/ex-$jobset ] && tar -uvf $rep_job/package_A6.tar$date_ -C $rep ex-$jobset 
     [ -a ex-*-$jobset ] && tar -uvf $rep_job/package_A6.tar$date_ -C $rep ex-*-$jobset
     [ -a $jobset".parm" ] && tar -uvf $rep_job/package_A6.tar$date_ -C $rep $jobset".parm"
  fi
  [ ! -a $rep/$jobset ] && echo $rep/$jobset >>$rep_job/non_trouve
done
>$rep_job/list_jcl_tag_A6
while read i
do

EAD=`echo $i | cut -d '|' -f1`
Ver=`echo $i | cut -d '|' -f2`


if [[ $EAD = "adoat"  ]] then
EAD="atlas"
Ver="atlas2v0"
fi

Rep=`echo /apps/$EAD/$Ver/au1`
find $Rep -name "*.A6.*" -type f |grep -v jobset | awk -F"/" '{job=$NF;$NF="";gsub(" ","/",$0);print $0,job}' | sed  "s/\/ / /" >>$rep_job/list_jcl_tag_A6

done < $A2_FIC/EAD_PTECHNIC

cat $rep_job/list_jcl_tag_A6 |while read rep jcl
do
 job=$(echo $jcl | awk -F ".A6" '{print $1}')
 echo $rep $job >>$rep_job/liste_package
 tar -uvf $rep_job/package_A6.tar$date_ -C $rep $job
done

cp $rep_job/liste_package  /apps/hp3/resdata/au1/packages/Solution/PourProd/Packages
cp $rep_job/package_A6.tar$date_ /apps/hp3/resdata/au1/packages/Solution/PourProd/Packages

# cd /apps/atlas/atlas2v0/au1/jobset/parm
# [ -a $rep_job/all_rep_parm.tar.Z ] && rm $rep_job/all_rep_parm.tar.Z$date_
# gtar -czvf $rep_job/all_rep_parm.tar.Z$date_ *

