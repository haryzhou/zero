package Moni;    
use strict;
use warnings;
use POE;
use POE::Session;

#
# 构造函数
# Zero::Moni->new(
#     name => $name
# );
#
sub new {
    my $class = shift;
    my $self =  bless { @_ }, $class;
    $self->_init();
    return $self;
}


# $self->spawn($zcfg, $logger, $index)
#
sub spawn {

    my ($self, $zcfg, $logger, $index) = @_;

    $self->{zcfg}   = $zcfg;
    $self->{logger} = $logger;

    # 
    $self->_setup();

    POE::Session->create(
        object_states => [
            $self => {
                on_message => 'on_message',
            },
        ],

        inline_states =>  {
            _start => sub { 
                 $logger->debug("$self->{name} started");
                 $_[KERNEL]->alias_set($self->{name}); 
            },
        },
    );
}

#
#
sub on_message {
     my ($self, $node, $type, $info) = @_[OBJECT, ARG0, ARG1, ARG2, ARG3]; 
     $self->_on_message($node, $type, $info);
}

# 子类实现
sub _on_message { shift->{logger}->debug( "tobe implemented by child"); }
sub _setup { return shift; }
sub _init  { return shift; }

#
1;

__END__
