select *
  from (select game_ab as 项目,
               game_au 项目编号,
               userid 账号ID,
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
               truename 姓名,
               mobilephone 手机,
               code 身份证,
               email 邮箱,
               trunc(starttime) as 会员开始时间,
               endtime 会员结束时间,
               tamount 累积充值,
               vamount 近1月充值,
               pay7 近7天充值,
               pay90 近90天充值,
               pay2016 今年充值,
               login_cnt_7 近7天登陆,
               login_cnt_30 近30天充值,
               consumption_7 近7天消费,
               lev 角色等级,
               roleid 角色id,
               rolename 角色名称,
               alias 服务器名称,
               f_city_name 登陆城市,
               first_logout 最早登陆,
               last_logout 最后登陆
        
          from TOTAL_VIP0318
        union all
        select game_ab as 项目,
               game_au 项目编号,
               userid 账号ID,
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
               truename 姓名,
               mobilephone 手机,
               code 身份证,
               email 邮箱,
               trunc(starttime) as 会员开始时间,
               endtime 会员结束时间,
               tamount 累积充值,
               vamount 近1月充值,
               pay7 近7天充值,
               pay90 近90天充值,
               pay2016 今年充值,
               login_cnt_7 近7天登陆,
               login_cnt_30 近30天登陆,
               0 as 近7天消费,
               lev 角色等级,
               roleid 角色id,
               rolename 角色名称,
               alias 服务器名称,
               f_city_name 登陆城市,
               first_logout 最早登陆,
               last_logout 最后登陆
        
          from TOTAL_iwm_VIP0318)

 order by 1, 16 desc
