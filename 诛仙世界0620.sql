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
       c.pay 历史充值,
       j.roleid 角色id,
       j.rolename 角色名,
       j.lev 角色等级,
       j.groupname 服务器ID,
       k.alias 服务器名称,
       TRUNC(l.first_logout_time) 最早登陆,
       TRUNC(l.last_logout_time) 最后登录

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 15
           and rank = 0) a

  left join (select userid, sum(money) / 100 as pay
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 73
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zxsj_gdb_chardata
              where userid > 33) j
    on a.userid = j.userid
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zxsj_dic_serverlist) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join bitask.t_dw_zxsj_account_status l
    on a.userid = l.userid

 where pay >= 500

 order by c.pay desc nulls last
