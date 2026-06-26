#! /usr/bin/nawk -f

BEGIN { fs="DIR.DIR" ; system("ls -al > " fs) ; close(fs) ; nbf = 0
        for (iar=1;iar<=ARGC;iar++) { ARGV[iar]= "" }; ARGV[1] = fs }

#/-/ &&  $1 !~ /^d/ && $9 != "DIR.DIR" {
/^-/ && $9 != "DIR.DIR" {
  ip = index($9,".")
  if (ip > 0) { ext = substr($9,1+ip) } else { ext = "???" }
  tot[ext] += $5 ; nb[ext] ++ ; nbf++}


END  { 
        if (nbf==0) {  print " mais je n'ai vu aucun fichier !! "}
else {
print " ext        nb_fich        cumul_taille"
         for (ext in tot)
           printf ("%-15s  %3d %12d\n" , ext , nb[ext] , tot[ext] )
}
#         system("rm " fs)
         }

