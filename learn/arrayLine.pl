use strict;
use warnings;

printArrayLine 'as', 'many', {hash => ['cats', 'bears', 'and', 'ducks']}, 'as', 'you', 'want' ;

sub printArrayLine
{
	foreach my $arg (@_)
	{
		if(ref($arg) eq "HASH")
		{
			print "@{$arg->{hash}}\n";
		}
		else
		{
			print $arg . "\n";
		}
	}
}