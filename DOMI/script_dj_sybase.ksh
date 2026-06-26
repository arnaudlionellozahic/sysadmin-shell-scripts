#Dominique JULIEN
#
#isql -U Login -P MotDePasse -S ServeurASE -d NomDeLaBase -i VotreScript.sql -o JournalDErreur.log

connect_base ()
{
isql -UBATCHGE -PBATCHGE -SBCAPRO <<EOF | egrep -i "Msg |severity|error"
set rowcount 5
SELECT name ,loginname, pwdate FROM master..syslogins
go
exit
EOF
cr=$?
[ cr -eq 0 ] && cr=1
[ cr -eq 1 ] && cr=0

echo suite

isql -UBATCHGE -PBATCHGE -SBCAPRO <<EOF | grep "Last login date"
sp_displaylogin BATCHGE
go
exit
EOF

isql -UBATCHGE -PBATCHGE -SBCAPRO <<END
set rowcount 10
SELECT name,status FROM master..syslogins where name like 'BATCHGE'
go
exit
END

echo fin
return $cr
}

reseau()
{
echo "Connexion Base socket 4101"
netstat -n |grep 4101| grep ESTABLISHED |wc -l
netstat -n | grep "4101" | egrep -v "ESTABLISHED|TIME_WAIT"
}

# MAIN
#set -x
#
reseau
#
nb_essai=1
cr=1
while [ nb_essai -le 5 -a cr -eq 1 ]
do
connect_base
[ $? -eq 0 ] &&  exit 0
nb_essai=`expr $nb_essai + 1`
sleep 2
done
#
exit $cr