#!/usr/bin/perl
use strict;
use warnings;
use Zeta::Run;
use DBI;
use Carp;
use POE;
use Time::HiRes qw/sleep/;
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
    
    my $cnt = 0;
    my $msvr;
    # 连接监控服务器
    while(1) {
        $msvr = IO::Socket::INET->new(
            PeerAddr => $zcfg->{msvr}{host},
            PeerPort => $zcfg->{msvr}{port}
        );
        
        unless($msvr) {
            $logger->error("无法连接到监控服务器[$zcfg->{msvr}{host}:$zcfg->{msvr}{port}], retry...");
            sleep(0.5);
            next if $cnt++ < 10;
            exit 0;
        }
        last;
    }

    # 不断从监控队列中读取监控消息, 发送到监控服务器上
    my $bytes;
    my $mtype = 0;
    while($monq->recv(\$bytes, \$mtype)) {
        my $len = sprintf("%04d", length $bytes);
        $logger->debug("recv msg[$len] <<<<<<<<:\n". $bytes);
        $msvr->print($len . $bytes);
        $mtype = 0;
    }
};



