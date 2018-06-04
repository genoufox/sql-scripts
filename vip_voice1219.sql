create table vip_voice1219
as
select userid, count(userid) as call_cnt, max(vip_rank)as vip_rank,max(create_date) as call_last 
  from (select t.*
          from VIOCE_VIP1218_1 t
        -- where t.vip_rank > 0
        union all
        select t.*
          from VIOCE_VIP1218_2 t
        -- where vip_rank > 0
        union all
        select t.*
          from VIOCE_VIP1218_3 t
        -- where vip_rank > 0
        )
 group by userid
