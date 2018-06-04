select datetime as ʱ��,
       ADD_VIP AS �����׽�VIP,
       vip_left_7th as �׽�vip����,
       round(vip_left_7th / ADD_VIP * 100, 2) as ����ٷֱ�
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

select datetime as ʱ��,
       ADD_VIP AS ����VIP,
       vip_left_7th as vip����,
       round(vip_left_7th / ADD_VIP * 100, 2) as ����ٷֱ�
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
