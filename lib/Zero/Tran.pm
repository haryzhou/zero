package Zero::Tran;
use strict;
use warnings;
use POE;
use Zero::Tran::Route;
use Zero::Tran::Check;

#
# 交易处理进程
#
sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

#
# 创建交易处理进程
# $self->spawn($zcfg, $logger)
#
sub spawn {

    my ($self, $zcfg, $logger, $index) = @_;

    # 重置日志
    # my $logname;
    # if ($index =~ /\d+/) {
    #     $logname = "Ztran.$index.log";
    # }
    # else {
    #     $logname = "Ztran.log";
    # }
    # $self->{logger} = $logger->clone($logname);
    $self->{logger} = $logger;

    # 配置, 路由，控制
    $self->{zcfg}   = $zcfg;
    $self->{route}  = Zero::Tran::Route->new($zcfg, $self->{logger});
    # $self->{check}  = Zero::Tran::Check->new($zcfg, $self->{logger});

    # 建立tran
    return POE::Session->create(
        object_states => [
            $self => {
                on_chnl => 'on_chnl',     # 收到渠道请求
                #on_bank => 'on_bank',     # 收到银行应答
            },
        ],
        inline_states => {
            _start => sub {
               $_[KERNEL]->alias_set('tran');
            },
        }
    );
}

#
# 收到渠道请求:
#-------------------------------------------------
# {
#    chnl => 'cardsv',
#    creq => $creq',
#    cid  => $cid,
# }
# 处理:
#-------------------------------------------------
#    1> 业务检查()
#    2> 获取路由
#    3> 发送到目标银行POE进程
#
sub on_chnl {

    my $self = $_[OBJECT];
    my $tran = $_[ARG0];

    # 1> 业务检查
    # $self->{check}->check($tran);

    # 2> 获取路由信息
    my $rif = $self->{route}->route($tran);
    $self->{logger}->debug("[tran] [$tran->{chnl}:$tran->{c_tcode}]路由到$rif->{dst}");
    $tran->{b_tcode} = $tran->{c_tcode};

    # 3> 发送给目标银行POE进程
    $tran->{bank} = $rif->{dst};
    $_[KERNEL]->post($rif->{dst}, 'on_tran', $tran, 0);

    return 1;
}

1;

__END__

#
# 收到银行应答:
#-------------------------------------------------
# {
#     chnl => 'cardsv',
#     bank => 'icbc',
#     cid  => $cid,
#     bid  => $bid,
#     creq => $creq,
#     cres => $cres,
#     breq => $breq,
#     bres => $bres
# }
# 处理:
#-------------------------------------------------
# 
#
sub on_bank {
    my $self = $_[OBJECT];
    my $tran = $_[ARG0];
    $_[KERNEL]->post($tran->{chnl}, 'on_tran', $tran);
}

1;



