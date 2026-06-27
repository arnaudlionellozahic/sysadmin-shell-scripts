
 Rep_src="/apps/hp3/resdata/uf1/packages/MEP/Abstract"
 Nom_arch="cde_autosys.tar"
 Date=$(date +".%Y%m%d")

 
 
       if [[ ! -a $Rep_src/$Nom_arch ]] then
         ecrit 'ERREUR: Backup directory not found' > /tmp/$0".log" 2>&1
         exit 1
      fi
      
      cd /tmp > /tmp/$0".log" 2>&1     
      mkdir /tmp/Abs$Date >> /tmp/$0".log" 2>&1
      chmod 777 /tmp/Abs$Date >> /tmp/$0".log" 2>&1
      cd /tmp/Abs$Date >> /tmp/$0".log" 2>&1
      cp -p $Rep_src/$Nom_arch . >> /tmp/$0".log" 2>&1
      tar -xvf $Nom_arch  >> /tmp/$0".log" 2>&1
      ls -ltr autosys | grep "\-r" | awk '{print $9}' > /tmp/Abs$Date/Liste_CABS.txt
            
      cat /tmp/Abs$Date/Liste_CABS.txt |while read i
do

desc=`type $i 2>/dev/null | wc -l`

if [[ $desc -eq 0  ]] then

cp -p /tmp/Abs$Date/autosys/$i /apps/exploit/exploitv3/. >> /tmp/$0".log" 2>&1

else

Chemin=`type $i | awk '{print $3}'| sed "s/\/$i//g"`

mv $Chemin/$i $Chemin/${i}_MEP_autosys >> /tmp/$0".log" 2>&1

cp -p /tmp/Abs$Date/autosys/$i $Chemin/${i} >> /tmp/$0".log" 2>&1

fi

done
      
      
      
      