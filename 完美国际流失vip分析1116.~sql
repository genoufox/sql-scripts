select a.userid 账号id,
       a.passport 账号,
       a.truename 姓名,
       a.mobilephone 手机,
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
       a.tamount as 累计充值,
       b.pay7 as "7日充值",
       b.login7_cnt "7日登陆（次）",
       b.login7_time "7日登陆时间（小时）",
       c.login30_cnt "30日登陆（次）",
       trunc(c.login30_time, 1) "30日登陆时间（小时）",
       trunc(d.pay, 1) "30日充值",
       d.pay_cnt "30日充值次数",
       g.reincarn_times  转生次数,
       g.lev as "角色级别",
       g.roleid as "最高角色id",
       trunc(sysdate - d.pay_last) 最后一次充值间隔,
       trunc(sysdate - h.last_logout_time) 　最后登陆间隔

  from (select userid, passport, rank, mobilephone, truename, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and game_au = 3) a

  left join (select userid,
                    sum(pay) / 100 as pay7,
                    count(logtime) as login7_cnt,
                    trunc(sum(onlinetime) / 3600, 1) AS login7_time
               from bitask.t_dw_iwm_account_status_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    count(logtime) as login30_cnt,
                    sum(onlinetime) / 3600 AS login30_time
               from bitask.t_dw_iwm_account_stat_day
              where userid > 33
                and logtime >= trunc(sysdate - 30)
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    sum(money) / 100 as pay,
                    trunc(max(logtime)) as pay_last,
                    count(logtime) as pay_cnt
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 30)
                and game_id = 3
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    roleid,
                    -- name,
                    reincarn_times,
                    lev,
                    --groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_iwm_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) g
    on a.userid = g.userid
   and g.rolelev_rank = 1

  left join bitask.t_dw_iwm_account_status h
    on a.userid = h.userid
 where h.last_logout_time > trunc(sysdate - 180)
