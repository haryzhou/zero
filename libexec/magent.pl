#!/usr/bin/perl
use strict;
use warnings;
use Zeta::Run;
use DBI;
use Carp;
use POE;

use constant{
    DEBUG => $ENV{ZERO_DEBUG} || 0,
};

BEGIN {
    require Data::Dump if DEBUG;
}

sub {
    # 获取配置与日志
    my $zcfg = zkernel->zconfig();
    my $logger = zlogger;
    my $monq = $zcfg->{monq};

    # 连接监控服务器
    my $msvr = IO::Socket::INET->new(
        PeerAddr => $zcfg->{msvr}{host},
        PeerPort => $zcfg->{msvr}{port}
    );

    my $bytes;
    my $mtype = 0;
    while($monq->recv(\$bytes, \$mtype)) {
        # 监控消息: "req|$self->{name}|$c_tcode|$c_tkey|$c_mid|$ts_in->[0]|$ts_in->[1]";
        # 发送到监控服务器: 平台|节点|进程|$bytes
        my $len = sprintf("04%d", length $bytes);
        $msvr->print($len . $bytes);
    }

};



