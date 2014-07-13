package Data;
use strict;
use warnings;
use DBI;
use This;

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
		} else {
			$_v = $_get->($_m);
		}
		
		return $_v;
	};
	
	bless $_public, $_class;	
	return $_public;
}

# Public query method
sub query {
	my $t = t(\@_);
	my $query = shift;
	my $r = '';
	if(defined $query) {
		$t->('last_query', $t->('query'));
		$t->('query', $query);
		$t->_exec();
		$r = $t->('result_hash', $t->_build_hash());
	}
	
	return $r;
}

# Build a hash reference with columns and values
# This is what is returned to the querier
sub _build_hash {
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
	my $e = shift;
	if(_is_this($e)) {
		my $t = t($e);
		$e = shift;
		$t->('last_error', $t->('error'));
		$t->('error', $e);
	}
	die("$e");
}

sub t {
	return This::t(@_, __PACKAGE__);
}

1;
