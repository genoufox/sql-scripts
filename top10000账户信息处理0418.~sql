select * from 
(select 2013      as 年度,
       userid      as 账号id,
       passport    as 账号,
       truename    as 姓名,
       mobilephone as 手机,
       game_ab     as 游戏项目,
       bi_aid     as 项目编号,
       pay_2013    as 当年充值,
       login_first as 首次登陆,
       login_last  as 最后登录,
       game_au2    as 当前项目
  from vip_top10000_2013_0418
union all

select 2014      as 年度,
       userid      as 账号id,
       passport    as 账号,
       truename    as 姓名,
       mobilephone as 手机,
       game_ab     as 游戏项目,
       bi_aid     as 项目编号,
       pay2014     as 当年充值,
       login_first as 首次登陆,
       login_last  as 最后登录,
       game_au2    as 当前项目
  from vip_top10000_2014_0418

union all

select 2015      as 年度,
       userid      as 账号id,
       passport    as 账号,
       truename    as 姓名,
       mobilephone as 手机,
       game_ab     as 游戏项目,
       bi_aid     as 项目编号,
       pay2015     as 当年充值,
       login_first as 首次登陆,
       login_last  as 最后登录,
       game_au2    as 当前项目
  from vip_top10000_2015_0418
  )
  order by 1,8 desc
