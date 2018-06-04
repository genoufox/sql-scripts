create table vip3_added
as 
select *
  from (select userid
          from bitask.t_dw_vip_vipinfo
         where rank >= 3
           and logtime >= to_date('20140801', 'yyyymmdd')
        minus
        select userid
          from bitask.t_dw_vip_vipinfo
         where rank >= 3
           and logtime = to_date('20140731', 'yyyymmdd'))
;
create table server_num1210
as
select to_char(time_stmp, 'yymm') as month,
       userid,
       passport,
       count(distinct zoneid) as server_num
  from (select b.time_stmp, a.userid, b.passport, c.logtime, c.zoneid
          from vip3_added a
          join (select userid, passport, min(logtime) as time_stmp
                 from bitask.t_dw_vip_vipinfo
                where rank >= 3
                  and logtime >= to_date('20140801', 'yyyymmdd')
                  and game_au = 4
                group by userid, passport) b
            on a.userid = b.userid
        
          left join (select userid, logtime, zoneid
                      from bitask.t_dw_au_billlog
                     where game_id = 4) c
            on a.userid = c.userid
         where c.logtime >= b.time_stmp - 90
           and c.logtime < b.time_stmp)
 group by to_char(time_stmp, 'yymm'), userid, passport
