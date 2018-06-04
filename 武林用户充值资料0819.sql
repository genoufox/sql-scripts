select d.pay         as 充值总额,
       a.account     as 账号,
       c.userid      as 账号id,
       c.truename    as vip姓名,
       c.mobilephone as vip手机,
       c.email       as vip邮箱
  from VIP_WL_ZL0818 a

  left join(bitask.t_dw_vip_vipinfo) c
    on a.account = c.passport
   and c.logtime = to_date(sysdate - 2)
   and c.game_au = 2

  left join (select userid, sum(money) / 100 as pay
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and game_id = 2
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 2)
              group by userid) d
    on c.userid = d.userid
 order by 2 desc
