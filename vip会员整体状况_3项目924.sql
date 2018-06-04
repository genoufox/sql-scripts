 select TRUNC(sysdate, 'MM') + 14 as time,
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
        f.top_lev_roleid,
        f.onlinetime,
        trunc(sysdate, 'MM') + 14 - trunc(f.last_login) as nologin_days
 
   from (select t.game_au,
                t.userid,
                t.passport,
                t.rank,
                t.code,
                t.mobilephone,
                t.telephone
           from bitask.t_dw_vip_vipinfo t
          where t.logtime = TRUNC(sysdate, 'MM') + 14
            AND t.game_au in (3, 4, 15)) a
 
   left join (select t.game_au, t.userid, t.passport, t.rank
                from bitask.t_dw_vip_vipinfo t
               where t.logtime = TRUNC(sysdate, 'MM') - 15
                 AND t.game_au in (3, 4, 15)) b
     on a.userid = b.userid
    and a.game_au = b.game_au
 
   join (select distinct bi_aid, game_name, game_ab from mapping_dy) c
     on a.game_au = c.bi_aid
 
   left join (select userid, game_id, sum(money) / 100 as pay7
                from bitask.t_dw_au_billlog
               where logtime >= TRUNC(sysdate, 'MM') + 7
                 and logtime < TRUNC(sysdate, 'MM') + 14
               group by userid, game_id) d
     on a.userid = d.userid
    and a.game_au = d.game_id
 
   left join (select userid, game_id, sum(money) / 100 as pay30
                from bitask.t_dw_au_billlog
               where logtime >= TRUNC(sysdate, 'MM') - 16
                 and logtime < TRUNC(sysdate, 'MM') + 14
               group by userid, game_id) e
     on a.userid = e.userid
    and a.game_au = e.game_id
 
   left join (select userid,
                     count(logtime) as login_cnt,
                     max(logtime) as last_login,
                     max(nvl(type, 0) * 150 + top_level) as top_lev,
                     trunc(sum(onlinetime) / 3600, 2) as onlinetime
                from BITASK.t_dw_xa_account_stat_day
               where logtime < TRUNC(sysdate, 'MM') + 14
                 and logtime >= TRUNC(sysdate, 'MM') - 15
               group by userid, top_lev_roleid) f
     on a.userid = f.userid
