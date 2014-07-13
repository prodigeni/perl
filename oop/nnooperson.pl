package OOPerson;
use strict;
use warnings;

use Num;

sub new {
	my $_type = shift;
	my $_class = ref $_type || $_type;
	my $_self = {
		NAME => undef,
		AGE => undef
	};
	
	my $_setter = sub {
		my $member = shift;
	}
	
	my $_public = sub {
	}
	
	bless $_closure, $_class;
	return $_closure;
}

# sub private {
# define in self
# ,
		# PRIVATE => sub {
			# my $s = $_[0];
			# &$s('NAME', 'david');
		# }
	#call
	# &{&$s('PRIVATE')}(@_);
# }

sub setName {
	my $s = $_[0];
	my $_name = $_[1];
	if(!Num::isNumber($_name)) {
		&$s('NAME', $_name);
	} else {
		&$s('NAME', '');
	}
}

sub getName {
	my $s = $_[0];
	return &$s('NAME');
}

sub setAge {
	my $s = $_[0];
	my $_age = $_[1];
	if(Num::isNumber($_age)) {
		&$s('AGE', $_age);
	} else {
		&$s('AGE', 0);
	}
}

sub getAge {
	my $s = $_[0];
	return &$s('AGE');
}

my $person = new OOPerson();

$person->setName('Alek');
print $person->getName() . "\n";

$person->setAge(40);
print $person->getAge() . "\n";