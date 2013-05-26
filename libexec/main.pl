#!/usr/bin/perl
use strict;
use warnings;
use Zeta::Run;

use POE;
use Zeta::POE::HTTPD;

use constant {
    DEBUG => $ENV{ZAPP_DEBUG} || 0,
};

BEGIN {
    require Data::Dump if DEBUG;
}

sub { 
    while(1) { 
        pause(); 
    } 
};

__END__

