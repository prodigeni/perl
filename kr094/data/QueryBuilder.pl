package QueryBuilder;
use strict;
use warnings;

use lib './';
use Data;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		query => '',
		query_type => '',
		fields => [],
		values => [],
		table => '',
		where => {},
		limit => 0
	};
	
	bless $_self, $_class;
	
	return $_self;
}

sub select {
	my $t = shift;
	$t->{'fields'} = ();
	$t->{'values'} = ();
	my $fields = \@{$t->{'fields'}};
	my $values = \@{$t->{'values'}};
	my $field;
	my $value;
	if(ref $_[0] eq "HASH") {
		my $hash = shift;
		my $value = '';
		for $field (keys $hash) {
			$value = $hash->{$field};
			unshift($fields, $field);
			unshift($values, $value);
		}
	} else {
		while(@_){
			$_ = pop;
			if($_ =~ /as/) {
				my @values = split(/\s+as\s+/, $_, 2);
				$field = shift @values;
				$value = shift @values;
				unshift($fields, $field);
				unshift($values, $value);			
			} else {
				$field = undef;
				$value = $_;
				unshift($fields, $field);
				unshift($values, $value);
			}			
		}
	}
	$t->print();
	return $t;
}

sub where {

}

sub get {
	my $t = shift;
	$t->{'table'} = shift;
	$t->{'limit'} = shift;
	my $db = new Data();
	$t->_generate();
	#$db->query($t->{'query'});
}

sub print {
	my $t = shift;
	my @fields = @{$t->{'fields'}};
	my @values = @{$t->{'values'}};
	my $index = 0;
	my $field;
	my $value;
	for $field (@fields) {
		$value = $values[$index];
		print "$field => $value\n";
		$index++;
	}
	return $t;
}

sub _generate {
	my $t = shift;
	
}

my $qb = new QueryBuilder();
$qb->select({1 => 'one'})
	->select("2 as two")
	->select("SQLITE_VERSION() as version")
	->get('table', 1);