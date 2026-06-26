#!/bin/awk -f 
BEGIN {

	for (i=1; i <= 10; i++) {
		printf "The square of ", i, " is ", i*i;
	}

# now end
exit;
}
