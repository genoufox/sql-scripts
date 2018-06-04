select MOTH as 月份,
       ADD_VIP AS 新增白金VIP,
       vip_left_7th as 白金vip留存,
       round(vip_left_7th / ADD_VIP * 100, 2) as 留存百分比
  from （
        select to_date('20150123', 'yyyymmdd') as MOTH,
               
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
                      
                   and logtime = to_date('20150123', 'yyyymmdd')
                
                minus
                select passport
                  from bitask.t_dw_vip_vipinfo
                 where rank >= 3
                      
                   and logtime = to_date('20150117', 'yyyymmdd')) a
          left join (select t.logtime, t.passport
                       from bitask.t_dw_vip_vipinfo t
                      where t.rank >= 3
                           
                        and t.logtime = to_date('20150723', 'yyyymmdd')) b
            on a.passport = b.passport
        union
        select to_date('20150116', 'yyyymmdd') as MOTH,
               
               count(a.passport) as add_VIP,
               sum(case
                     when b.passport is NOT NULL then
                      1
                     else
                      0
                   end) as vip_left_7th
          from (select passport
                  from bitask.t_dw_vip_vipinfo
                 where rank >= 3
                      
                   and logtime = to_date('20150116', 'yyyymmdd')
                
                minus
                select passport
                  from bitask.t_dw_vip_vipinfo
                 where rank >= 3
                      
                   and logtime = to_date('20150110', 'yyyymmdd')) a
          left join (select t.logtime, t.passport
                       from bitask.t_dw_vip_vipinfo t
                      where t.rank >= 3
                           
                        and t.logtime = to_date('20150716', 'yyyymmdd')) b
            on a.passport = b.passport
        
        union
        select to_date('20150109', 'yyyymmdd') as MOTH,
               
               count(a.passport) as add_VIP,
               sum(case
                     when b.passport is NOT NULL then
                      1
                     else
                      0
                   end) as vip_left_7th
          from (select passport
                  from bitask.t_dw_vip_vipinfo
                 where rank >= 3
                      
                   and logtime = to_date('20150109', 'yyyymmdd')
                
                minus
                select passport
                  from bitask.t_dw_vip_vipinfo
                 where rank >= 3
                      
                   and logtime = to_date('20150101', 'yyyymmdd')) a
          left join (select t.logtime, t.passport
                       from bitask.t_dw_vip_vipinfo t
                      where t.rank >= 3
                           
                        and t.logtime = to_date('20150709', 'yyyymmdd')) b
            on a.passport = b.passport ）
         order by 1
