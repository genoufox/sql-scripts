select a.userid,
       a.phone,
       b.会员级别 会员级别1,
       case c.rank
         when 4 then
          '终身'
         when 3 then
          '白金'
         when 2 then
          '金卡'
         when 1 then
          '银卡'
         when 0 then
          '流失'
         else
          '非vip'
       end as 会员级别2,
       b.最大充值,
       b.最近充值 最近充值日期1,
       b.累计充值 充值1,
       d.pay7 新增充值2,
       b.充值次数 充值次数1,
       d.pay7_cnt 新增充值次数,
       e. login_time "7日在线时间",
       e.top_level as 最高级别,
       b.最早登陆,
       b.最后登陆 最后登陆1,
       trunc(e.login_last) 最后登陆2

  from user_xa0815_2 a
  left join NVIP_XA0808  b
    on a.userid = b.账号id

  left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(sysdate - 2)) c
    on a.userid = c.userid

  left join (select userid,
                    sum(pay) / 100 as pay7,
                    count(logtime) as pay7_cnt
             
               from bitask.t_dw_xa_account_stat_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)
                and pay > 0
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    max(logtime) as login_last ,
                    max(top_level) as top_level,
                    trunc(sum(onlinetime) / 3600, 1) as login_time
               from bitask.t_dw_xa_account_stat_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)                
              group by userid) e
    on a.userid = e.userid
    
  where a.status = 1
