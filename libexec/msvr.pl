#!/usr/bin/perl
use strict;
use warnings;
use Zeta::Run;
use DBI;
use Carp;
use POE;
use Zeta::POE::TCPD;

use constant{
    DEBUG => $ENV{ZERO_DEBUG} || 0,
};

BEGIN {
    require Data::Dump if DEBUG;
}

#---------------------------------------------
# 监控服务器
#---------------------------------------------
sub {
    my @bank = @_;

    # 获取配置 + 日志
    my $zcfg = zkernel->zconfig();
    my $logger = zlogger;

    my %txn;
    my $cb = sub {
        my $packet = shift;
        $packet =~ s/^(\w+)://;
        my $type = $1;
 
        # 日志监控
        if ($type =~ /log/ ) {
        }
        # 交易请求
        elsif( $type =~/req/ ) {
            
        }
        # 交易应答
        elsif( $type =~/res/ ) {
        }
    };
    Zeta::POE::Sink->spawn(
        port     => $zcfg->{msvr}}{port},
        callback => $cb,
        codec    => $zcfg->{msvr}{codec},
    );

    # 运行
    $poe_kernel->run();

    exit 0;
};

__END__

