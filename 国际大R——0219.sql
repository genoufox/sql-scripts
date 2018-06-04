create table lc_iwm0217_2
as
select a.*, b.pay2015, c.login_last
  from (select userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               code,
               Vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date(sysdate - 2)
           and rank >= 3
           and game_au = 3) a

  left join (select userid, sum(money) / 100 as pay2015
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 3
                        and logtime >= to_date('20150101', 'yyyymmdd')
                        and logtime < to_date('20160101', 'yyyymmdd'))
              group by userid) b
    on a.userid = b.userid

  left join (select userid, max(logtime) as login_last
               from bitask.t_dw_iwm_account_status_day
              where logtime >= to_date('20150101', 'yyyymmdd')
                and logtime < to_date('20160101', 'yyyymmdd')
              group by userid) c
    on a.userid = c.userid

