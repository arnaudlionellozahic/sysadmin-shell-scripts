#find .  -type d -print 

for i in `find .  -type d -print`
do
echo "repertoire "$i "=Taille="`du -k $i | awk -F" " '{print $1"="$2}'` " = Nbre fichiers=" `ls $i | wc -l`
done