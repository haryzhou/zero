#! /bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use POE qw(Wheel::ReadWrite);

POE::Session->create(
  inline_states => {
    _start => sub {
      # Note: IO::Socket::INET will block.  We recommend
      # POE::Wheel::SocketFactory or POE::Component::Client::TCP if
      # blocking is contraindicated.
      $_[HEAP]{client} = POE::Wheel::ReadWrite->new(
        Handle => IO::Socket::INET->new(
          PeerHost => '127.0.0.1',
          PeerPort => 7971,
        ),
        InputEvent => 'on_remote_data',
        ErrorEvent => 'on_remote_fail',
      );

      print "Connected.  Sending request...\n";
      $_[HEAP]{client}->put(
        "hello"
      );
    },
    on_remote_data => sub {
      print "Received: $_[ARG0]\n";
    },
    on_remote_fail => sub {
      print "Connection failed or ended.  Shutting down...\n";
      delete $_[HEAP]{client};
    },
  },
);

POE::Kernel->run();
exit;
