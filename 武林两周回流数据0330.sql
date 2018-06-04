select t1.passport 账号,
       t2.userid 账号id,
       case t2.rank
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
       t2.truename 姓名,
       t2.mobilephone 手机,
       t2.email 邮箱,
       t2.city 城市,
       nvl(a.money, 0) 充值额,
       nvl(b.login_cnt, 0) 登陆次数,
       trunc(b.login_max) 最后登录时间,
       nvl(c.alias,'无') 登陆服务器,
       d.roleid 角色id,
       d.name 角色名称,
       d.lev 角色等级

  from ACCOUNT_WL_0330 t1

  left join (select userid,
                    passport,
                    rank,
                    truename,
                    mobilephone,
                    email,
                    city,
                    address,
                    Vamount
               from bitask.t_dw_vip_vipinfo
              where logtime = to_char（sysdate - 2）) t2
    on t1.passport = t2.passport

  left join (select userid, sum(money) / 100 as money
               from bitask.t_dw_au_billlog
              where game_id = 2
                and logtime >= to_date('20160311', 'yyyymmdd')
                and logtime < to_date('20160325', 'yyyymmdd')
              group by userid) a
    on t2.userid = a.userid

  left join (select userid,
                    groupname,
                    max(logtime) as login_max,
                    count(distinct trunc(logtime)) as login_cnt
             
               from bitask.t_dw_wl_glog_accountlogout
              where logtime >= to_date('20160311', 'yyyymmdd')
                and logtime < to_date('20160325', 'yyyymmdd')
              group by userid, groupname) b
    on t2.userid = b.userid

  left join (select zoneid,
                    groupname,
                    alias,
                    name,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) c
    on b.groupname = c.groupname
    and c.rn = 1

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 100 + lev as lev,
                    -- factionid,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 1）) d
    on t2.userid = d.userid
   and d.rolelev_rank = 1
    

 order by trunc(b.login_max) desc nulls last,t1.passport
