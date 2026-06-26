#!/bin/bash
# broken-link.sh
# Written by Lee bigelow <ligelowbee@yahoo.com>
# Used in ABS Guide with permission.

#Example 7-4. Testing for broken links

#  A pure shell script to find dead symlinks and output them quoted
#+ so they can be fed to xargs and dealt with :)
#+ eg. sh broken-link.sh /somedir /someotherdir|xargs rm
#
#  This, however, is a better method:
#
#  find "somedir" -type l -print0|\
#  xargs -r0 file|\
#  grep "broken symbolic"|
#  sed -e 's/^\|: *broken symbolic.*$/"/g'
#
#+ but that wouldn't be pure Bash, now would it.
#  Caution: beware the /proc file system and any circular links!
################################################################

# find . -type l -print0 | xargs -r0 file | grep "broken symbolic" | sed -e 's/^\|: *broken symbolic.*$/"/g'
# find . -type l -print0 | xargs -r0 file | grep "broken symbolic" | awk -F ":" {'print $1'}
# ./titi

# decomposition
# find . -type l -print0 | xargs -r0 file
# ./titi: broken symbolic link to toto

#  If no args are passed to the script set directories-to-search 
#+ to current directory.  Otherwise set the directories-to-search 
#+ to the args passed.
######################

[ $# -eq 0 ] && directorys=`pwd` || directorys=$@


#  Setup the function linkchk to check the directory it is passed 
#+ for files that are links and don't exist, then print them quoted.
#  If one of the elements in the directory is a subdirectory then 
#+ send that subdirectory to the linkcheck function.
##########

linkchk () {
    for element in $1/*; do
      [ -h "$element" -a ! -e "$element" ] && echo \"$element\"
      [ -d "$element" ] && linkchk $element
    # Of course, '-h' tests for symbolic link, '-d' for directory.
    done
}

#  Send each arg that was passed to the script to the linkchk() function
#+ if it is a valid directoy.  If not, then print the error message
#+ and usage info.
##################
for directory in $directorys; do
    if [ -d $directory ]
	then linkchk $directory
	else 
	    echo "$directory is not a directory"
	    echo "Usage: $0 dir1 dir2 ..."
    fi
done

exit $?


#[root@testliocentos10 SHELL]# sh 7-4.testing_for_broken_links.ksh
#"/home/crashandro/SHELL/titi"
#[root@testliocentos10 SHELL]# sh 7-4.testing_for_broken_links.ksh .
#"./titi"
#
#[root@testliocentos10 SHELL]# [ $# -eq 0 ] && directorys=`pwd` || directorys=$@
#[root@testliocentos10 SHELL]# echo $directorys
#/home/crashandro/SHELL



#[root@testliocentos10 SHELL]# for element in $toto/*; do
#     [ -h "$element" -a ! -e "$element" ] && echo \"$element\"
#     [ -d "$element" ] && linkchk $element
#  done
#"/home/crashandro/SHELL/titi"
