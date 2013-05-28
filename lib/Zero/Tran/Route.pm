package Zero::Tran::Route;
use strict;
use warnings;

#
#  $zcfg
#  $logger
#
sub new {
    my ($class, $zcfg, $logger) = @_;
    my $self = bless { logger => $logger, zcfg => $zcfg }, $class;
    return $self;
}

#
# 获取路由
#
sub route {
    my ($self, $tran) = @_;
   
    # 特殊 
    $tran->{b_tcode} = $tran->{c_tcode};

    # 测试路由
    return {
        dst   => 'spd',
        tcode => 'co',
    };
}

1;

__DATA__

