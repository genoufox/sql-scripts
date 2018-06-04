select a.passport as �˺�,
       a.userid as �˺�id,
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
          '��ʧVIP'
       end as ��Ա����,
       a.truename as vip����,
       a.mobilephone as vip�ֻ�,
       b.pay2015 as "15���ֵ",
       c.pay2014 as "14���ֵ",
       trunc(d.last_logout_time) as ����¼ʱ��

  from bitask.t_dw_vip_vipinfo a

  left join (select userid, sum(money) / 100 as pay2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 3
                and logtime >= to_date('20150101', 'yyyymmdd')
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay2014
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where userid > 33
                        and game_id = 3
                        and logtime >= to_date('20140101', 'yyyymmdd')
                        and logtime < to_date('20140307', 'yyyymmdd')
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 3
                        and logtime < to_date('20150101', 'yyyymmdd'))
              group by userid) c
    on a.userid = c.userid

  left join bitask.t_dw_iwm_account_status d
    on a.userid = d.userid

 where a.logtime = to_date(sysdate - 2)
   and a.game_au = 3
   and d.last_logout_time < to_date(sysdate - 15)
 order by b.pay2015 desc NULLS LAST,
          c.pay2014 desc NULLS LAST,
          trunc(d.last_logout_time) desc;
