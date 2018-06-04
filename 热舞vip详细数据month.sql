select 'rw' 项目,
       a.game_au 项目ID,
       a.userid 账号ID,
       a.passport 账号,
       case a.rank
         when 1 then
          '银卡'
         when 2 then
          '金卡'
         when 3 then
          '白金'
         when 4 then
          '终身'
         else
          '流失VIP'
       end as 会员级别,
       a.truename 姓名,
       a.mobilephone 电话,
       a.code 身份证,
       a.email 邮箱,
       trunc(a.starttime) 会员开始时间,
       trunc(a.endtime) 会员结束时间,
       a.tamount 累计充值,
       a.samount 服务期充值,
       a.vamount 近3月充值,
       c.pay7 近7天充值,
       d.pay_lm 月充值,
       e.pay2016 今年充值,
       f.pay2015 去年充值,
       g.login_cnt_7 近7天充值,
       h.login_cnt_lm 月登陆次数,
       h.consumption_7 "近7天消费(元宝)",
       j.lev 角色等级,
       j.roleid 角色ID,
       j.rolename 角色名称,
       k.alias 角色服务器,
       l.f_city_name 登陆城市,
       TRUNC(m.first_logout_time) as 最早登陆,
       TRUNC(m.last_logout_time) as 最迟登陆,
       g.login_time_7 近7天登陆时间

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
         where logtime = trunc(sysdate, 'MM') - 1
           and rank >= 1
           and game_au = 6
        
        ) a

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 7
                and game_id != 4004
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_lm
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 15, 'MM')
                and logtime < trunc(sysdate, 'MM')
                and game_id != 4004
              group by userid) d
    on a.userid = d.userid

  left join (select userid, sum(money) / 100 as pay2016
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160101', 'yyyymmdd')
                and game_id != 4004
              group by userid) e
    on a.userid = e.userid

  left join (select userid, sum(money) / 100 as pay2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20150101', 'yyyymmdd')
                and logtime < to_date('20160101', 'yyyymmdd')
                and game_id != 4004
              group by userid) f
    on a.userid = f.userid

  left join (select userid,
                    count(logtime) as login_cnt_7,
                    sum(onlinetime) / 3600 as login_time_7
               from BITASK.t_dw_rw_account_stat_day
              where logtime >= trunc(sysdate) - 7
              group by userid) g
    on a.userid = g.userid

  left join (select userid, count(logtime) as login_cnt_lm
               from BITASK.t_dw_rw_account_stat_day
              where logtime >= trunc(sysdate - 15, 'MM')
                and logtime < trunc(sysdate, 'MM')
              group by userid) h
    on a.userid = h.userid

  left join (select userid, sum(cash_need) as consumption_7
               from bitask.t_dw_rw_glog_shoptrade
              where logtime >= trunc(sysdate) - 7
              group by userid) h
    on a.userid = h.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_rw_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) j
    on a.userid = j.userid
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_rw_dic_serverlist) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_rw_glog_accountlogout
                              where logtime >= trunc(sysdate - 15, 'MM')
                                and logtime < trunc(sysdate, 'MM')) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) l
    on a.userid = l.userid
   and l.rn = 1

  left join bitask.t_dw_rw_account_status m
    on a.userid = m.userid


