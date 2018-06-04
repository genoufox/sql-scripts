BEGIN
  FOR i in 1 .. 16 LOOP
    insert into VIP_ZHIBIAO_0810
      select last_day(add_months(sysdate, -i)),
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
               where t.rank > = 1
                 and t.logtime = to_char(last_day(add_months(sysdate, -i)))) a
        full join (select t.logtime, t.passport
                     from bitask.t_dw_vip_vipinfo t
                    where t.rank >= 1
                      and t.logtime =
                          to_char(last_day(add_months(sysdate, - (i + 1))))) b
          on a.passport = b.passport;
  END LOOP;
  commit;
END;
