BEGIN
  FOR i in 1 .. 16 LOOP
    insert into VIP3_ZHIBIAO_0810
      select trunc(last_day(add_months(sysdate, -i))),
             count(a.passport),
             sum(case
                   when a.passport is NULL and b.passport is not null then
                    1
                   else
                    0
                 end),
             sum(case
                   when b.passport is NULL and a.passport is not null then
                    1
                   else
                    0
                 end)
        from (select t.logtime, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 3
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        full join (select t.logtime, t.passport
                     from bitask.t_dw_vip_vipinfo t
                    where t.rank >= 3
                      and t.logtime =
                          to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport;
  END LOOP;
  commit;
END;

BEGIN
  FOR i in 1 .. 16 LOOP
    insert into VIP3_ZHIBIAO_0810_2
      select trunc(last_day(add_months(sysdate, -i))),
             -- count(a.passport),
             sum(case
                   when a.passport is not NULL then
                    1
                   else
                    0
                 end)
      /* sum(case
        when b.passport is NULL and a.passport is not null then
         1
        else
         0
      end) */
        from (select t.logtime, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 1
                 and t.rank < 3
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        join (select t.logtime, t.passport
                from bitask.t_dw_vip_vipinfo t
               where t.rank >= 3
                 and t.logtime =
                     to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport
       GROUP BY trunc(last_day(add_months(sysdate, -i)));
  END LOOP;
  commit;
END;

select a.moth as 月份,
       vip_num as 白金vip数量,
       vip_add as 新增白金vip,
       vip_lost as 流失白金vip,
       vip_lost2 as 流失保级量
  from VIP3_ZHIBIAO_0810 a
  join VIP3_ZHIBIAO_0810_2 b
    on a.moth = b.moth
 order by 1 asc
