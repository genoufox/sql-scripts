select *
  from (select c.userid   as 账号id,
               c.code     as 身份证号,
               d.pay_2015 as "15年充值"
          from (select b.userid, a.code
                  from (select distinct code from top1000_2015_new_0121) a
                  join (select userid, rank, code
                         from bitask.t_dw_vip_vipinfo
                        where logtime = to_date('20151231', 'yyyymmdd')) b
                    on a.code = b.code) c
        
          left join (select userid, sum(money) / 100 as pay_2015
                      from (select userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150101', 'yyyymmdd')
                               and logtime < to_date('20160101', 'yyyymmdd')
                               and game_id != 4004)
                     group by userid) d
            on c.userid = d.userid
        union
        select userid as 账号id, code as 身份证号, pay_2013 as "15年充值"
          from top1000_2015_new_0121
         where code is null)
 order by 2
