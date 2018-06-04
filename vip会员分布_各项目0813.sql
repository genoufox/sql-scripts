select a.game_au as ��Ϸ���,
       b.game_ab as ��Ϸ����,
       b.game_name as ��Ϸ����,
       case a.rank
         when 1 then
          '����'
         when 2 then
          '��'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          null
       end as VIP����,
       a.vip_num as ��Ա����
  from (select game_au, rank, count(distinct passport) as vip_num
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date(sysdate - 2)
           and rank >= 1
         group by rollup(game_au, rank)) a
  left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
 order by a.game_au, rank
