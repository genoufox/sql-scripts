create table vip1_add_sz0813
(
moth   date ,
game_au  number,
vip_num  number,
vip_add  number

）



BEGIN
  FOR i in 1 .. 16 LOOP
    insert into vip1_add_sz0813
      select trunc(last_day(add_months(sysdate, -i))),
             game_au,
             count(a.passport),
             sum(case
                   when a.passport is not null and b.passport is NULL then
                    1
                   else
                    0
                 end)
        from (select t.logtime, t.game_au, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 1
                 and t.game_au is not null
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        full join (select t.logtime, t.game_au, t.passport
                     from bitask.t_dw_vip_vipinfo t
                    where t.rank >= 1
                      and t.logtime =
                          to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport
       group by game_au;
  END LOOP;
  commit;
END;

BEGIN
  FOR i in 1 .. 16 LOOP
    insert into vip3_add_sz0813
      select trunc(last_day(add_months(sysdate, -i))),
             a.game_au,
             count(a.passport),
             sum(case
                   when a.passport is not null and b.passport is NULL then
                    1
                   else
                    0
                 end)
        from (select t.logtime, t.game_au, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 3
                 and t.game_au is not null
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        full join (select t.logtime, t.game_au, t.passport
                     from bitask.t_dw_vip_vipinfo t
                    where t.rank >= 3
                      and t.logtime =
                          to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport
      GROUP BY trunc(last_day(add_months(sysdate, -i))), a.game_au;
  END LOOP;
  commit;
END;

select a.moth as 月份,b.game_name as 游戏名称,vip_num as vip会员数量,vip_add as VIP会员增加 from vip1_add_sz0813 a
left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
order by 1,3 desc


select a.moth as 月份,b.game_name as 游戏名称,vip_num as 白金会员数量,vip_add as 白金会员增加 from vip3_add_sz0813 a
left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
order by 1,3 desc

select a.moth as 月份,b.game_name as 游戏名称,a.vip_num as vip会员数量,vip_add as VIP会员增加,vip_lost as VIP会员流失 from vip3_add_sz0813 a
left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
left join vip3_lost_sz0813 c
on a.moth =c.moth 
and a.game_au = c.game_au
where a.game_au is not null
order by 1,3 desc
