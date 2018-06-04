select a.game_au as 游戏编号,
       b.game_ab as 游戏代码,
       b.game_name as 游戏名称,
       case a.rank
         when 1 then
          '银卡'
         when 2 then
          '金卡'
         when 3 then
          '白金'
         when 4 then
          '终身'
         else
          null
       end as VIP级别,
       a.vip_num as 会员数量
  from (select game_au, rank, count(distinct passport) as vip_num
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date(sysdate - 2)
           and rank >= 1
         group by rollup(game_au, rank)) a
  left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
 order by a.game_au, rank
