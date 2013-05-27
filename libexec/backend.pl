#!/usr/bin/perl

use Zeta::Run;
use Zeta::Serializer::JSON;
use Net::Stomp;
use Carp;

sub {
    my $logger = zlogger;
    my $stomp  = zkernel->zstomp();
    my $dbh    = zkernel->dbh_bke();
    my $zcfg   = zkernel->zconfig();
    my $ser    = $zcfg->{serializer};
 
    $stomp->subscribe({
    	'destination'           => $zcfg->{backend},
     	'ack'                   => 'client',
    	'activemq.prefetchSize' => 1,
    });


    # name hash
    my $nhash = $dbh->prepare("select * from log_txn")->{NAME_lc_hash};
    delete @{$nhash}{qw/ts_u tdate ts_c/};
    my @keys = keys %$nhash;
    for (my $i = 0; $i < @keys; $i++) {
        $nhash->{$keys[$i]} = $i;
    }
    my %nhash = reverse %$nhash;
    my @idx = sort {int($a) <=> int($b)} keys %nhash;
    my @fld = @nhash{@idx};
    my $fldstr  = join ',', @fld;
    my $markstr = join ',', ('?') x @fld;
    my $ustr    = join(',', map { "$_ = ?" } @fld);

    # 准备SQL
    my $sql_ilog  = "insert into log_txn($fldstr) values($markstr)";
    my $sql_ulog  = "update log_txn($fldstr) set $ustr";

    #prepare statement 
    my $ilog = $dbh->prepare($sql_ilog);
    my $ulog = $dbh->prepare($sql_ulog);

    while (1) {
    	my $frame = $stomp->receive_frame;
    	$logger->debug_hex("recv data<<<<<<<<:",  $frame->body);
        my $block = $ser->deserialize($frame->body);
        my $mode = delete $block->{_mode};

        # insert
        if ($mode eq 'i') { 
            my @val = (undef) x @fld;
            $val[$nhash->{$_}] = $block->{$_} for (keys %$block);
            $ilog->execute(@val);
            $dbh->commit();
        }
        # update
        elsif($mode eq 'u') {
            my @val = (undef) x @fld;
            $val[$nhash->{$_}] = $block->{$_} for (keys %$block);
            $ulog->execute(@val);
            $dbh->commit();
        }
    	$stomp->ack({frame => $frame});
    }
    $stomp->disconnect();

};

__END__
