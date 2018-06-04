--回流VIP基础数据：
create table vip_return0119_2014 as

select 2014      as year,
       a.userid,
       a.game_au,
       a.rank    as rank_t,
       b.rank    as rank_l,
       a.code    as code_t,
       b.code    as code_l

  from (select userid, rank, code, game_au
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20141231', 'yyyymmdd')) a
  left join (select userid, rank, code
               from bitask.t_dw_vip_vipinfo @racdb
              where logtime = to_date('20131231', 'yyyymmdd')) b
    on a.userid = b.userid
 where a.rank > = 1
   and b.rank = 0

create table vip_return0119_2015 as
select 2015      as year,
       a.userid,
       a.game_au,
       a.rank    as rank_t,
       b.rank    as rank_l,
       a.code    as code_t,
       b.code    as code_l

  from (select userid, rank, code, game_au
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20151231', 'yyyymmdd')) a
  left join (select userid, rank, code
               from bitask.t_dw_vip_vipinfo
              where logtime = to_date('20141231', 'yyyymmdd')) b
    on a.userid = b.userid
 where a.rank > = 1
   and b.rank = 0
;

create table vip3_return0119_2014 as

select 2014      as year,
       a.userid,
       a.game_au,
       a.rank    as rank_t,
       b.rank    as rank_l,
       a.code    as code_t,
       b.code    as code_l

  from (select userid, rank, code, game_au
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20141231', 'yyyymmdd')) a
  left join (select userid, rank, code
               from bitask.t_dw_vip_vipinfo @racdb
              where logtime = to_date('20131231', 'yyyymmdd')) b
    on a.userid = b.userid
 where a.rank > = 3
   and b.rank < 3

create table vip3_return0119_2015 as

select 2015      as year,
       a.userid,
       a.game_au,
       a.rank    as rank_t,
       b.rank    as rank_l,
       a.code    as code_t,
       b.code    as code_l

  from (select userid, rank, code, game_au
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20151231', 'yyyymmdd')) a
  left join (select userid, rank, code
               from bitask.t_dw_vip_vipinfo
              where logtime = to_date('20141231', 'yyyymmdd')) b
    on a.userid = b.userid
 where a.rank > = 3
   and b.rank < 3
