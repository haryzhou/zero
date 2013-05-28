#!/usr/bin/perl
use Zeta::Run;
use Zeta::Serializer::JSON;
use Net::Stomp;
use Time::HiRes qw/sleep/;
use Carp;

sub {
    my $logger = zlogger;
    my $stomp;
    my $cnt = 0;
    while(1) {
        eval {
            $stomp  = zkernel->zstomp();
        };
        if ($@) {
            $logger->error("can not connect to stomp");
            if ($cnt++ == 10) {
                exit 0;
            }
            sleep 0.5;
            next;
        }
        last;
    }
    $logger->debug("stomp connected");

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
    my $sql_ulog_rev = "update log_txn set rev_flag = 1, rev_key = ? where b_tkey = ?";
    my $sql_ulog_can = "update log_txn set can_flag = ?, can_key = ? where b_tkey = ?";

    #prepare statement 
    my $ilog = $dbh->prepare($sql_ilog);
    my $sth_ulog_rev = $dbh->prepare($sql_ulog_rev);
    my $sth_ulog_can = $dbh->prepare($sql_ulog_can);


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
        # rev
        elsif($mode eq 'r') {
            $sth_ulog_rev->execute(@{$block->{data}});
            $dbh->commit();
        }
        # can
        elsif($mode eq 'c') {
            $sth_ulog_can->execute(@{$block->{data}});
            $dbh->commit();
        }
    	$stomp->ack({frame => $frame});
    }
    $stomp->disconnect();

};

__END__
