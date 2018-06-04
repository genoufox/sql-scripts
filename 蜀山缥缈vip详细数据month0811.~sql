select 'SH' 项目,
       a.game_au 项目ID,
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
       a.mobilephone 电话,
       a.code 身份证,
       a.email 邮箱,
       trunc(a.starttime) 会员开始时间,
       trunc(a.endtime) 会员结结束时间,
       a.tamount 累计充值,
       a.samount 服务期充值,
       a.vamount 近3月充值,
       c.pay7 近7天充值,
       d.pay_lm 月充值,
       e.pay2016 今年充值,
       f.pay2015 去年充值,
       g.login_cnt_7 近7天登录次数,
       h.login_cnt_lm 月登陆次数,
       i.consumption "近7天消费",
       j.roleid_ 角色id,
       j.name_ 角色名,
       j.lev_ 角色等级,
       j.groupname 服务器ID,
       k.alias 服务器名称,
       TRUNC(l.first_logout_time) 最早登陆,
       TRUNC(l.last_logout_time) 最后登录,
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
               Samount,
               Vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 73
           and rank >= 1) a

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

  left join (select userid_,
                    count(logtime) as login_cnt_7,
                    trunc(sum(time_) / 3600, 1) as login_time_7
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
