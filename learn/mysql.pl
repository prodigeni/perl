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