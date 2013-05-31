#!/usr/bin/perl

use threads qw(
  yield
  stack_size  280000
  exit  threads_only
  stringify
);

my $thr = threads->create(
    sub {
        my $args = shift;
        my $cnt = 0;
        while(1) {
            warn "$args $cnt";
            sleep 1;
            $cnt++;
        }
    },
    'args',
);

my $thr1 = threads->create(
    sub {
        my $args = shift;
        my $cnt = 0;
        while(1) {
            warn "$args $cnt";
            sleep 1;
            $cnt++;
        }
    },
    'args',
);
$thr->join();


