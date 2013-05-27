drop table log_txn;
drop sequence seq_log_txn; 
create table log_txn (

   --id          bigint not null,
   tdate       date default current date,

-------------- 通用信息字段--------------
-- 主账号       622588210019
-- 交易金额
-- 姓名
-- 证件号 
-- 证件类型
-- 手机号
-- cvv
-- 有效期
   x_pan       char(20),
   x_amt       char(12), 
   x_name      char(20),
   x_ctype     char(2),
   x_cnum      char(20),
   x_tel       char(15),
   x_cvv       char(5),
   x_expire    char(4),

-------------- 渠道方  --------------
-- 发起方机构名称
-- 发起方发起交易代码
-- 发起方数据
-- 发起方数据
-- 发起方响应代码
-- 发起方勾兑key
-- 发起方方商户号
-- 发起方方终端号
   c_name     char(16)  not null,
   c_tcode    char(8)   not null,
   c_tkey     char(32),
   c_mid      char(32),
   c_tid      char(32),
   c_req      varchar(1024),
   c_res      varchar(512),
   c_resp     char(2),

-- 撤销标志
-- 撤销key
-- 冲正标志
-- 冲正key
   can_key    char(32),
   can_flag   char(1),
   rev_key    char(32),
   rev_flag   char(1),

-------------- 银行方 --------------
-- 机构方1: 名称
-- 机构方1: 交易代码
-- 机构方1: 响应码
-- 机构方1: 数据
-- 机构方1: 数据
-- 机构方1: 勾兑key
   b_name     char(16),
   b_tcode    char(8),
   b_resp     char(8),
   b_req      varchar(1024),
   b_res      varchar(512),
   b_tkey     char(32),

-------------- 时间戳信息 --------------
   ts_c  timestamp default current timestamp,
   ts_u  timestamp

) in tbs_dat index in tbs_idx;
--alter table log_txn add primary key(id);

-- 索引
create index idx_log_txn_1 on log_txn(c_name, c_tkey);
create index idx_log_txn_2 on log_txn(b_name, b_tkey);
create index idx_log_txn_3 on log_txn(c_name, can_key);
create index idx_log_txn_4 on log_txn(c_name, rev_key);


--create sequence seq_log_txn;


