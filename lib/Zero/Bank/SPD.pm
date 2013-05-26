package Zero::Bank::SPD;
use strict;
use warnings;
use base qw/Zero::Bank/;
use JSON::XS;
use Data::Dump;
use Zeta::Run;

sub _init  { warn "Zero::Bank::SPD _init called";  return shift; }
sub _setup { warn "Zero::Bank::SPD _setup called"; return shift; }
sub pack   { shift; return encode_json(+shift); }
sub unpack { shift; return decode_json(+shift); }

1;

__DATA__
SPD相关的配置文件可以放在这里

