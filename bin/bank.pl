#! /bin/perl

use warnings;
use strict;

use IO::Socket;
use POE qw(Wheel::ListenAccept Wheel::ReadWrite);

POE::Session->create(
  inline_states => {
    _start => sub {
      # Start the server.
      $_[HEAP]{server} = POE::Wheel::ListenAccept->new(
        Handle => IO::Socket::INET->new(
          LocalPort => 9092,
          Listen => 5,
        ),
        AcceptEvent => "on_client_accept",
        ErrorEvent => "on_server_error",
      );
    },
    on_client_accept => sub {
      # Begin interacting with the client.
      my $client_socket = $_[ARG0];
      my $io_wheel = POE::Wheel::ReadWrite->new(
        Handle => $client_socket,
        InputEvent => "on_client_input",
        ErrorEvent => "on_client_error",
      );
      $_[HEAP]{client}{ $io_wheel->ID() } = $io_wheel;
    },
    on_server_error => sub {
      # Shut down server.
      my ($operation, $errnum, $errstr) = @_[ARG0, ARG1, ARG2];
      warn "Server $operation error $errnum: $errstr\n";
      delete $_[HEAP]{server};
    },
    on_client_input => sub {
      # Handle client input.
      my ($input, $wheel_id) = @_[ARG0, ARG1];
      #$input =~ tr[a-zA-Z][n-za-mN-ZA-M]; # ASCII rot13
      warn "got input [$input]";
      sleep(50);
      $_[HEAP]{client}{$wheel_id}->put($input);
    },
    on_client_error => sub {
      # Handle client error, including disconnect.
      my $wheel_id = $_[ARG3];
      print "Connection failed or ended.  Shutting down...\n";
      delete $_[HEAP]{client}{$wheel_id};
    },
  }
);

POE::Kernel->run();
exit;