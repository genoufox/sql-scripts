create table vip1_LOST_sz0813
(
moth   date ,
game_au  number,
vip_num  number,
vip_LOST  number

）

create table vip3_LOST_sz0813
(
moth   date ,
game_au  number,
vip_num  number,
vip_LOST  number

）


BEGIN
  FOR i in 1 .. 16 LOOP
    insert into vip1_lost_sz0813
      select trunc(last_day(add_months(sysdate, -i))),
             b.game_au,
             count(a.passport),
             sum(case
                   when a.passport is  null and b.passport is NOT NULL then
                    1
                   else
                    0
                 end)
        from (select t.logtime, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 1
                 and t.game_au is not null
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        RIGHT JOIN (select t.logtime, t.game_au, t.passport
                     from bitask.t_dw_vip_vipinfo t
                    where t.rank >= 1
                      and t.logtime =
                          to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport
       group by B.game_au;
  END LOOP;
  commit;
END;

select a.moth as 月份,b.game_name as 游戏名称,vip_num as vip会员数量,vip_LOST as VIP会员流失 from vip1_lost_sz0813 a
left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
where game_name is Not null
order by 1,3 desc

select moth,sum(vip_num),sum(vip_add) from vip3_add_sz0813
group by moth
order by 1


select a.moth as 月份,b.game_name as 游戏名称,vip_LOST as 白金会员流失 from vip3_lost_sz0813 a
left join (select distinct bi_aid, game_ab, game_name
               from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid
where game_name is Not null
order by 1,3 desc
