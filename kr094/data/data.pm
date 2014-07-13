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
		error => '',
		last_error => '',
		query => '',
		last_query => '',
		result => undef,
		result_hash => undef,
		result_columns => undef,
		last_result => undef
	};
	
	# Return a variable if the member is defined, the key exists, and it has been set
	my $_get = sub {
		my $_m = shift;
		my $_v = '';
		if(defined $_m 
		&& exists $_self->{$_m} 
		&& defined $_self->{$_m}) {
			$_v = $_self->{$_m};
		}
		return $_v;
	};
	
	# Set a variable if there is a key for it
	my $_set = sub {
		my $_m = shift;
		if(exists $_self->{$_m}) {
			$_self->{$_m} = shift;
		}
	};
	
	# Public closure with access to this scope
	my $_public = sub {
		my $_m = shift;
		my $_v = '';
		if(@_) {
			$_set->($_m, @_);
			$_v = $_get->($_m);
		}
		else {
			$_v = $_get->($_m);
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
		$t->_exec();
		$t->('result_hash', $t->build_hash());
		
		return $t->('result_hash');
	}
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
			_err('no package init');
		}
	}
	else {
		_err('no init');
	}
}

sub _exec {
	my $t = t(\@_);
	my $db = $t->_con();
	
	my $sth = $db->prepare($t->('query'));
	if(!$sth) {
		$t->_err($db->errstr);
	}
	
	$sth->execute();
	$t->('last_result', $t->('result'));
	$t->('result', $sth->fetch());
	$t->('result_columns', $sth->{NAME});
	
	$sth->finish();
	$db = $t->_discon();
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
	my $db = $t->('dbh');
	$db->disconnect();
	return $t->('dbh', undef);
}

sub _err {
	if(ref $_[0] eq __PACKAGE__)
	{
		my $t = t(\@_);
		$t->('last_error', $t->('error'));
		$t->('error', $_[1]);
	}
	
	my $e = shift;
	die("$e");
}

1;
