select t.game_au,
       a.*,
       b.pay7 充值金额,
       c.login_cnt_7 登陆次数,
       trunc(c.login_time_7, 1) 登陆时间,
       d.last_logout_time 最后登录,
       e.lev 角色最高级别,
       e.zoneid 最高角色服务器id,
       e.name 最高角色服务器名称,
       f.pay7_n 新服充值,
       g.lev 新服等级

  from SDS_5W0526 a

  left join (select game_au, userid /*,
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
                                                           endtime */
               from bitask.t_dw_vip_vipinfo
              where logtime = to_char（trunc(sysdate) - 2）) t
    on a.userid = t.userid

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160513', 'yyyymmdd')
                and logtime < to_date('20160513', 'yyyymmdd') + 7
                and game_id = 17
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    count(logtime) as login_cnt_7,
                    sum(onlinetime) / 3600 as login_time_7
               from BITASK.t_dw_sds_account_stat_day
              where logtime >= to_date('20160513', 'yyyymmdd')
                and logtime < to_date('20160513', 'yyyymmdd') + 7
              group by userid) c
    on a.userid = c.userid

  left join bitask.t_dw_sds_account_status d
    on a.userid = d.userid

  left join (select a.userid, lev, a.groupname, b.name, b.zoneid, b.alias
               from (select userid,
                            -- roleid,
                            -- rolename,
                            lev,
                            groupname,
                            row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                       from bitask.t_dw_sds_gdb_chardata
                      where userid > 33
                        and logtime = to_char(trunc(sysdate) - 2)) a
             
               left join (select groupname,
                                name,
                                alias,
                                zoneid,
                                row_number() over(partition by groupname order by version desc) as rn
                           from bitask.t_dw_sds_dic_serverlist) b
                 on a.groupname = b.groupname
              where a.rolelev_rank = 1
                and b.rn = 1
             
             ) e
    on a.userid = e.userid

  left join (select userid, sum(money) / 100 as pay7_n
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160513', 'yyyymmdd')
                and logtime < to_date('20160513', 'yyyymmdd') + 7
                and game_id = 17
                and zoneid = 2873
              group by userid) f
    on a.userid = f.userid

  left join (select a.userid, lev, a.groupname, b.zoneid, b.alias
               from (select userid,
                            -- roleid,
                            --  rolename,
                            lev,
                            groupname,
                            row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                       from bitask.t_dw_sds_gdb_chardata
                      where userid > 33
                        and logtime = to_char(trunc(sysdate) - 2)) a
             
               left join (select groupname,
                                name,
                                alias,
                                zoneid,
                                row_number() over(partition by groupname order by version desc) as rn
                           from bitask.t_dw_sds_dic_serverlist) b
                 on a.groupname = b.groupname
              where a.rolelev_rank = 1
                and b.rn = 1) g
    on a.userid = g.userid
   and g.zoneid = 2873
