select month �·�,vip_num as vip������vip_pay as ����������vip_logact ��Ծ������vip_loglos ��ʧ����,vip_add ����vip,vip_lost ��½��ʧ����
from 
(select month ,
       sum(case when rank = 1 then 1 else 0 end) as vip_num,
       sum(case when pay_month >= 1 then 1 else 0 end) as vip_pay,
       sum(case when log_cnt >= 1 then 1 else 0 end) as vip_logact,
       sum(case when log_cnt is null then 1 else 0 end) as vip_loglos,
       sum(case when rank = 1 and rank_lm is null then 1 else 0 end) as vip_add,
       sum(case when rank = 0 and rank_lm = 1 then 1 else 0 end��as vip_lost
       
       from vip_moth_report1230_new 
       where month >= 1601
       group by month      
       
 )
 order by month 
 
