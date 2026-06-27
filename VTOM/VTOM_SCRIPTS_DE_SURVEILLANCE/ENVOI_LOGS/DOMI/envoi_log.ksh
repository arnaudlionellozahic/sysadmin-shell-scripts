req () 
{ 
#COLIPOST 
ssh lpn1e94 <<EOF 2> /dev/null 
su - vtom 
cd /opt/vtom/sgbd/bin 
./req_err_callisto2_pj 
EOF 
} 


#user=dominique.julien.externe@steria.com 
#cuser=dominique.julien.externe@steria.com 

# COLIPOSTE 

user=tlt_callisto2_support_technique 
cuser="telintrans-bt-clp@steria.com" 
liste=`req` 
echo $liste 

#user=dominique.julien.externe@steria.com 

for f in $liste 
do 
ls /root/DOMI/tmp/$f.o ;cr=$? 
if [ "$cr" != "0" ] 
then 
 scp 10.34.72.81:/opt/vtom/logs/$f.o /root/DOMI/tmp/. 
 echo "Incident dans le traitement en pj  , merci d'adresser eventuellement vos instructions a $cuser" | mutt -s "VTOM ERREUR $f" -a /root/DOMI/tmp/$f.o $user -c $cuser 
fi 
done 
