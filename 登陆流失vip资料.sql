 
                                 insert into viplost_fyp0309
                                 select b.game_ab,
                                 a.game_au,
                                 a.userid,
                                 a.passport,
                                 a.rank,
                                 a.truename,
                                 a.mobilephone,
                                 a.code,
                                 a.email,
                                 a.tamount,
                                 a.vamount,
                                 c.pay_2015,
                                 d.login_cnt,
                                 e.lev,
                                 e.roleid,
                                 e.name as rolename,
                                 f.name,
                                 f.alias,
                                 TRUNC(g.first_logout_time) as first_logout,
                                 TRUNC(g.last_logout_time) as last_logout
                                 
                                 from (select game_au,
                                 userid,
                                 passport,
                                 rank,
                                 truename,
                                 mobilephone,
                                 code,
                                 email,
                                 tamount,
                                 vamount
                                 from bitask.t_dw_vip_vipinfo
                                 where logtime = to_char£¨sysdate - 2£©
                                 ) a
                                 
                                 join (select distinct bi_aid, game_ab, game_name from mapping_dy) b
                                 on a.game_au = b.bi_aid
                                 
                                 left join (select userid, sum(money) / 100 as pay_2015
                                 from bitask.t_dw_au_billlog
                                 where userid > 33
                                 and logtime < to_date('20160101', 'yyyymmdd')
                                 and logtime >= to_date('20150101', 'yyyymmdd')
                                 and game_id != 4004
                                 group by userid) c
                                 on a.userid = c.userid
                                 
                                 left join (select userid, count(logtime) as login_cnt
                                 from BITASK.t_dw_",var_game,"_account_stat_day
                                 where logtime >= sysdate - 365
                                 group by userid) d
                                 on a.userid = d.userid
                                 
                                 left join (select userid,
                                 roleid,
                                 name,
                                 lev,
                                 groupname,
                                 row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                                 from bitask.t_dw_",var_game,"_gdb_chardata
                                 where userid > 33
                                 and logtime = to_char(sysdate - 2)) e
                                 on a.userid = e.userid
                                 and e.rolelev_rank = 1
                                 
                                 left join (select groupname,
                                 name,
                                 alias,
                                 row_number() over(partition by groupname order by version desc) as rn
                                 from bitask.t_dw_",var_game,"_dic_serverlist) f
                                 on e.groupname = f.groupname
                                 and f.rn = 1                                 
                                 
                                 left join bitask.t_dw_",var_game,"_account_status g
                                 on a.userid = g.userid
                                 where b.game_ab = '",var_game,"'
                                 and  g.last_logout_time < to_date('20160101','yyyymmdd')
