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
		query => ''
	};
	
	my $_get = sub {
		my $value = '';
		if(defined $_[0] && defined $_self->{$_[0]}) {
			$value = $_self->{$_[0]};
		}
		return $value;
	};
	
	my $_set = sub {
		my $_m = shift;
		if(defined $_self->{$_m})
		{
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
	my $dbh = DBI->connect(
		'dbi:' .$t->('dbi')
		.':dbname=' .$t->('dbname'),
		'',
		'',
		{ RaiseError => 1}
	);
	$t->('dbh', $dbh);
	return $t->('dbh');
}

sub query {
	my $t = t(\@_);
	my $query = shift;
	if(defined $query) {
		$t->('query', $query);
		my $dbh = $t->_con();
	}
}

sub err {
	die("$_[0]");
}

my $d = new data();

$d->query();

