package Zero::Bank::CMB;
use strict;
use warnings;
use base qw/Zero::Bank/;

sub _init  { my $self = shift; warn(__PACKAGE__ . " _init called" ); return $self; }
sub _setup { my $self = shift; warn(__PACKAGE__ . " _setup called"); return $self; }
sub pack   { shift; return shift; }
sub unpack { shift; return shift; }

1;

__DATA__

