package Zero::Bank::CCB;
use strict;
use warnings;
use base qw/Zero::Bank/;

sub _init  { warn "Zero::Bank::CCB _init called"; return shift; }
sub _setup { warn "Zero::Bank::CCB _setup called"; return shift;}
sub pack   { shift; return shift; }
sub unpack { shift; return shift; }

1;

__DATA__

