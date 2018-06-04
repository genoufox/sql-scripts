select d.pay         as ��ֵ�ܶ�,
       a.account     as �˺�,
       c.userid      as �˺�id,
       c.truename    as vip����,
       c.mobilephone as vip�ֻ�,
       c.email       as vip����
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
