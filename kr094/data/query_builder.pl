package query_builder;
use strict;
use warnings;

use lib './';
use data;

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
	my $db = new data();
	my $r = $db->query("SELECT SQLITE_VERSION() as version, 1 as 'one', 'A' as 'letter'");
	print $r->{'letter'};
}

get();