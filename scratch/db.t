#! /usr/bin/perl

use strict;
use warnings;
use DBI;
use Carp;
use Data::Dump;

my $cfg = {
    # 数据库配置 
    db => {
        dsn    => "dbi:DB2:$ENV{DB_NAME}",
        user   => "$ENV{DB_USER}",
        pass   => "$ENV{DB_PASS}",
        schema => "$ENV{DB_SCHEMA}",
    },
};

my $dbh = DBI->connect(
    @{$cfg->{db}}{qw/dsn user pass/},
    {
        RaiseError       => 1,
        PrintError       => 0,
        AutoCommit       => 0,
        FetchHashKeyName => 'NAME_lc',
        ChopBlanks       => 1,
        InactiveDestroy  => 1,
    }
);
unless($dbh) {
    zlogger->error("can not connet db[@{$cfg->{db}}{qw/dsn user pass/}], quit");
    exit 0;
}

# 设置默认schema
$dbh->do("set current schema $cfg->{db}->{schema}")
    or confess "can not set current schema $cfg->{db}->{schema}";

my $nhash = $dbh->prepare(<<EOF)->{NAME_lc_hash};
select * from log_txn
EOF
    delete $nhash->{ts_u};
    delete $nhash->{ts_c};
    delete $nhash->{tdate};
    my @keys = keys %$nhash;
    for (my $i = 0; $i < @keys; $i++) {
        $nhash->{$keys[$i]} = $i;
    }
    my %nhash = reverse %$nhash;
    my @idx = sort {int($a) <=> int($b)} keys %nhash;
    my @fld = @nhash{@idx};
    my $fldstr  = join ',', @fld;
    my $markstr = join ',', ('?') x @fld;

    # 准备SQL
    my $sql_ilog     = "insert into log_txn($fldstr) values($markstr)";
    my $sql_ulog_rev = "update log_txn set rev_flag = ? where b_tkey = ?";
    my $sql_ulog_can = "update log_txn set rev_flag = ? where b_tkey = ?";

    # 插入流水的statement
    my $sth_ilog =$dbh->prepare($sql_ilog);
    my $log = {
            c_name => 'cardsv',
            c_tcode => 'co',
        };
    my @val = (undef) x @fld;
    $val[$nhash->{$_}] = $log->{$_} for keys %$log;
    $sth_ilog->execute(@val) or die $sth_ilog->errstr;
    $dbh->commit;