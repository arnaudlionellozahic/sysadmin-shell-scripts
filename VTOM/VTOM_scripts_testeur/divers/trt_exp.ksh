cat $1 | gawk '{
        if ( $0 ~ "date:" && $0 !~ "/" ) { date=$0 ; flag_dat=1}
                if (flag_dat==1){
                        if ( $0 ~ "valeur=" ) { value=$0 ; flag_val=1}
                               if ( $0 ~ "environnement=" ) { env=$0 ; flag_env=1}
                               }
                        if ($0 ~ "^$" && flag_dat == 1 && flag_val == 1 ){
                                                               print date""value"\""
                                print "treset "env " ***"date
                                                               flag_dat=0;flag_val=0;value="";date=""
                        }
        } ' >> ress_date.tmp0
cat ress_date.tmp0 | sed 's/\*\*\*\[date://' | sed 's/\[date:/tadddate \/Nom=/' | sed 's/environnement=//' | sed 's/\]valeur=/ \/valeur="/' | sed 's/\]"//' | sed 's/\]//' > Val_vie_date.sh

