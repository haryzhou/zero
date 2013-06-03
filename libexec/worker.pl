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
    # 子进程重新设置
    zkernel->zsetup();

    # 获取配置与日志
    my $zcfg = zkernel->zconfig();
    my $logger = zlogger;

    # 启动 - 交易处理
    $zcfg->{tran}->spawn($zcfg,$logger);

    # 启动 - 银行
    $zcfg->{bank}->{$_}->spawn($zcfg, $logger) for keys %{$zcfg->{bank}};

    # 启动 - 渠道
    $zcfg->{chnl}->{$_}->spawn($zcfg, $logger) for keys %{$zcfg->{chnl}};

    # 运行
    $poe_kernel->run();

    exit 0;
};

__END__

