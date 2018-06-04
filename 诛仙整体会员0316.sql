insert into vip_total0314
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
                                 a.starttime,
                                 a.endtime,
                                 c.pay7,
                                 d.pay90,
                                 e.pay2015,
                                 f.login_cnt,
                                 g.lev,
                                 g.roleid,
                                 g.rolename,
                                 h.name,
                                 h.alias,
                                 i.f_city_name,
                                 TRUNC(j.first_logout_time) as first_logout,
                                 TRUNC(j.last_logout_time) as last_logout
                          
                            from (select game_au,
                                         userid,
                                         passport,
                                         rank,
                                         truename,
                                         mobilephone,
                                         code,
                                         email,
                                         tamount,
                                         vamount,
                                         starttime,
                                         endtime
                                    from bitask.t_dw_vip_vipinfo
                                   where logtime = to_char£¨sysdate - 2£©
                                     and rank >= 1) a
                          
                            join (select distinct bi_aid, game_ab, game_name
                                    from mapping_dy) b
                              on a.game_au = b.bi_aid
                          
                            left join (select userid,
                                              sum(money) / 100 as pay7
                                         from bitask.t_dw_au_billlog
                                        where userid > 33
                                          and logtime >= sysdate - 7
                                          and game_id != 4004
                                        group by userid) c
                              on a.userid = c.userid
                          
                            left join (select userid,
                                              sum(money) / 100 as pay90
                                         from bitask.t_dw_au_billlog
                                        where userid > 33
                                          and logtime >= sysdate - 90
                                          and game_id != 4004
                                        group by userid) d
                              on a.userid = d.userid
                          
                            left join (select userid,
                                              sum(money) / 100 as pay2015
                                         from bitask.t_dw_au_billlog
                                        where userid > 33
                                          and logtime <
                                              to_date('20160101', 'yyyymmdd')
                                          and logtime >=
                                              to_date('20150101', 'yyyymmdd')
                                          and game_id != 4004
                                        group by userid) e
                              on a.userid = e.userid
                          
                            left join (select userid,
                                              count(logtime) as login_cnt
                                         from BITASK.t_dw_zx_account_stat_day
                                        where logtime >= sysdate - 30
                                        group by userid) f
                              on a.userid = f.userid
                          
                            left join (select userid,
                                              roleid,
                                              name rolename,
                                              type* 150+lev lev,
                                              groupname,
                                              row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                                         from bitask.t_dw_zx_gdb_chardata
                                        where userid > 33
                                          and logtime = to_char(sysdate - 2)) g
                              on a.userid = g.userid
                             and g.rolelev_rank = 1
                          
                            left join (select groupname,
                                              name,
                                              alias,
                                              row_number() over(partition by groupname order by version desc) as rn
                                         from bitask.t_dw_zx_dic_serverlist) h
                              on g.groupname = h.groupname
                             and h.rn = 1
                          
                            left join (select c.userid,
                                              c.f_city_name,
                                              c.cnt,
                                              row_number() over(partition by c.userid order by c.cnt desc) as rn
                                         from (select a.userid,
                                                      b.f_city_name,
                                                      count(*) as cnt
                                                 from (select userid, ip_num
                                                         from bitask.t_dw_zx_glog_accountlogout
                                                        where logtime >=
                                                              to_char£¨sysdate - 30£©) a,
                                                      bitask.t_dic_ipseg_int_db b
                                                where a.ip_num between
                                                      b.f_bip and b.f_eip
                                                  and b.f_floor =
                                                      trunc(a.ip_num / 65536,
                                                            0)
                                                group by a.userid,
                                                         f_city_name) c) i
                              on a.userid = i.userid
                             and i.rn = 1
                          
                            left join bitask.t_dw_zx_account_status j
                              on a.userid = j.userid
                           where b.game_ab = 'zx'
