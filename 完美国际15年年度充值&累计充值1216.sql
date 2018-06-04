select a.*,
       b.userid as �˺�id,
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
          null
       end as ��Ա����,
       c.pay_2015 as "15���ֵ",
       d.pay_total as �ۼƳ�ֵ
  from IWM_HX1216_1 a
  left join bitask.t_dw_vip_vipinfo b
    on a.account = b.passport
   and b.logtime = to_date(sysdate - 2)

  left join (select userid, sum(pay) / 100 as pay_2015
               from bitask.t_dw_iwm_account_status_day
              where logtime >= to_date('20150101', 'yyyymmdd')
              group by userid) c
    on b.userid = c.userid

  left join (select userid, sum(pay) / 100 as pay_total
               from (select userid, pay
                       from bitask.t_dw_iwm_account_status_day
                     union all
                     select userid, pay
                       from bitask.t_dw_iwm_account_status_day @racdb
                      where logtime < to_date('20140701', 'yyyymmdd'))
              group by userid) d
    on b.userid = d.userid
