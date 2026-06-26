cat $1 | gawk '{
        if ( $0 ~ "res:" && $0 !~ "/" ) { res=$0 ; flag_res=1}
                if (flag_res==1){
                        if ( $0 ~ "type=poids" ) {flag_poid=1}
                                               if ( $0 ~ "valeur=" ) { value=$0 ; flag_val=1}
                }
                        if ($0 ~ "^$" && flag_res == 1 && flag_val == 1 ){
                                if (flag_poid == 1){print res"valeur\=0\""}
                                                               else {print res""value"\""}
                                flag_res=0;flag_val=0;value="";res="";flag_poid=0
                        }
        } ' > ress_vie.tmp0
cat ress_vie.tmp0 | sed 's/\[res:/taddres \/Nom=/' | sed 's/\]valeur=/ \/valeur="/' | sed 's/\]"//' > Val_vie_ress.sh

