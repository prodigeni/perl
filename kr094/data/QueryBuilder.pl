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
		aliases => [],
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
	$t->{'aliases'} = ();
	my $fields = \@{$t->{'fields'}};
	my $aliases = \@{$t->{'aliases'}};
	my $field;
	my $alias;
	if(ref $_[0] eq "HASH") {
		my $hash = shift;
		for $field (keys $hash) {
			$alias = $hash->{$field};
			unshift($fields, $field);
			unshift($aliases, $alias);
		}
	} else {
		while(@_){
			$_ = $t->trim(pop);
			if($_ =~ /as/) {
				my @split = split(/\s+as\s+/, $_, 2);
				$field = shift @split;
				$alias = shift @split;
				unshift($fields, $field);
				unshift($aliases, $alias);			
			} else {
				$field = $t->trim($_);
				$alias = '';
				unshift($fields, $field);
				unshift($aliases, $alias);
			}			
		}
	}
	$t->print();
	return $t;
}

sub trim {
	my $t = shift;
	my $trim = shift;
	$trim =~ s/^\s+//;
	$trim =~ s/\s+$//;
	return $trim;
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
	my @aliases = @{$t->{'aliases'}};
	my $index = 0;
	my $field;
	my $alias;
	for $field (@fields) {
		$alias = $aliases[$index];
		print "$field => $alias\n";
		$index++;
	}
	return $t;
}

sub _generate {
	my $t = shift;
	
}

my $qb = new QueryBuilder();
$qb->select("data")
	->select("2 as two")
	->select("SQLITE_VERSION() as version")
	->get('table', 1);