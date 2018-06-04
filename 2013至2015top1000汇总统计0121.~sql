select year as 年度,
       game_name as 游戏,
       userid as 账号id,
       passport as 账号,
       trunc(reg_time) as 注册时间,
       firstlogin as 第一次登陆,
       lastlogin as 最后登陆,
       truename as 姓名,
       code 　　　as 身份证号,
       login_cnt as 登陆次数,
       total_time as 游戏时长,
       pay_2013 as 当年充值,
       pay2014 as 次年充值
  from (select 2013 year, t.*
          from top1000_2013_new_0121 t
        union
        select 2014 year, t.*
          from top1000_2014_new_0121 t
        union
        select 2015 year, t.*
          from top1000_2015_new_0121 t)
 order by year, pay_2013 desc
