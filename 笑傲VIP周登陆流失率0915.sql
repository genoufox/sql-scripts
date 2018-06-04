create table vip_xa_login_lost0915
(week  date,
 userid number,
 last_login date 
 );


BEGIN
  FOR i in 0 .. 25 LOOP
    insert into vip_xa_login_lost0915
      select TRUNC(sysdate,'D') -i*7,
             a.userid,
             b.last_login
        from (select t.userid
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 1
                 and t.logtime = to_char(TRUNC(sysdate,'D') -i*7)
                 AND t.game_au = 15) a
        left join (select userid, max(logtime) as last_login
                     from BITASK.t_dw_xa_account_status_day
                    where logtime <
                          to_date(TRUNC(sysdate,'D') -i*7 + 1)
                      and logtime >=
                          to_date(last_day(add_months(sysdate, - (i + 1)*7)) + 1)
                    group by userid) b
          on a.userid = b.userid;
  END LOOP;
  COMMIT;
END;

select week as 周日期,
       count(userid) as VIP数量,
       sum(case
             when last_login > week - 7 then
              1
             else
              0
           end) as "7天有登陆"

  from vip_xa_login_lost0915
 group by week 
 order by week 
 
