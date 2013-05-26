package Zero::Bank::ICBC;
use strict;
use warnings;
use base qw/Zero::Bank/;

sub _init  { warn "Zero::Bank::ICBC _init called"; return shift; }
sub _setup { warn "Zero::Bank::ICBC _setup called"; return shift; }
sub pack   { shift; return shift; }
sub unpack { shift; return shift; }

1;

__DATA__
##################################################################################
#         易宝pos终端规范 
##################################################################################
# 说明:
# id:    域号
# type:  检验数据是否只包含指定类型的字符
# len:   数据域长度(如果是固定域的话) || 数据域的最大长度(llvar|lllvar)
# class: 变长|固定长 fix|llvar|lllvar
# denc:  数据域的数据编码方式:  bcd: | bcdl: bcd编码左靠
# lenc:  llvar/lllvar数据的长度部分编码方式
##################################################################################
#       0      1      2         3        4         5
# id    type   len    class     lenc     denc      desc      
##################################################################################
  2     n      19     llvar     bcd      bcdl      主账号
  3     n      6      fix       ascii    bcd       交易处理码
  4     n      12     fix       ascii    bcd       交易金额
  11    n      6      fix       ascii    bcd       受卡方系统跟踪号
  12    n      6      fix       ascii    bcd       受卡方所在地时间
  13    n      4      fix       ascii    bcd       受卡方所在地日期
  14    n      4      fix       ascii    bcd       卡有效期
  15    n      4      fix       ascii    bcd       清算日期
  22    n      3      fix       ascii    bcdl      服务点输入方式码
  23    n      3      fix       ascii    bcd       卡序列号
  25    n      2      fix       ascii    bcdl      服务点条件码
  26    n      2      fix       ascii    bcd       服务点PIN获取码
  32    n      11     llvar     bcd      bcdl      受理方标识码
  35    z      37     llvar     bcd      bcdl      第二磁道数据
  36    z      104    lllvar    bcd      bcdl      第三磁道数据
  37    an     12     fix       ascii    ascii     检索参考号
  38    an     6      fix       ascii    ascii     授权标识应答码
  39    an     2      fix       ascii    ascii     应答码
  41    ans    8      fix       ascii    ascii     受卡机终端标识码
  42    ans    15     fix       ascii    ascii     受卡方标识码
  44    an     25     llvar     bcd      ascii     附加响应数据
  48    n      322    lllvar    bcd      bcdl      附加数据——私有
  49    an     3      fix       ascii    ascii     交易货币代码
  52    b      8      binary    ascii    ascii     个人标识码数据
  53    n      16     fix       ascii    bcd       安全控制信息
  54    an     20     lllvar    bcd      ascii     附加金额
  55    b      255    lllvar    bcd      ascii     IC卡数据域
  56    ans    100    lllvar    bcd      ascii     自定义域
  58    ans    100    lllvar    bcd      ascii     PBOC电子钱包标准的交易信息
  59    ans    160    lllvar    bcd      ascii     自定义域
  60    n      13     lllvar    bcd      bcdl      自定义域
  61    n      29     lllvar    bcd      bcdl      原始信息域
  62    ans    512    lllvar    bcd      ascii     自定义域
  63    ans    163    lllvar    bcd      ascii     自定义域
  64    b      8      binary    ascii    ascii     报文鉴别码 
##################################################################################

