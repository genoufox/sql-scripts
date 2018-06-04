select a.*,
       b.pay as ��ֵ,
       c.login_first �����½,
       login_cnt ��½����,
       trunc(login_time, 1) ��½ʱ��
  from VIP_MZ0418 a

  left join (select userid, sum(money) / 100 as pay
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160407', 'yyyymmdd')
                and game_id = 9
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    min(logtime) as login_first,
                    count(logtime) as login_cnt,
                    sum(onlinetime) / 3600 as login_time
               from BITASK.t_dw_mz_account_stat_day
              where logtime >= to_date('20160407', 'yyyymmdd')
              group by userid) c
    on a.userid = c.userid
 order by pay desc nulls last, login_cnt desc nulls last
