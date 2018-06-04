select last_day(add_months(sysdate, -i))  as time,
       a.game_au,
       b.game_au as game_au_1m,
       a.userid,
       b.userid as userid_1m,
       a.passport,
       a.rank,
       b.rank as rank_1m,
       a.code,
       a.mobilephone,
       a.telephone,
       c.game_ab,
       d.pay7,
       e.pay30,
       f.login_cnt,
       f.top_lev,
       f.onlinetime,
       last_day(add_months(sysdate, -i)) - trunc(f.last_login) as nologin_days

  from (select t.game_au,
               t.userid,
               t.passport,
               t.rank,
               t.code,
               t.mobilephone,
               t.telephone
          from bitask.t_dw_vip_vipinfo t
         where t.logtime = last_day(add_months(sysdate, -i))
           ) a

  left join (select t.game_au, t.userid, t.passport, t.rank
               from bitask.t_dw_vip_vipinfo t
              where t.logtime = last_day(add_months(sysdate, - (i + 1))
                ) b
    on a.userid = b.userid
   and a.game_au = b.game_au

  join (select distinct bi_aid, game_name, game_ab from mapping_dy) c
    on a.game_au = c.bi_aid


  left join (select userid, game_id, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where logtime >= last_day(add_months(sysdate, - (i + 1))
                and logtime < last_day(add_months(sysdate, -i)
              group by userid, game_id) e
    on a.userid = e.userid
   and a.game_au = e.game_id

  left join (select userid,
                    max(logtime) as last_login,
                    max(nvl(type, 0) * 150 + top_level) as top_lev,
                    trunc(sum(onlinetime) / 3600, 2) as onlinetime
               from BITASK.t_dw_",var_game,"_gdb_cashstat
              where logtime < last_day(add_months(sysdate, -i))
                and logtime >= last_day(add_months(sysdate, - (i + 1))
              group by userid) f
    on a.userid = f.userid
