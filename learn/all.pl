/*context.pl*/

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

/*arrayLine.pl*/

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

/*person.pl*/

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
	
	#Create a Scalar that \references the hash
	my $self = \%__members;
	
	#String-Scalar-Reference Context
	#Print properties
	print "From Person Constructor:\nFirst Name is $self->{firstName}\nLast Name is $self->{lastName}\nSSN is $self->{ssn}\n";
    bless $self, $__type;
    return $self;
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

/*mysql.pl*/

use DBI;

$db ="concreteapp";
## mysql database user name
$user = "root";
 
## mysql database password
$pass = "";
 
## user hostname : This should be "localhost" but it can be diffrent too
$host="localhost";
 
## SQL query
$query = "show tables;";
 
$dbh = DBI->connect("DBI:mysql:$db:$host", $user, $pass)
or die 'No Database Connection!';
$sqlQuery  = $dbh->prepare($query)
or die "Can't prepare $query: $dbh->errstr\n";
 
$rv = $sqlQuery->execute
or die "can't execute the query: $sqlQuery->errstr";

my $tables = '';
 
print "********** My Perl DBI Test ***************";
print "Here is a list of tables in the MySQL database $db.";
while (@row = $sqlQuery->fetchrow_array()) 
{
	$tables = $row[0];
	print "$tables\n<br>";
}
 
$rc = $sqlQuery->finish;
