select t.userid 账号id,
       t.passport 账号,
       t.truename 姓名,
       t.mobilephone 手机,
       t.rank as 会员级别,
       t.tamount as 累计充值,
       t.login30_cnt "30日登陆（次）",
       trunc(t.login30_time, 1) "30日登陆时间（小时）",
       trunc(t.pay, 1) "30日充值",
       t.pay_cnt "30日充值次数",
       t.lev as "角色级别",
       t.roleid as "最高角色id",
       trunc(sysdate - t.pay_last) as 充值间隔,
       trunc(sysdate - t.last_logout_time) 　最后登陆间隔,
       row_number() over(order by t.pay_last desc) as R_RANK,
       row_number() over(order by t.pay_cnt desc) as F_RANK,
       row_number() over(order by t.pay desc) as M_RANK
  from (select a.userid,
               a.passport,
               a.truename,
               a.mobilephone,
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
               end as rank,
               a.tamount,
               c.login30_cnt,
               c.login30_time,
               d.pay,
               d.pay_cnt,
               g.lev,
               g.roleid,
               d.pay_last,
               h.last_logout_time
        
          from (select userid, passport, rank, mobilephone, truename, tamount
                  from bitask.t_dw_vip_vipinfo
                 where logtime = to_char（sysdate - 2）
                   and rank >= 1
                   and game_au = 15) a
        
          join (select userid,
                      count(logtime) as login30_cnt,
                      sum(onlinetime) / 3600 AS login30_time
                 from bitask.t_dw_xa_account_stat_day
                where userid > 33
                  and logtime >= trunc(sysdate - 30)
                 group by userid) c
            on a.userid = c.userid
        
          join (select userid, pay, pay_last, pay_cnt
                 from (select userid,
                              sum(money) / 100 as pay,
                              trunc(max(logtime)) as pay_last,
                              count(logtime) as pay_cnt
                         from bitask.t_dw_au_billlog
                        where userid > 33
                          and logtime >= trunc(sysdate - 30)
                          and game_id = 15
                        group by userid
                       having sum(money) > 0)) d
            on a.userid = d.userid        
  
  
          left join (select userid,
                           roleid,
                           -- name,
                           lev,
                           --groupname,
                           row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                      from bitask.t_dw_xa_gdb_chardata
                     where userid > 33
                       and logtime = to_char(trunc(sysdate) - 2)) g
            on a.userid = g.userid
           and g.rolelev_rank = 1
        
          left join bitask.t_dw_xa_account_status h
            on a.userid = h.userid) t
