select a.account   as �˺�,
       a.userid    as �˺�id,
       b.pay       as ���ڳ�ֵ,
       c.name      as ��ֵ������,
       d.login_cnt as ��½����

  from IWM_R20151202_1k a

  left join (select userid,
                    zoneid,
                    sum(money) / 100 as pay,
                    row_number() over(partition by userid order by sum(money) desc) as rn
             
               from bitask.t_dw_au_billlog
              where game_id = 3
                and logtime < to_date('20151126', 'yyyymmdd')
                and logtime >= to_date('20151119', 'yyyymmdd')
              group by userid, zoneid) b
    on a.userid = b.userid
   and b.rn = 1

  left join (select zoneid,
                    name,
                    row_number() over(partition by zoneid order by version desc) as rn
               from bitask.t_dw_iwm_dic_serverlist) c
    on b.zoneid = c.zoneid
   and c.rn = 1

  left join (select userid, count(logtime) as login_cnt
               from bitask.t_dw_iwm_account_stat_day
              where logtime < to_date('20151126', 'yyyymmdd')
                and logtime >= to_date('20151119', 'yyyymmdd')
              group by userid) d
    on a.userid = d.userid
