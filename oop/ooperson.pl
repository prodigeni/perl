package OOPerson;
use strict;
use warnings;

use IsNumber;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	my $_self = {
		NAME => undef,
		AGE => undef,
		_private => 42
	};
	my $_closure = sub {
		my $member = shift;
		@_ and $_self->{$member} = shift;
		return $_self->{$member};
	};
	
	bless $_closure, $_class;
	return $_closure;
}

sub _me {
	if(defined $_[0]) {
		return $_[0];
	}
}

sub setName {
	my $s = _me@_;
	my $_name = $_[1];
	if(!IsNumber::isNumber($_name)) {
		&$s('NAME', $_name);
	} else {
		&$s('NAME', '');
	}
}

sub getName {
	my $s = _me@_;
	return &$s('NAME');
}

sub setAge {
	my $s = _me@_;
	my $_age = $_[1];
	if(IsNumber::isNumber($_age)) {
		&$s('AGE', $_age);
	} else {
		&$s('AGE', 0);
	}
}

sub getAge {
	my $s = _me@_;
	return &$s('AGE');
}

my $person = new OOPerson();

$person->setName('Alek');
print $person->getName() . "\n";

$person->setAge(40);
print $person->getAge() . "\n";