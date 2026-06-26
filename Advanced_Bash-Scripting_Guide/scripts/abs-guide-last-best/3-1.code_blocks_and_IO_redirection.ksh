#!/bin/bash

#Example 3-1. Code blocks and I/O redirection

# Reading lines in /etc/fstab.

File=/etc/fstab

{
read line1
read line2
read line3
read line4
read line5
read line6
read line7
read line8
read line9
read line10
read line11
read line12
read line13
read line14
read toto
} < $File

echo "First line in $File is:"
echo "$line1"
echo
echo "line 15 in $File is:"
echo "$toto"

exit 0

# Now, how do you parse the separate fields of each line?
# Hint: use awk, or . . .
# . . . Hans-Joerg Diers suggests using the "set" Bash builtin.

