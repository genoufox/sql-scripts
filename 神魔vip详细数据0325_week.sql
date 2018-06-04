select b.game_ab ��Ŀ����,
       a.game_au ��Ŀ���,
       a.userid �˺�id,
       a.passport �˺�,
       case a.rank
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
       a.truename ����,
       a.mobilephone �ֻ�,
       a.email ����,
       trunc(a.starttime) ��Ա��ʼʱ��,
       trunc(a.endtime) ��Ա�����ʱ��,
       d.pay30 "30���ڳ�ֵ",
       c.pay7 "7�ճ�ֵ",
       a.vamount "90���ڳ�ֵ",
       f.login_cnt_7 "��7���½����",
       g.login_cnt_30 "��30���½����",
       h.consumption_7 as "��7������",
       TRUNC(l.first_logout_time) �����½,
       TRUNC(l.last_logout_time) ����¼,
       trunc(f.login_time_7, 1) as "��7���½ʱ��"

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��trunc(sysdate) - 2��
           and game_au = 11) a

  join vip_focus0321 b
    on a.passport = b.passport

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 7
                and game_id != 4004
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id != 4004
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    count(logtime) as login_cnt_7,
                    sum(onlinetime) / 3600 as login_time_7
               from BITASK.t_dw_sm_account_stat_day
              where logtime >= trunc(sysdate) - 7
              group by userid) f
    on a.userid = f.userid

  left join (select userid, count(logtime) as login_cnt_30
               from BITASK.t_dw_sm_account_stat_day
              where logtime >= trunc(sysdate) - 30
              group by userid) g
    on a.userid = g.userid

  left join (select userid, sum(cash_need) as consumption_7
               from bitask.t_dw_sm_glog_shoptrade
              where logtime >= trunc(sysdate) - 7
              group by userid) h
    on a.userid = h.userid

  left join bitask.t_dw_sm_account_status l
    on a.userid = l.userid
