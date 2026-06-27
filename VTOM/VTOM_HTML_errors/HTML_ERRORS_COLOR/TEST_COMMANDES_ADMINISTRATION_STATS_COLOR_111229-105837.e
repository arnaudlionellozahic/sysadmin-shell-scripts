+ OUTPUT_FILE=/home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ date +%Y-%m-%d
+ DATE_D=2011-12-29
+ DATE_F=2011-12-29
+ CLAUSE='vtexpdatevalue = CURRENT_DATE'
+ echo $' <html>\n     <head>\n  <title></title>\n  <style type="text/css">\n  body {\n    color: black;\n    background-color: #000000}\n  </style>\n</head> \n<table border="1">\n  <tr bgcolor="#00BFFF"> '
+ 1> /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ /home4/alozahic/Linux/savigny/Ver542/sgbd/bin/psql -A -H -c $'SELECT vtenvname, vtapplname, vtjobname, vtbegin, vtend, vtend - vtbegin, vtexpdatevalue, vtnbretry, \'EN-ERREUR\', vtretcode, vterrmess FROM vt_stats_job WHERE vtexpdatevalue = CURRENT_DATE AND vtjobname IS NOT NULL AND vtstatus = 4 ORDER BY vtend ASC' -d vtom -h localhost -p 33909 -U vtom
+ 1>> /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ cat /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ sed 12d
+ sed '/<tr valign="top"/d'
+ grep -v '<tr>'
+ 1> /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ /bin/grep TEST_COMMANDES /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ wc -l
+ [ 1 -ne 0 ]
+ sed -i '/TEST_COMMANDES/i <tr valign=top bgcolor=deeppink>' /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ grep EN-ERREUR /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
+ wc -l
+ NB_TEST=1
+ date '+%d/%m/%Y a %H:%M'
+ tmail -se arnaud.lozahic@absyss.com -to arnaud.lozahic@absyss.com -smtp jupiter -sub '[VTOM RECETTE] Erreurs (1)' -msg 'Statistiques du 2011-12-29 au 2011-12-29 extraites le 29/12/2011 a 10:58' -att /home4/alozahic/exploit/systeme/suivi/Erreurs_VTOM_RECETTE.html
