select flag,
       count(userid） as VIP数量, sum(case
         when rank2015 > 0 then
          1
         else
          0
       end) as vip留存人数,
       
       sum(case
         when pay2015 > 0 then
          1
         else
          0
       end) as vip付费人数,
       
       trunc(sum(pay2015)) as 付费总额
       
       from vip_pay2015 group by flag order by flag desc
