# clause = map{ $field => $alias }
# data => 'some data' OR data => 'new data'
# SQLITE_VERSION => 'version' OR user_name => 'billy123'
package QueryBuilder;
use strict;
use warnings;

use lib './';
use Data;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		data => undef,
		query => '',
		query_type => '',
		table => '',
		fields => [],
		aliases => [],
		field_hash => {},
		where => [],
		clauses => [],
		where_hash => {},
		limit => 0
	};
	
	$_self->{data} = new Data();
	
	bless $_self, $_class;
	
	return $_self;
}

sub select {
	my $t = shift;
	my $clause = shift;
	$t->_build_arrays($t->{fields}, $t->{aliases}, $clause);
	$t->_build_hash($t->{field_hash}, $clause);
	return $t;
}

sub _build_hash {
	my $t = shift;
	my $clause = shift;
	my $field;
	my $alias;
	
	if(ref $_[0] eq "HASH") {
		my $hash = shift;
		for $field (keys $hash) {
			$alias = $hash->{$field};
			$clause->{$field} = $alias;
		}
	} else {
		my $as_alias_regex = qr/\s+as\s+/;
		while(@_){
			$_ = $t->trim(pop);
			if($_ =~ $as_alias_regex) {
				my @split = split($as_alias_regex, $_, 2);
				$field = shift @split;
				$alias = shift @split;
			} else {
				$field = $t->trim($_);
				$alias = '';
			}

			$clause->{$field} = $alias;			
		}
	}
}

sub _build_arrays {
	my $t = shift;
	my $fields = shift;
	my $aliases = shift;
	my $field;
	my $alias;
	
	if(ref $_[0] eq "HASH") {
		my $hash = shift;
		for $field (keys $hash) {
			unshift($fields, $field);
			unshift($aliases, $alias);
		}
	} else {
		my $as_alias_regex = qr/\s+as\s+/;
		while(@_){
			$_ = $t->trim(pop);
			if($_ =~ $as_alias_regex) {
				my @split = split($as_alias_regex, $_, 2);
				$field = shift @split;
				$alias = shift @split;			
			} else {
				$field = $t->trim($_);
				$alias = '';	
			}	
			unshift($fields, $field);
			unshift($aliases, $alias);
		}
	}
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
	$t->_generate();
}

sub get_col {
	my $t = shift;
	my $col = shift;
	my $value = '';
	if(defined $col) {
		$value = $t->{data}->_get_col($col);
	}
	return $value;
}

sub print {
	my $t = shift;
	my $f = $t->{fields};
	my $a = $t->{aliases};
	my $fh = $t->{field_hash};
	my $field;
	my $value;
	
	if(defined $fh) {
		for $field (keys $fh) {
			$value = $fh->{$field};
			print "$field => $value\n";
		}
	}
}

sub _generate {
	my $t = shift;
	
}

my $qb = new QueryBuilder();
$qb->select({1 => 'one'})
	->select("two as two");
$qb->print();
$qb->{data}->query("SELECT SQLITE_VERSION() as version");
print $qb->get_col('version');