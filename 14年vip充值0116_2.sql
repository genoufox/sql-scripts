select flag,
       count(userid�� as VIP����, sum(case
         when rank2015 > 0 then
          1
         else
          0
       end) as vip��������,
       
       sum(case
         when pay2015 > 0 then
          1
         else
          0
       end) as vip��������,
       
       trunc(sum(pay2015)) as �����ܶ�
       
       from vip_pay2015 group by flag order by flag desc
