#!/usr/bin/perl
$regexp = shift;
while (<>) {
   print if /$regexp/;
}
