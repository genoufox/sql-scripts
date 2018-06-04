select a.game_id 项目编号,
       b.userid 账号id,
       b.passport 账号,
       case b.rank
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
       b.truename 姓名,
       b.mobilephone 手机,
       b.email 邮箱,
       trunc(b.starttime) 会员开始时间,
       trunc(b.endtime) 会员结结束时间,
       b.Tamount 累计充值,
       a.pay_ly 去年充值,
       b.vamount "90天内充值",
       d.pay30 "30天内充值",
       c.pay7 "7日充值",
       g.login_cnt_7 "近7天登陆次数",
       trunc(g.login_time_7, 1) as "近7天登陆时长",
       h.login_cnt_30 "近30天登陆次数",
       0 as "近30天消费",
       TRUNC(l.first_logout_time) 最早登陆,
       TRUNC(l.last_logout_time) 最后登录

  from (select userid, game_id, pay_ly
        
          from (select userid, game_id, sum(money) / 100 as pay_ly
                  from bitask.t_dw_au_billlog
                 where userid > 33
                   and logtime >= trunc(sysdate - 365)
                   and game_id in
                       (1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 15, 17, 18, 73)
                 group by userid, game_id)
        
         where pay_ly >= 100000) a

  left join (select game_au,
                    userid,
                    passport,
                    rank,
                    truename,
                    mobilephone,
                    email,
                    vamount,
                    Tamount,
                    starttime,
                    endtime
               from bitask.t_dw_vip_vipinfo
              where logtime = to_char（trunc(sysdate) - 2）) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 7
                and game_id = 73
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id = 73
              group by userid) d
    on a.userid = d.userid

  left join (select userid_,
                    count(logtime) as login_cnt_7,
                    sum(time_) / 3600 as login_time_7
               from bitask.T_000073_LOG_ROLELOGOUT
              where logtime >= trunc(sysdate) - 7
              group by userid_) g
    on a.userid = g.userid_

  left join (select userid_, count(logtime) as login_cnt_30
               from bitask.T_000073_LOG_ROLELOGIN
              where logtime >= trunc(sysdate - 30, 'MM')
                and logtime < trunc(sysdate, 'MM')
              group by userid_) h
    on a.userid = h.userid_

  left join (select userid_, sum(payment_amount_) / 100 as consumption
               from (select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_SERVICE
                      where logtime >= trunc(sysdate - 30)
                     union all
                     select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_TRADE
                      where logtime >= trunc(sysdate - 30))
              group by userid_) i
    on a.userid = i.userid_

  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33
                and logtime = trunc(sysdate - 2)) j
    on a.userid = j.userid_
   and j.rolelev_rank = 1

  left join bitask.T_000073_account_status l
    on a.userid = l.userid

 where a.game_id = 73
