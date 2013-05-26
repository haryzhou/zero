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

sub {
    my @bank = @_;

    # 获取配置
    # zkernel->zsetup();
    my $zcfg = zkernel->zconfig();
    my $logger = zlogger;

    ########################################################
    # 读所有模拟器配置
    my %all;
    for my $bname (@bank) {
        # 读主bank simu:  pack, unpack, tcode
        my $bsimu = do "$ENV{ZERO_HOME}/conf/bank/$bname.simu";
        confess "can not do file[$bname.simu] error[$@]" if $@;

        # 读交易模拟
        my %proc;
        for my $simu (<$ENV{ZERO_HOME}/conf/bank/$bname/*.simu>) {
            $simu =~ /([^\/]+).simu$/;
            $proc{$1} = do $simu;
            confess "can not do file[$simu] error[$@]" if $@;
        }
        $all{$bname}{main} = $bsimu;
        $all{$bname}{proc} = { %proc };
    }
    $zcfg->{simu} = \%all;
    Data::Dump->dump(\%all);

    ########################################################
    # 启动所需的银行模拟
    for my $bname (@bank) {
        $logger->debug("启动模拟器$bname:\n" . Data::Dump->dump($zcfg->{bank}{$bname}));

        # 模拟器的主回调
        my $cb = sub {
            my $packet = shift;
            my $req    = $zcfg->{simu}{$bname}{main}{unpack}->($packet);   # 解包
            my $tcode  = $zcfg->{simu}{$bname}{main}{tcode}->($req);       # 内部交易代码
            my $res    = $zcfg->{simu}{$bname}{proc}{$tcode}->($req);      # 
            return $zcfg->{simu}{$bname}{main}{pack}->($res);              #
        };

        Zeta::POE::TCPD->spawn(
            port     => $zcfg->{bank}{$bname}{port},
            callback => $cb,
            codec    => $zcfg->{bank}{$bname}{codec},
        );
    }

    # 运行
    $poe_kernel->run();

    exit 0;
};

__END__

