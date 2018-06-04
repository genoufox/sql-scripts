select a.passport as 账号,
       a.userid as 账号id,
       case a.rank
         when 1 then
          '银卡'
         when 2 then
          '金卡'
         when 3 then
          '白金'
         when 4 then
          '终身'
         else
          '流失VIP'
       end as 会员级别,
       a.truename as vip姓名,
       a.mobilephone as vip手机,
       b.pay_2014 as "14年充值总额",
       c.pay_2015 as "15年充值总额",
       trunc(d.last_logout_time) as 最后登录时间

  from bitask.t_dw_vip_vipinfo a

  left join (select userid, sum(money) / 100 as pay_2014
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and logtime >= to_date('20140101', 'yyyymmdd')
                        and game_id = 3
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 3
                        and logtime < to_date('20150101', 'yyyymmdd'))
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay_2015
               from bitask.t_dw_au_billlog
              where game_id = 3
                and logtime >= to_date('20150101', 'yyyymmdd')
              group by userid) c
    on a.userid = c.userid

  left join bitask.t_dw_iwm_account_status d
    on a.userid = d.userid

 where a.logtime = to_date(sysdate - 2)
   and a.game_au = 3
   and d.last_logout_time < to_date(sysdate - 15)
   and d.last_logout_time >= to_date('20150101','yyyymmdd')
 order by rank desc ,trunc(d.last_logout_time) desc, c.pay_2015 desc NULLS LAST;
