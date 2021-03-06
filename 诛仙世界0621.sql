select a.userid 账号id,
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
       --trunc(a.starttime) 会员开始时间,
       --trunc(a.endtime) 会员结结束时间,
       c.pay 充值,
       d.consumption 消耗,
       j.roleid_ 角色id,
       j.name_ 角色名,
       j.lev_ 角色等级,
       j.groupname 服务器ID,
       k.alias 服务器名称,
       TRUNC(first_logout_time) 最早登录,
       TRUNC(last_logout_time) 最后登录

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
           and game_au = 73) a

  join (select userid, sum(money) / 100 as pay
          from bitask.t_dw_au_billlog
         where userid > 33
           and game_id = 73
           and logtime >= to_date('20160620', 'yyyymmdd')
         group by userid) c
    on a.userid = c.userid

  left join (select userid_, sum(payment_amount_) / 100 as consumption
               from (select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_SERVICE
                      where logtime >= to_date('20160620', 'yyyymmdd')
                     union all
                     select userid_, payment_amount_
                       from bitask.T_000073_LOG_MALL_TRADE
                      where logtime >= to_date('20160620', 'yyyymmdd'))
              group by userid_) d
    on a.userid = d.userid_

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

  left join bitask.t_000073_account_status l

    on a.userid = l.userid

 where c.pay >= 1000

 order by c.pay desc nulls last
