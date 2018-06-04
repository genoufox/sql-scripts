insert into  TOTAL_VIP0318

select b.game_ab,
       a.game_au,
       a.userid,
       a.passport,
       a.rank,
       a.truename,
       a.mobilephone,
       a.code,
       a.email,
       a.starttime,
       a.endtime,
       a.tamount,
       a.vamount,
       c.pay7,
       d.pay90,
       e.pay2016,
       f.login_cnt_7,
       g.login_cnt_30,     
       h.consumption_7,
       i.lev,
       i.roleid,
       i.rolename,
       j.alias,
       k.f_city_name,
       TRUNC(l.first_logout_time) as first_logout,
       TRUNC(l.last_logout_time) as last_logout

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

  join (select distinct bi_aid, game_ab, game_name from mapping_dy) b
    on a.game_au = b.bi_aid

  left join (select userid, game_id, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 7
                and game_id != 4004
              group by userid, game_id) c
    on a.userid = c.userid
   and a.game_au = c.game_id

  left join (select userid, game_id,sum(money) / 100 as pay90
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 90
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

  left join (select userid, count(logtime) as login_cnt_7
               from BITASK.t_dw_sg_account_stat_day
              where logtime >= sysdate - 7
              group by userid) f
    on a.userid = f.userid

  left join (select userid, count(logtime) as login_cnt_30
               from BITASK.t_dw_sg_account_stat_day
              where logtime >= sysdate - 30
              group by userid) g
    on a.userid = g.userid

  left join (select userid, sum(cash_need) / 100 as consumption_7
               from bitask.t_dw_sg_glog_shoptrade
              where  logtime >= sysdate - 7
              group by userid) h
              on a.userid = h.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sg_gdb_chardata
              where userid > 33
                and logtime = to_char(sysdate - 2)) i
    on a.userid = i.userid
   and i.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_sg_dic_serverlist) j
    on i.groupname = j.groupname
   and j.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_sg_glog_accountlogout
                              where logtime >= to_char£¨sysdate - 30£©) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) k
    on a.userid = k.userid
   and k.rn = 1

  left join bitask.t_dw_sg_account_status l
    on a.userid = l.userid
    
 where b.game_ab = 'sg'
