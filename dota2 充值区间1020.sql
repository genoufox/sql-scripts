select payflag as 充值区间,
       count(userid) as 用户数,
       trunc(sum(pay)) as 充值总额,
       trunc(avg(pay)) as 充值均额
  from (select userid,
               pay,
               case
               
                 when pay >= 1000 and pay < 3000 then
                  '银卡'
                 when pay >= 3000 and pay < 15000 then
                  '金卡'
                 when pay >= 15000 then
                  '白金'
                else '准VIP'
               
               end as payflag
       
          from (select userid, sum(pwrd_unit) / 100 as pay
                  from bitask.t_dw_dota2_au_billlog
                 where logtime >= to_char(sysdate - 90)
                 group by userid)
         where pay > 0)
 group by payflag
 order by 4
