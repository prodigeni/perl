package query_builder;
use strict;
use warnings;

use lib './';
use Data;

sub new {	
	my $_type = shift;
	my $_class = ref $_type || $_type;
	
	my $_self = {
		fields => {},
		where => {},
		query_type => '',
		query => {},
	};
	
	bless $_self, $_class;
	
	return $_self;
}

sub select {

}

sub where {

}

sub get {
	# Note: data()->query() Intentionally dies for not using a class ref
	my $db = new Data();
	my $r = $db->query("SELECT SQLITE_VERSION() as version, 1 as 'one', 'A' as 'letter'");
	print $r->{'version'};
}

get();