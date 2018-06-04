select a.userid 账号id,
       a.passport 账号,
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
          '流失'
       end as 会员级别,
       a.truename 姓名,
       a.mobilephone 手机,
       a.email 邮箱,
       trunc(a.starttime) 会员开始时间,
       trunc(a.endtime) 会员结结束时间,
       a.vamount "近90天充值",
       a.samount "本服务器内充值",
       b.month 充值月份，
       b.pay_cnt 充值次数,
       b.pay_month 充值金额,
       c.roleid 角色id,
       c.rolename 角色名称,
       d.alias 服务器,
       TRUNC(e.first_logout_time) 最早登陆,
       TRUNC(e.last_logout_time) 最后登录
  

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               tamount,
               samount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 9
           and rank >= 3) a

  left join (select userid,TRUNC(logtime, 'MM') as month, sum(money) / 100 as pay_month,count(logtime) as pay_cnt
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20151101','yyyymmdd')
                and game_id = 9 
              group by userid,TRUNC(logtime, 'MM')) b
    on a.userid = b.userid

  
left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_mz_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) c
    on a.userid = c.userid
   and c.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_mz_dic_serverlist) d
    on c.groupname = d.groupname
   and d.rn = 1

  left join bitask.t_dw_mz_account_status e
    on a.userid = e.userid
    
order by a.userid
