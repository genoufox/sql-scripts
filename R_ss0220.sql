select a.game_id ��Ŀ���,
       b.userid �˺�id,
       b.passport �˺�,
       case b.rank
         when 1 then
          '����'
         when 2 then
          '��'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          '��ʧ'
       end as ��Ա����,
       b.truename ����,
       b.mobilephone �ֻ�,
       b.email ����,
       trunc(b.starttime) ��Ա��ʼʱ��,
       trunc(b.endtime) ��Ա�����ʱ��,
       b.Tamount �ۼƳ�ֵ,
       a.pay_ly ȥ���ֵ,
       b.vamount "90���ڳ�ֵ",
       d.pay30 "30���ڳ�ֵ",
       c.pay7 "7�ճ�ֵ",
       g.login_cnt_7 "��7���½����",
       trunc(g.login_time_7, 1) as "��7���½ʱ��",
       h.login_cnt_30 "��30���½����",
       0 as "��30������",
       TRUNC(l.first_logout_time) �����½,
       TRUNC(l.last_logout_time) ����¼

  from (select userid, game_id, pay_ly
        
          from (select userid, game_id, sum(money) / 100 as pay_ly
                  from bitask.t_dw_au_billlog
                 where userid > 33
                   and logtime >= trunc(sysdate - 365)
                   and game_id in
                       (1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 15, 17, 18, 73)
                 group by userid, game_id)
        
         where pay_ly >= 100000) a

  left join (select game_au,
                    userid,
                    passport,
                    rank,
                    truename,
                    mobilephone,
                    email,
                    vamount,
                    Tamount,
                    starttime,
                    endtime
               from bitask.t_dw_vip_vipinfo
              where logtime = to_char��trunc(sysdate) - 2��) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 7
                and game_id = 73
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id = 73
              group by userid) d
    on a.userid = d.userid

  left join (select userid_,
                    count(logtime) as login_cnt_7,
                    sum(time_) / 3600 as login_time_7
               from bitask.T_000073_LOG_ROLELOGOUT
              where logtime >= trunc(sysdate) - 7
              group by userid_) g
    on a.userid = g.userid_

  left join (select userid_, count(logtime) as login_cnt_30
               from bitask.T_000073_LOG_ROLELOGIN
              where logtime >= trunc(sysdate - 30, 'MM')
                and logtime < trunc(sysdate, 'MM')
              group by userid_) h
    on a.userid = h.userid_

  left join (select userid_, sum(payment_amount_) / 100 as consumption
               from (select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_SERVICE
                      where logtime >= trunc(sysdate - 30)
                     union all
                     select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_TRADE
                      where logtime >= trunc(sysdate - 30))
              group by userid_) i
    on a.userid = i.userid_

  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33
                and logtime = trunc(sysdate - 2)) j
    on a.userid = j.userid_
   and j.rolelev_rank = 1

  left join bitask.T_000073_account_status l
    on a.userid = l.userid

 where a.game_id = 73
