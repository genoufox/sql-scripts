select a.userid,
       a.phone,
       b.��Ա���� ��Ա����1,
       case c.rank
         when 4 then
          '����'
         when 3 then
          '�׽�'
         when 2 then
          '��'
         when 1 then
          '����'
         when 0 then
          '��ʧ'
         else
          '��vip'
       end as ��Ա����2,
       b.����ֵ,
       b.�����ֵ �����ֵ����1,
       b.�ۼƳ�ֵ ��ֵ1,
       d.pay7 ������ֵ2,
       b.��ֵ���� ��ֵ����1,
       d.pay7_cnt ������ֵ����,
       e. login_time "7������ʱ��",
       e.top_level as ��߼���,
       b.�����½,
       b.����½ ����½1,
       trunc(e.login_last) ����½2

  from user_xa0815_2 a
  left join NVIP_XA0808  b
    on a.userid = b.�˺�id

  left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(sysdate - 2)) c
    on a.userid = c.userid

  left join (select userid,
                    sum(pay) / 100 as pay7,
                    count(logtime) as pay7_cnt
             
               from bitask.t_dw_xa_account_stat_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)
                and pay > 0
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    max(logtime) as login_last ,
                    max(top_level) as top_level,
                    trunc(sum(onlinetime) / 3600, 1) as login_time
               from bitask.t_dw_xa_account_stat_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)                
              group by userid) e
    on a.userid = e.userid
    
  where a.status = 1
