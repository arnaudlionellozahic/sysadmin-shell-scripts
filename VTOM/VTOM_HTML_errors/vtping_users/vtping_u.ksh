set -x

list=`cat /exploit/systeme/suivi/vtping_users/liste_users`

USERS=/exploit/systeme/suivi/vtping_users/user_vtom.log

for u in $list
do
vtping | grep $u >> $USERS 
done

/bin/mailx -s "[VTOM RECETTE] Utilisateurs restes connectes a 21h00" arnaud.lozahic@mondial-assistance.fr < $USERS
