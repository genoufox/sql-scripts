select 'na' as game_ab,
       a.game_au,
       a.userid,
       a.passport,
       a.rank,
       a.truename,
       a.mobilephone,
       a.code,
       a.email,
       trunc(a.starttime) starttime,
       trunc(a.endtime) endtime,
       a.tamount,
       a.vamount,
       a.samount,
      -- c.pay7,
      -- d.pay30,
      -- e.pay2016,
      -- f.pay2015,
       g.login_cnt_7,      
       h.login_cnt_30,  
       i.consumption_7,    
     --  j.lev,
     --  j.roleid,
     --  j.rolename,
     --  k.alias,
     --  l.f_city_name,
       TRUNC(m.first_logout_time) as first_logout,
       TRUNC(m.last_logout_time) as last_logout,      
        g.login_time_7

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
               samount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and passport = '13552298888') a

--  join (select distinct bi_aid, game_ab, game_name from mapping_dy) b
--    on a.game_au = b.bi_aid

  left join (select userid, game_id, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 7
                and game_id != 4004
              group by userid, game_id) c
    on a.userid = c.userid
   and a.game_au = c.game_id

  left join (select userid, game_id, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 30
                and game_id != 4004
              group by userid, game_id) d
    on a.userid = d.userid
   and a.game_au = d.game_id

  left join (select userid, sum(money) / 100 as pay2016
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160101', 'yyyymmdd')
                and game_id != 4004
              group by userid, game_id) e
    on a.userid = e.userid

  left join (select userid, sum(money) / 100 as pay2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20150101', 'yyyymmdd')
                and logtime < to_date('20160101', 'yyyymmdd')
                and game_id != 4004
              group by userid, game_id) f
    on a.userid = f.userid

  left join (select userid,
                    count(logtime) as login_cnt_7,
                    sum(onlinetime) / 3600 as login_time_7
               from BITASK.t_dw_wl_account_stat_day
              where logtime >= sysdate - 7
              group by userid) g
    on a.userid = g.userid

  left join (select userid, count(logtime) as login_cnt_30
               from BITASK.t_dw_wl_account_stat_day
              where logtime >= sysdate - 30
              group by userid) h
    on a.userid = h.userid

  left join (select userid, sum(cash_need) as consumption_7
               from bitask.t_dw_wl_glog_shoptrade
              where logtime >= sysdate - 7
              group by userid) i
    on a.userid = i.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    100 * type + lev as lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_char(sysdate - 2)) j
    on a.userid = j.userid
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_wl_glog_accountlogout
                              where logtime >= to_char��sysdate - 30��) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) l
    on a.userid = l.userid
   and l.rn = 1

  left join bitask.t_dw_wl_account_status m
    on a.userid = m.userid

-- where b.game_ab = 'wl'
