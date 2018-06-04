begin 
                                 for i in 17 .. 32 loop
                                 insert into vip_status0919      
                                 select last_day(add_months(sysdate, -i))  as time,
                                 b.game_ab,
                                 a.game_au,
                                 c.game_au as game_au_1m,
                                 a.userid,
                                 c.userid as userid_1m,
                                 a.passport,
                                 a.rank,
                                 c.rank as rank_1m,
                                 d.pay_month,
                                 e.consume
                                 
                                 from (select t.game_au,
                                 t.userid,
                                 t.passport,
                                 t.rank
                                 from bitask.t_dw_vip_vipinfo @racdb t
                                 where t.logtime = trunc(last_day(add_months(sysdate, -i)) )         
                                 ) a
                                 
                                 join (select distinct bi_aid, game_name, game_ab from mapping_dy) b
                                 on a.game_au = b.bi_aid
                                 
                                 left join (select t.game_au, t.userid, t.passport, t.rank
                                 from bitask.t_dw_vip_vipinfo  @racdb  t
                                 where t.logtime = trunc(last_day(add_months(sysdate, - (i + 1))))
                                 ) c
                                 on a.userid = c.userid
                                 and a.game_au = c.game_au
                                 
                                 left join (select userid, game_id, sum(money) / 100 as pay_month
                                 from bitask.t_dw_au_billlog  @racdb
                                 where logtime > last_day(add_months(sysdate, - (i + 1)))
                                 and logtime <= last_day(add_months(sysdate, -i))
                                 group by userid, game_id) d
                                 on a.userid = d.userid
                                 and a.game_au = d.game_id
                                 
                                 left join (select userid,
                                 sum(cash_used) /100 as consume
                                 from BITASK.t_dw_xa_glog_shoptrade  @racdb
                                 where logtime <= last_day(add_months(sysdate, -i))
                                 and logtime > last_day(add_months(sysdate, - (i + 1)))
                                 group by userid) e
                                 on a.userid = e.userid
                                 where b.game_ab = 'xa'; 
                                 end loop;
                                 commit;
                                 end;
