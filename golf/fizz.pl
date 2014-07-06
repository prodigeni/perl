use strict;
use warnings;

print"$_->[0] ".($_->[1]?'':'fizz').($_->[2]?'':'buzz')."\n"for map{[$_=>$_%3=>$_%5]}1..100