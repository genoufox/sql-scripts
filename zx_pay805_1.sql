create table pay0805_2
  as
select userid,
       trunc(logtime, 'yyyy') year,
       count(trunc(logtime,'dd')) as pay_cnt,
       sum(money) as payment
  from (select userid, logtime, money
          from bitask.t_dw_au_billlog
         where userid > 33
           and game_id = 4
           and logtime < to_date('20160101', 'yyyymmdd')
        
        union all
        select userid, logtime, money
          from bitask.t_dw_au_billlog @racdb
         where userid > 33
           and logtime >= to_date('20140101', 'yyyymmdd')
           and logtime < to_date('20140701', 'yyyymmdd')
           and game_id = 4)
 group by userid, trunc(logtime, 'yyyy')
having sum(money) > 0
