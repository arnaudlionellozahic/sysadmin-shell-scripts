#!/bin/ksh

tlist env/date|nawk '{print "Reset de "$1" "$2;system( "treset "$1" "$2 )}'


