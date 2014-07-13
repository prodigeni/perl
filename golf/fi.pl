use strict;
use warnings;

print "$_ ".($_%3?'':'fizz').($_%5?'':'buzz')."\n" for 1..100