#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use Zeta::Run;
use DBI;

#
# 加载集中配置文件
#
my $cfg  = do "$ENV{ZERO_HOME}/conf/zero.conf";
confess "[$@]" if $@;

1;

__END__
