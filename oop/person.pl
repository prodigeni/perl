#!F:\perl\perl\bin\perl.exe
use strict;
use warnings;

package Person;

sub new
{
	printArgs(@_);
	
	#Perl commands implicitly act on @_, the parameter array
	my $__type = shift;
	
	#Creating a Hash Variable
	my %__members = (
		firstName => shift,
		lastName => shift,
		ssn => shift
	);
	
	#Create a Scalar that references the hash
	my $__self = \%__members;
	
	#String-Scalar-Reference Context
	#Print properties
	print "From Person Constructor:\nFirst Name is $__self->{firstName}\nLast Name is $__self->{lastName}\nSSN is $__self->{ssn}\n";
    bless $__self, $__type;
    return $__self;
}

sub printArgs
{
	printLine("Arguments passed to $_[0] Constructor: " . join(', ', @_));
}

sub printLine
{
	##Subroutine Context
	#The magic variable @_ is an array
	#holding all arguments passed 
	#into a subroutine (Or program)
	
	#@_ is being accessed in scalar context as $_
	print "$_[0]\n";
}

my $object = new Person('Kyle', 'Ross', 123);
