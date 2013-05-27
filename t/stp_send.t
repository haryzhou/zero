use Net::Stomp;
my $stomp = Net::Stomp->new({ 
    hostname => 'localhost', 
    port => '61616' 
});

$stomp->connect({ 
    login    => 'hello', 
    passcode => 'there' 
});

$stomp->send({ 
    destination => '/queue/zero.backend', 
    body        => 'test message' 
});
$stomp->disconnect;
