 create table vip_pay2015
 as
 select --a.game_au,
 --b.game_au  as game_au2016,
  a.userid,
  b.userid as userid2015,
  case
    when a.mobilephone is not null then
     1
    else
     0
  end as flag,
  --a.passport,
  a.rank    rank2014,
  b.rank    rank2015,
  c.pay2015
 
   from (select t.game_au,
                t.userid,
                t.passport,
                t.rank,
                t.code,
                t.mobilephone
           from bitask.t_dw_vip_vipinfo t
          where t.logtime = to_date('20141231', 'yyyymmdd')
            and t.rank >= 1) a
 
   left join (select t.game_au, t.userid, t.rank
                from bitask.t_dw_vip_vipinfo t
               where t.logtime = to_date('20151231', 'yyyymmdd')) b
     on a.userid = b.userid
 
   left join (select userid, sum(money) / 100 as pay2015
                from bitask.t_dw_au_billlog
               where logtime >= to_date('20150101', 'yyyymmdd')
                 and logtime < to_date('20160101', 'yyyymmdd')
                 and game_id != 4004
               group by userid) c
     on a.userid = c.userid
