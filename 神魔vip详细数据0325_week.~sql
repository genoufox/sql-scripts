select b.game_ab 项目代码,
       a.game_au 项目编号,
       a.userid 账号id,
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
          '流失'
       end as 会员级别,
       a.truename 姓名,
       a.mobilephone 手机,
       a.email 邮箱,
       trunc(a.starttime) 会员开始时间,
       trunc(a.endtime) 会员结结束时间,
       d.pay30 "30天内充值",
       c.pay7 "7日充值",
       a.vamount "90天内充值",
       f.login_cnt_7 "近7天登陆次数",
       g.login_cnt_30 "近30天登陆次数",
       h.consumption_7 as "近7天消费",
       TRUNC(l.first_logout_time) 最早登陆,
       TRUNC(l.last_logout_time) 最后登录,
       trunc(f.login_time_7, 1) as "近7天登陆时长"

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 11) a

  join vip_focus0321 b
    on a.passport = b.passport

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 7
                and game_id != 4004
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id != 4004
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    count(logtime) as login_cnt_7,
                    sum(onlinetime) / 3600 as login_time_7
               from BITASK.t_dw_sm_account_stat_day
              where logtime >= trunc(sysdate) - 7
              group by userid) f
    on a.userid = f.userid

  left join (select userid, count(logtime) as login_cnt_30
               from BITASK.t_dw_sm_account_stat_day
              where logtime >= trunc(sysdate) - 30
              group by userid) g
    on a.userid = g.userid

  left join (select userid, sum(cash_need) as consumption_7
               from bitask.t_dw_sm_glog_shoptrade
              where logtime >= trunc(sysdate) - 7
              group by userid) h
    on a.userid = h.userid

  left join bitask.t_dw_sm_account_status l
    on a.userid = l.userid
