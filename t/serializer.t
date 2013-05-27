#! /usr/bin/perl

use strict;
use warnings;
use Zeta::Serializer::JSON;

use Data::Dump;
my $seria = Zeta::Serializer::JSON->new();

Data::Dump->dump($seria->serialize({'a' => 1}));