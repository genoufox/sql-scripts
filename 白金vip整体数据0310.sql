select game_ab 游戏,
       userid 账号id,
       passport 账号,
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
       endtime 会员结束日期,
       truename 姓名,
       code 身份证,
       mobilephone 手机,
       email 邮箱,
       pay7 "7日充值",
       vamount "30日充值",
       pay2015 "2015年充值",
       tamount 累计充值,
       login_cnt "30天内登陆",
       lev 角色等级,
       roleid 角色id,
       rolename 角色名称,
       alias 服务器,
       f_city_name 登陆城市,
       first_logout 最早登陆,
       last_logout 最后登陆

  from vip3_yss0310
 order by game_ab, rank desc, pay2015 desc nulls last
