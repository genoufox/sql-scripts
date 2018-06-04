select 'sh' 项目代码,
       b.game_au 项目ID,
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
       d.pay_lm 月充值,
       c.pay7 近7天充值,
       b.vamount "90天内充值",
       g.login_cnt_7 近7天登录次数,
       h.login_cnt_lm 月登陆次数,
       i.consumption "近7天消费",
       TRUNC(l.first_logout_time) 最早登陆,
       TRUNC(l.last_logout_time) 最后登录,
       trunc(g.login_time_7, 1) as "近7天登陆时长"

  from VIP_R05190 a

  join (select game_au,
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
         where logtime = to_char（trunc(sysdate) - 2）) b
    on a.userid = b.userid

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
                and logtime >= trunc(sysdate) - 30
                and game_id != 4004
              group by userid) d
    on a.userid = d.userid

  left join (select userid_,
                    count(logtime) as login_cnt_7,
                    sum(time_) / 3600 as login_time_7
               from bitask.T_000073_LOG_ROLELOGOUT
              where logtime >= trunc(sysdate) - 7
              group by userid_) g
    on a.userid = g.userid_

  left join (select userid_, count(logtime) as login_cnt_lm
               from bitask.T_000073_LOG_ROLELOGIN
              where logtime >= trunc(sysdate - 15, 'MM')
                and logtime < trunc(sysdate, 'MM')
              group by userid_) h
    on a.userid = h.userid_

  left join (select userid_, sum(payment_amount_) / 100 as consumption
               from (select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_SERVICE
                      where logtime >= trunc(sysdate - 7)
                     union all
                     select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_TRADE
                      where logtime >= trunc(sysdate - 7))
              group by userid_) i
    on a.userid = i.userid_

  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33) j
    on a.userid = j.userid_
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.T_000073_LOG_SERVERLIST) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join bitask.T_000073_account_status l
    on a.userid = l.userid
