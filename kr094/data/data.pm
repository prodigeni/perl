package data;
use strict;
use warnings;
use DBI;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		dbi => 'SQLite',
		dbname => 'kr094.db',
		dbh => undef,
		query => '',
		last_query => '',
		result => undef,
		result_hash => undef,
		result_columns => undef,
		last_result => undef
	};
	
	my $_get = sub {
		my $_m = shift;
		my $value = '';
		if(defined $_m 
		&& exists $_self->{$_m} 
		&& defined $_self->{$_m}) {
			$value = $_self->{$_m};
		}
		return $value;
	};
	
	my $_set = sub {
		my $_m = shift;
		if(exists $_self->{$_m}) {
			$_self->{$_m} = shift;
		}
	};
	
	my $_public = sub {
		my $_m = shift;
		my $_v = '';
		if(@_) {
			&$_set($_m, @_);
			$_v = &$_get($_m);
		}
		else {
			$_v = &$_get($_m);
		}
		
		return $_v;
	};
	
	bless $_public, $_class;
	
	return $_public;
}

sub query {
	my $t = t(\@_);
	my $query = shift;
	if(defined $query) {
		$t->('last_query', $t->('query'));
		$t->('query', $query);
		
		my $db = $t->_con();
		my $sth = $db->prepare($t->('query'));
		if(!$sth) {
			err($db->errstr);
		}
		$sth->execute();
		
		my $result = $sth->fetch();
		if(!$result) {
			err($db->errstr);
		}
		
		$t->('last_result', $t->('result'));
		$t->('result', $result);
		$t->('result_columns', $sth->{NAME});
		$t->('result_hash', build_hash($t));
		
		$sth->finish();
		$db = $t->_discon();
		return $t->('result');
	}
}

sub result {	
	my $t = t(\@_);
	return $t->('result_hash');
}

sub build_hash {
	my $t = t(\@_);
	my @r = @{$t->('result')};
	my %hash;
	my $index = 0;
	for my $col (@{$t->('result_columns')}) {
		$hash{$col} = $r[$index];
		$index++;
	}
	return \%hash;
}

sub t {
	if(defined $_[0]) {
		my $t = shift;
		$t = shift @{$t};
		if(ref $t eq __PACKAGE__) {
			return $t;
		}
		else {
			err('no package init');
		}
	}
	else {
		err('no init');
	}
}

sub _con {
	my $t = t(\@_);
	return $t->('dbh', DBI->connect(
		'dbi:' .$t->('dbi')
		.':dbname=' .$t->('dbname'),
		'',
		'',
		{ RaiseError => 1}
	));
}

sub _discon {
	my $t = t(\@_);
	return $t->('dbh', undef);
}

sub err {
	die("$_[0]");
}

1;
