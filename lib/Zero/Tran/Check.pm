package Zero::Tran::Check;
use strict;
use warnings;

sub new {
    my ($class, $zcfg, $logger) = @_;
    my $self = bless { zcfg => $zcfg, logger => $logger }, $class;
    return $self;
}

#
# 可考虑用redis来作:
# 1、实时风险模型
# 2、交易分流的切量管理
#
#------------------------------------------------------
# todo :
# 1> 信用卡限额:  每日, 每月
# 2> 非营业时间有交易
#
#
sub check {
        
}

1;

