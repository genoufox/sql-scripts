select a.GAME_AB   ��Ϸ��Ŀ,
       a.MONTH     as �·�,
       case a.rank
       when 1 then '����'
       when 2 then '�ƽ�'
       when 3 then '�׽�'
       when 4 then '����'
       else null
       end
       as  ��Ա����,
       a.�˺�����,
       a.�¶ȳ�ֵ,
       a.�¶�����,
       b.VIP_ADDED �¶�����,
       B.VIP_LOST  �¶���ʧ,
       trunc(B.VIP_LOST/a.�˺�����*100,1) as "����ʧ�ʣ�%��"
  FROM (select game_ab,
               TRUNC(time) AS MONTH,
               rank,
               count(userid) as �˺�����,
               nvl(trunc(sum(pay_month)), 0) as �¶ȳ�ֵ,
               nvl(trunc(sum(consume)), 0) as �¶�����
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
