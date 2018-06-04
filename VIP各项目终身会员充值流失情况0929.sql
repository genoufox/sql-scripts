select a.GAME_AB   游戏项目,
       a.MONTH     as 月份,
       case a.rank
       when 1 then '银卡'
       when 2 then '黄金'
       when 3 then '白金'
       when 4 then '终身'
       else null
       end
       as  会员级别,
       a.账号数量,
       a.月度充值,
       a.月度消费,
       b.VIP_ADDED 月度新增,
       B.VIP_LOST  月度流失,
       trunc(B.VIP_LOST/a.账号数量*100,1) as "月流失率（%）"
  FROM (select game_ab,
               TRUNC(time) AS MONTH,
               rank,
               count(userid) as 账号数量,
               nvl(trunc(sum(pay_month)), 0) as 月度充值,
               nvl(trunc(sum(consume)), 0) as 月度消费
          from vip_status0919
         where rank = 4
         group by game_ab, TRUNC(time),rank) a
  join (select game_ab,
               TRUNC(time) AS MONTH,
               sum(case
                     when rank = 4 and (rank_1m < 4  or rank_1m is null) then
                      1
                     else
                      0
                   end) as VIP_ADDED,
               sum(case
                     when rank < 4 and rank_1m = 4 then
                      1
                     else
                      0
                   end) as VIP_LOST
        
          from vip_status0919
         group by game_ab, TRUNC(time)) b
    ON A.GAME_AB = B.GAME_AB
   AND A.MONTH = B.MONTH
 ORDER BY A.MONTH, A.GAME_AB
