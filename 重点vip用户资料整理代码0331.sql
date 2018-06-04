select a.passport,
       a.game_name,
       b.game_ab as 项目,
       b.game_au 项目编号,
       b.userid 账号ID,
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
          '流失VIP'
       end as 会员级别,
       b.truename 姓名,
       b.code 身份证,
       b.mobilephone 手机,
       b.email 邮箱,
       b.starttime 会员开始时间,
       b.endtime 会员结束时间,
       b.tamount 累积充值,
       b.samount 服务期充值,
       b.vamount 近3月充值,
       b.pay7 近7天充值,
       b.pay30 近30天充值,
       b.pay2016 今年充值,
       b.pay2015 去年充值,
       b.login_cnt_7 近7天登陆,
       b.login_cnt_30 近30天充值,
       b.consumption_7 "近7天消费(元宝)",
       b.lev 角色等级,
       b.roleid 角色id,
       b.rolename 角色名称,
       b.alias 服务器名称,
       b.f_city_name 登陆城市,
       b.first_logout 最早登陆,
       b.last_logout 最后登陆,
       trunc(b.login_time_7) 近7天登陆时长

  from vip_focus0321 a

  left join TOTAL_VIP_month_0429 b
    on a.passport = b.passport

 order by b.game_ab, b.passport 
