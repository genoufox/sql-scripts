create table sh0815
as

select a.game_au 项目ID,
       a.userid 账号id,
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
       a.mobilephone 电话,
       a.code 身份证,
       a.email 邮箱,
       trunc(a.starttime) 会员开始时间,
       trunc(a.endtime) 会员结结束时间,
       c.pay30 近1月充值,
       d.pay90 近3月充值,
       e.pay_total 累计充值,  
       j.roleid_ 角色id,
       j.name_ 角色名,
       j.lev_ 角色等级,
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
               code,
               email,
               tamount,
               Samount,
               Vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 73
           and rank >= 1) a

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id =73
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay90
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 90)
               
                and game_id =73
              group by userid) d
    on a.userid = d.userid

  left join (select userid, sum(money) / 100 as pay_total
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160620', 'yyyymmdd')
                and game_id =73
              group by userid) e
    on a.userid = e.userid

  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33) j
    on a.userid = j.userid_
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.T_000073_LOG_SERVERLIST) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join bitask.T_000073_account_status l
    on a.userid = l.userid
