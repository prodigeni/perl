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
		my $_v = &$_get($_m);
		if($_v) {
			$_self->{$_m} = @_[1 .. $#_];
		}
	};
	
	my $_public = sub {
		my $_m = shift;
		my $_v = '';
		if(@_) {
			&$_set(@_);
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

sub connect {
	my $t = t(\@_);
	print $t->('not', 'sqlite');
}

sub err {
	die("$_[0]");
}

new data->connect();