use strict;
use warnings;

#Declare a scalar and array variable
my $scalar = 'scalar';
my @array = ('array', 'of', 'variables');

#String Context!

###Output & Concatenation

##Variable Context
#scalar context
print($scalar . "\n");

#array context of array, returns the size
print(@array . "\n");

print shift @array;
unshift @array 'unshifted';

#scalar context of array variable
print($array[0] . "\n");

##String Context (Double Quotes)
#scalar context
print "$scalar\n";

#array context
print "@array\n";

#scalar context of array variable
print "$array[0]\n";


printLine('I don\'t know anything about $scalar');
printLine("I do, it's $scalar");


sub printLine
{
	##Subroutine Context
	#The magic variable @_ is an array
	#holding all arguments passed 
	#into a subroutine (Or program)
	
	#@_ is being accessed in scalar context as $_
	print "$_[0]\n";
}