#!/usr/bin/perl
use strict;
use warnings;
use Zeta::Run;
use DBI;
use Carp;
use POE;
use Zeta::POE::TCPD;
use Zeta::POE::Sink;

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

    my $pindex;
    if ($0 =~ /^(\w+)\.(\d+)$/) {
        $pindex = $2;
    }
    else {
        $pindex = '';
    }

    my %txn;
    my $cb = sub {
        my $packet = shift;
        
        # 日志监控
        if( $packet =~ /\[(.+)\|(.+)\|(.+)\]/) {
            $logger->debug("recv[log]<<<<<<<<\n".$packet);
        }
        # 
        else{
            # 将采集信息发送给不同的分析器
            my ($app, $node, $type, @info) = split '\|', $packet;
            $logger->debug("got [$app][$node][$type]: $packet");
            $logger->debug("post to session[$app.on_message]...");
            $poe_kernel->post($app, 'on_message', $node, $type, \@info);
        }
    };
    Zeta::POE::Sink->spawn(
        port     => $zcfg->{msvr}{port},
        callback => $cb,
        codec    => $zcfg->{msvr}{codec},
    );

    # 启动所有分析器 
    $zcfg->{moni}{$_}->spawn($zcfg, $logger, $pindex) for keys %{$zcfg->{moni}};

    # 运行
    $poe_kernel->run();

    exit 0;
};

__END__

