package Zero::HSM;
use strict;
use warnings;
use POE;
use POE::Session;

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
    my $logname;
    if ($index =~ /\d+/) {
        $logname = "Zhsm.$index.log";
    }
    else {
        $logname = "Zhsm.log";
    }
    $self->{logger} = $logger->clone($logname);

    # $self->{check}  = Zero::Tran::Check->new($zcfg, $self->{logger});

    # 建立tran
    return POE::Session->create(
        object_states => [
            $self => {
                on_tranpin => 'on_tranpin',     # 收到渠道请求
                on_genmac  => 'on_genmac',
                on_vermac  => 'on_vermac',
            },
        ],
        inline_states => {
            _start => sub {
               $_[KERNEL]->alias_set('hsm');
            },
        }
    );
}

#
# 收到tranpin请求
#
sub on_tranpin {
    my ($self, $req, $src, $event) = @_[OBJECT, ARG0, ARG1, ARG2];
    my $res;
    $_[KERNEL]->post($src, $event, $res);
    return 1;
}

#
# 收到genmac请求
#
sub on_genmac {
    my ($self, $req, $src, $event) = @_[OBJECT, ARG0, ARG1, ARG2];
    my $res;
    $_[KERNEL]->post($src, $event, $res);
}

#
# 收到vermac请求
#
sub on_vermac {
    my ($self, $req, $src, $event) = @_[OBJECT, ARG0, ARG1, ARG2];
    my $res;
    $_[KERNEL]->post($src, $event, $res);
}

1;

