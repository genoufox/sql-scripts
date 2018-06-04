select month      月份,
       vip_num    as vip数量,
       vip_pay    as 付费数量,
       pay_total  付费总额,
       vip_logact 活跃人数,
       vip_loglos 不活跃人数,
       vip_add    新增vip,
       vip_return 回流VIP,
       vip_lost   流失VIP
  from (select month,
               sum(case
                     when rank = 2 then
                      1
                     else
                      0
                   end) as vip_num,
               sum(case
                     when pay_month >= 1 and rank = 2 then
                      1
                     else
                      0
                   end) as vip_pay,
               sum(case
                     when pay_month >= 1 and rank = 2 then
                      pay_month
                     else
                      0
                   end) as pay_total,
               sum(case
                     when log_cnt >= 1 and rank = 2 then
                      1
                     else
                      0
                   end) as vip_logact,
               sum(case
                     when log_cnt is null and rank = 2 then
                      1
                     else
                      0
                   end) as vip_loglos,
               sum(case
                     when rank = 2 and rank_lm is null then
                      1
                     else
                      0
                   end) as vip_add,
               sum(case
                     when rank = 2 and rank_lm < 2 then
                      1
                     else
                      0
                   end) as vip_return,
               sum(case
                     when rank < 2 and rank_lm = 2 then
                      1
                     else
                      0
                   end) as vip_lost
        
          from vip_moth_report1230_new
         where month >= 1601
         group by month
        
        )
 order by month
