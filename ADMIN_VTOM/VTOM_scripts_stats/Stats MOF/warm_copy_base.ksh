#! /bin/ksh

echo "Copie de la base VTOM"
echo "====================="
NAME=$TOM_BACKUP/$(date +"%y%m%d-%H%M%S").w
cp -R $TOM_BASES $TOM_BACKUP
[[ $? -eq 0 ]] || { echo "Copie de la base impossible."; exit 2; }
mv $TOM_BACKUP/bases $NAME
[[ $? -eq 0 ]] || { echo "Renommage de la copie impossible. La copie est dans $TOM_BACKUP/bases. Vous pouvez essayer de la renommer manuellement."; exit 2; }
echo "La copie de la base VTOM se trouve dans $NAME."
