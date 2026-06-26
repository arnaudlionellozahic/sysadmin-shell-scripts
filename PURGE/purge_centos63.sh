#!/bin/ksh -x

liste=`find /var/spool/clientmqueue -mtime -1 -size +1000000 -exec ls -1 {} \;`
#equivalent
#liste=`find /var/spool/clientmqueue -mtime -1 -size +1000000 -exec ls -A {} \;`
#equivalent
#liste=`find /var/spool/clientmqueue -mtime -1 -size +1000000000c -exec ls -1 {} \;`

for env in $liste
do 
> $env
# ou sed '/*$/d' $env
done

