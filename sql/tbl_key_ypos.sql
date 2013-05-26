--
--
-- 本代本银行密钥匙信息
--
--
--  idx          char(32)  not null,   -- 银行主密钥索引
--  tmk          char(32)  not null,   -- 终端主密钥
--  pik          char(32)  not null,   -- pin密钥工作密钥
--  mak          char(32)  not null,   -- mac密钥工作密钥
--  mid          char(32)  not null,   -- 银行商户号(目前实际为易宝商户号)
--  tid          char(8)   not null,   -- 银行终端号(目前实际为易宝终端号)
--  tbn          char(6)   not null,   -- 当前终端批次号
--  tsn          char(6)   not null,   -- 当前终端流水号
--  memo         varchar(128),
--
--
drop   table tbl_key_ypos;
create table tbl_key_ypos(
-- 终端主密钥
-- pin密钥
-- mak密钥
    tmk          char(32)  not null, 
    pik          char(32)  not null,
    mak          char(32)  not null,

-- 银行号
-- 商户类型
-- 商户号
-- 终端号
    bcode        char(8)   not null,
    mcc          char(4)   not null,
    mid          char(15)  not null,
    tid          char(8)   not null,

-- 终端批次号
-- 终端流水号
    tbn          char(6)   not null, 
    tbn_min      char(6)   not null,
    tbn_max      char(6)   not null,
    tsn          char(6)   not null,
    tsn_min      char(6)   not null,
    tsn_max      char(6)   not null,

-------------------------------------------------
--  当前清算日
--  前一清算日
--  cur_stlm     char(4),
--  pre_stlm     char(4),
    
-- 创建时间
-- 更新时间
    rec_crt_ts   timestamp not null,
    rec_upd_ts   timestamp

) in datspace01 index in idxspace01;

insert into TBL_KEY_YPOS (TMK, PIK, MAK, BANK_CODE, MCC, MID, TID, TBN, TBN_MIN, TBN_MAX, TSN, TSN_MIN, TSN_MAX, REC_CRT_TS, REC_UPD_TS) values ('1111111111111111', '1111111111111111', '1111111111111111', '00000008', '0000', '874110145112480', '60101004', '800017', '800000', '900000', '800000', '800000', '999999', '2012-01-08 17:07:09', '2012-01-08 17:07:09');



