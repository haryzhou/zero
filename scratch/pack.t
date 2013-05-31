#! /usr/bin/perl
use Zeta::Pack::8583;
use JSON::XS;
use Time::HiRes qw/gettimeofday tv_interval/;

use Data::Dump;
use Carp;

my $fh = IO::File->new("<$ENV{ZERO_HOME}/lib/Zero/Chnl.pm");
confess "can not open file Chnl.pm" unless $fh;

while(<$fh>) {
    last if /__DATA__/;
}
my $pack = Zeta::Pack::8583->new(conf => $fh);
my @swt;
$swt[0]  = '0200';
$swt[2]  = '6225885741255749';
$swt[3]  = '000000';
$swt[4]  = '000000000100';
$swt[11] = '800124';
$swt[12] = '200100';
$swt[13] = '0530';
$swt[18] = '00000008'; # bcode
$swt[35] = '6225885741255749=00001012964900171056';
$swt[36] = '6225885741255749d15615600000000000000030000000100000491200dd000000009645900000000000000000000000000000';
$swt[41] = '00000000';
$swt[42] = '825550000009999'; # 825550000009999
$swt[60] = '22000001';
$swt[64] = 'MMMMMMMM';
my $begin = [ gettimeofday ];
for ((1..100000)) {
    my $data = $pack->pack([@swt]);
    #Data::Dump->dump('pack'.$data);
    $data = $pack->unpack($data);
    #Data::Dump->dump("unpack [@$data]");
}
my $end = [ gettimeofday ];
my $interval = tv_interval($begin, $end);

warn "Zeta::Pack::8583[pack][unpack][10000][$interval]";

#my %swt;
#$swt{0}  = '0200';
#$swt{2}  = '6225885741255749';
#$swt{3}  = '000000';
#$swt{4}  = '000000000100';
#$swt{11} = '800124';
#$swt{12} = '200100';
#$swt{13} = '0530';
#$swt{18} = '00000008'; # bcode
#$swt{35} = '6225885741255749=00001012964900171056';
#$swt{36} = '6225885741255749d15615600000000000000030000000100000491200dd000000009645900000000000000000000000000000';
#$swt{41} = '00000000';
#$swt{42} = '825550000009999'; # 825550000009999
#$swt{60} = '22000001';
#$swt{64} = 'MMMMMMMM';
$begin = [ gettimeofday ];
for ((1..100000)) {
    my $data = encode_json({@swt});
    #Data::Dump->dump('encode_json'.$data);
    $data = decode_json($data);
    #warn 'decode_json'.Data::Dump->dump($data);
}
$end = [ gettimeofday ];
$interval = tv_interval($begin, $end);

warn "JSON::XS[encode_json][decode_json][10000][$interval]";
