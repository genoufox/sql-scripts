select datetime as 时间,
       ADD_VIP AS 新增白金VIP,
       vip_left_7th as 白金vip留存,
       round(vip_left_7th / ADD_VIP * 100, 2) as 留存百分比
  from (select to_date(sysdate - 183) as datetime,
               
               count(a.passport) as add_vip,
               sum(case
                     when b.passport is NOT NULL then
                      1
                     else
                      0
                   end) as vip_left_7th
          from (select passport
                  from bitask.t_dw_vip_vipinfo
                  where rank >= 3
                     
                   and logtime = to_date(sysdate - 183)
               
                minus
                select passport
                  from bitask.t_dw_vip_vipinfo
                  where rank >= 3
                   and logtime = to_date(sysdate - 190)) a
          left join (select t.logtime, t.passport
                      from bitask.t_dw_vip_vipinfo t
                     where t.rank >= 3
                         
                       and t.logtime = to_date(sysdate - 3)) b
            on a.passport = b.passport)

select datetime as 时间,
       ADD_VIP AS 新增VIP,
       vip_left_7th as vip留存,
       round(vip_left_7th / ADD_VIP * 100, 2) as 留存百分比
  from (select to_date(sysdate - 183) as datetime,
               
               count(a.passport) as add_vip,
               sum(case
                     when b.passport is NOT NULL then
                      1
                     else
                      0
                   end) as vip_left_7th
          from (select passport
                  from bitask.t_dw_vip_vipinfo
                  where rank >= 1
                     
                   and logtime = to_date(sysdate - 183)
               
                minus
                select passport
                  from bitask.t_dw_vip_vipinfo
                  where rank >= 1
                   and logtime = to_date(sysdate - 190)) a
          left join (select t.logtime, t.passport
                      from bitask.t_dw_vip_vipinfo t
                     where t.rank >= 1
                         
                       and t.logtime = to_date(sysdate - 3)) b
            on a.passport = b.passport)
