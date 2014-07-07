package OOPerson;
use strict;
use warnings;

use Num;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	my $_self = {
		NAME => undef,
	};
	my $self = sub {
		return $_self;
	};
	
	bless $self, $_class;
	return $self;
}

sub this {
	return \&{$_[0]};
}

sub setName {
	my $s = this(@_);
	my $_self = &$s();
	$_self->{'NAME'} = $_[1];
}

sub getName {
	my $s = this(@_);
	my $_self = &$s();
	return $_self->{'NAME'};
}

my $person = new OOPerson();

$person->setName('kyle');
print $person->getName();