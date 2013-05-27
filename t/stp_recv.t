use Net::Stomp;
my $stomp = Net::Stomp->new({ 
    hostname => 'localhost', 
    port     => '61616' 
});
$stomp->connect({ 
    login    => 'hello', 
    passcode => 'there' 
});
$stomp->subscribe({   
    destination             => '/queue/zero.backend',
    'ack'                   => 'client',
    'activemq.prefetchSize' => 1
});
while (1) {
    my $frame = $stomp->receive_frame;
    warn $frame->body; # do something here
    $stomp->ack( { frame => $frame } );
}
$stomp->disconnect;

