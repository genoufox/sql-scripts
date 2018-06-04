select case game_au
         when 1 then
          'wm'
         when 2 then
          'wl'
         when 3 then
          'iwm'
         when 4 then
          'zx'
         when 5 then
          'cb'
         when 6 then
          'rw'
         when 7 then
          'xy'
         when 8 then
          'sg'
         when 9 then
          'mz'
         when 11 then
          'sm'
         when 12 then
          'sg2'
         when 15 then
          'xa'
         when 17 then
          'sds'
         when 18 then
          'sdxl'
         when 23 then
          'sw'
         when 30 then
          'wdzy'
         when 32 then
          'sdyx'
         when 63 then
          'HEX'
         when 73 then
          'zxsj'
         else
          '其他'
       end as 项目,
       a.userid 账号id,
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
       code 身份证号,
       mobilephone 手机,
       case
         when passport like '%@%.com%' then
          'email'
         when length(passport) = 11 and substr(passport, 1, 1) = '1'  then
          'phone'
         else
          'else'
       end as 账号类型

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               code,
               mobilephone,
               starttime,
               endtime,
               vamount,
               tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 1）
           and rank >= 1) a
