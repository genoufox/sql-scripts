select game_ab,
       game_au 项目编号,
       b.userid 账号id,
       passport,
       case rank
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
       truename 姓名,
       mobilephone 手机,
       code 身份证,
       email 邮箱,
       trunc(starttime) as 会员开始时间,
       endtime 会员结束时间,
       -- tamount 累积充值,
       pay30         近1月充值,
       pay7          近7天充值,
       vamount       近90天充值,
       login_cnt_7   近7天登陆,
       login_cnt_30  近30天登陆,
       consumption_7 近7天消费,
       first_logout  最早登陆,
       last_logout   最后登陆,
       logtime_7     近7天登陆时长

  from SuperVIP0505 a

  join TOTAL_VIP_weekly_0422 b
    on a.userid = b.userid

 order by game_ab
