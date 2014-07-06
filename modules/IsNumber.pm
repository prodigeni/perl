package IsNumber;

sub isInt {
   return $_[0] =~ /^[+-]?\d+$/;
}

sub isFloat {
   return $_[0] =~ /^[+-]?\d+(\.\d+)?$/;
}

sub isNumber {
	if(defined $_[0]) {
		my $n = shift;
		return (isInt($n) || isFloat($n));
	} else {
		return false;
	}
}

1;