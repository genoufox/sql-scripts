select month      �·�,
       vip_num    as vip����,
       vip_pay    as ��������,
       pay_total  �����ܶ�,
       vip_logact ��Ծ����,
       vip_loglos ����Ծ����,
       vip_add    ����vip,
       vip_return ����VIP,
       vip_lost   ��ʧVIP
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
