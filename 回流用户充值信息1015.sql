select a.game_ab      游戏编号,
       a.pay_month as 充值月份,
       b.vip_num      会员数量,
       a.pay_num   as 付费数量

  from (select t.game_ab,
               t.pay_month,
               sum(case
                     when t.pay_month > 0 then
                      '1'
                     else
                      '0'
                   end) as pay_num
          from (select game_ab, userid, min(pay_date) as pay_month
                  from VIP_RETURN1014
                 where rank > 0
                 and   (game_ = pay_game_id or pay_game_id = 4004)
                 group by game_ab, userid) t
         group by rollup(t.game_ab, t.pay_month)
        
        ) a

  left join (select game_ab, count(distinct userid) as vip_num
               from VIP_RETURN1014
              where rank > 0
              group by (game_ab)
             
             ) b
    on a.game_ab = b.game_ab
    
 where a.pay_month > 0
 order by a.game_ab, a.pay_month
