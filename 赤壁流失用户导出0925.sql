select 
a.userid   as �˺�id,
a.passport as �˺�,
a.rank     as �ȼ�, 

/*      c.pay2015          as "15���ֵ",
d.pay2014          as "14���ֵ",  */

e.last_logout_time as ����¼ʱ�� 
  from bitask.t_dw_vip_vipinfo a

/*  left join (select userid, sum(money) / 100 as pay2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 5
                and logtime >= to_date('20150101', 'yyyymmdd')
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay2014
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 5
                and logtime >= to_date('20140101', 'yyyymmdd')
                and logtime < to_date('20150101', 'yyyymmdd')
              group by userid) d
    on a.userid = d.userid
*/

  left join bitask.t_dw_cb_account_status e
    on a.userid = e.userid

 where a.logtime = to_char��sysdate - 1��
   and a.game_au = 5
   and e.last_logout_time < to_date('20150821', 'yyyymmdd')
   and e.last_logout_time >= to_date('20140101', 'yyyymmdd')
 order by e.last_logout_time desc, rank desc
