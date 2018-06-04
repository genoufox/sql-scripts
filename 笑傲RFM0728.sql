create table user_xa0728
as
select a.userid as 账号id,
       a.passport as 账号,
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
       a.truename as 姓名,
       a.mobilephone as 手机,
       a.tamount as 累计充值,
       b.pay30 as "近1月充值(元）",
       b.pay_cnt as 近1月充值次数,
       trunc(sysdate - b.pay_max) as "最近充值间隔（天）",
       c.log_time as "近1月登陆(小时）",
       c.log_cnt as 近1月登陆次数,
       trunc(sysdate - c.log_max) as "最近登陆间隔（天）",
       TRUNC(d.first_logout_time) as 最早登陆,
       TRUNC(d.last_logout_time) as 最近登录

  from (select userid, passport, rank, mobilephone, truename, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and rank >= 1
           and game_au = 15) a

    left join (select userid, sum(pay) / 100 as pay30,count(pay) as pay_cnt,max(logtime) as pay_max
               from bitask.t_dw_xa_account_status_day
              where userid > 33
                and logtime > trunc(sysdate - 30)
                and pay > 0
              group by userid) b
    on a.userid = b.userid  
    
    left join (select userid, trunc(sum(onlinetime/3600),1) as log_time ,count(logtime) as log_cnt,max(logtime) as log_max
               from bitask.t_dw_xa_account_status_day
              where userid > 33
                and logtime > trunc(sysdate - 30)
              group by userid) c
    on a.userid = c.userid  


  left join bitask.t_dw_xa_account_status d
    on a.userid = d.userid
    

