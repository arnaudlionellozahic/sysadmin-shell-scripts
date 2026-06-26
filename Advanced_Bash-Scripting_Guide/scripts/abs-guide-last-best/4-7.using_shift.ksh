#!/bin/bash
# shft.sh: Using 'shift' to step through all the positional parameters.

#Example 4-7. Using shift

#  Name this script something like shft.sh,
#+ and invoke it with some parameters.
#+ For example:
#             sh shft.sh a b c def 83 barndoor

until [ -z "$1" ]  # Until all parameters used up . . .
do
  echo -n "$1 "
  shift
done

echo               # Extra linefeed.

# But, what happens to the "used-up" parameters?
echo "$2"
#  Nothing echoes!
#  When $2 shifts into $1 (and there is no $3 to shift into $2)
#+ then $2 remains empty.
#  So, it is not a parameter *copy*, but a *move*.

# shift 3    # Shift 3 positions.
#  n=3; shift $n
#  Has the same effect.

# ======================== #
#
#!/bin/bash
# shift-past.sh

#shift 3    # Shift 3 positions.
#  n=3; shift $n
#  Has the same effect.

#echo "$1"

#exit 0

# ======================== #


#$ sh shift-past.sh 1 2 3 4 5
#4

exit

#  See also the echo-params.sh script for a "shiftless"
#+ alternative method of stepping through the positional params.
