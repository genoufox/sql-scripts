  insert into VIP_EDM0423
  select a.datetime ,
       a.userid ,
       b.passport,
       case b.rank
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
       end as rank,
       a.pay_total ,
       /*   a.pay_cnt 充值次数,
       a.pay_max 最大充值,
       a.pay_min 最小充值,
       a.pay_last 最近充值,
       a.pay_last 最早充值,*/
       /* 2017 - substr(b.code, 7, 4) as 年龄,
       case mod(substr(b.code, -2, 1), 2)
         when 1 then
          '男'
         when 0 then
          '女'
         else
          "未知"
       end as 性别,*/
       
       b.mobilephone 联系方式

   from (select trunc(sysdate - 1) datetime,
               userid,
               sum(money) / 100 as pay_total /*,
                               count(logtime) as pay_cnt,
                               max(money) / 100 as pay_max,
                               min(money) / 100 as pay_min,
                               trunc(max(logtime)) as pay_last,
                               trunc(max(logtime)) as pay_first */
          from bitask.t_dw_au_billlog
         where logtime > trunc(to_date(sysdate - 83))
           and logtime < trunc(to_date(sysdate - 1))
           and game_id != 4004
           and userid > 32
           and userid not in 
           (select userid from VIP_EDM0423 
             where datetime >= to_date('20180422','yyyymmdd'))
         group by userid) a

    left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(TO_DATE(sysdate - 1)) )b
    on a.userid = b.userid
   where a.pay_total >= 800;   
