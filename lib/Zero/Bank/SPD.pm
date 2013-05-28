package Zero::Bank::SPD;
use strict;
use warnings;
use base qw/Zero::Bank/;
use JSON::XS;
use Data::Dump;
use Zeta::Run;

sub _init  { my $self = shift; $self->{logger}->debug(__PACKAGE__ . " _init called" ); return $self; }
sub _setup { my $self = shift; $self->{logger}->debug(__PACKAGE__ . " _setup called"); return $self; }
sub pack   { shift; return encode_json(+shift); }
sub unpack { shift; return decode_json(+shift); }

1;

__DATA__
SPD相关的配置文件可以放在这里

