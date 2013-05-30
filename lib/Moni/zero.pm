package Moni::zero;
use strict;
use warnings;
use base qw/Moni/;

sub _init {
    my $self = shift;
    warn "Moni::zero _init is called";
}

sub _setup {
    warn "Moni::zero _setup is called";
    return shift;
}

sub _on_message {
    my ($self, $node, $type, $info) = @_;
    $self->{logger}->debug(__PACKAGE__ . "got [$node][$type][@$info]");
}

sub on_req {
}

sub on_res {
}

1;

__END__
zmoni_rate = insert into table moni_rate values(?, ?, ?, ?);

