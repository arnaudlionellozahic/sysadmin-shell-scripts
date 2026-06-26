#!/bin/sh
 
background()
{
sleep 10
echo "Background"
sleep 10
# Function will return here - if backgrounded, the subprocess will exit.
}
 
echo "ps before background function"
ps
background &
echo "My PID=$$"
echo "Background function PID=$!"
echo "ps after background function"
ps
exit 0
