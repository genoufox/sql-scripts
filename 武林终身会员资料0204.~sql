select a.userid 账号id,
       e.passport 账号,
       a.datetime 充值日期,
       a.money 单日充值额,
       case e.rank
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
       e.truename 姓名,
       e.mobilephone 手机,
       e.email 邮箱,
       e.city 城市,
       e.address 住址,
       e.vamount 累计充值,
       b.alias 充值服务器,
       c.roleid 角色id,
       c.name 角色名称,
       c.lev 角色等级,
       trunc(d.last_logout_time) 最后一次登录

  from (select trunc(logtime) datetime,
               userid,
               sum(money) / 100 as money,
               zoneid
          from bitask.t_dw_au_billlog @racdb
         where logtime < to_date('20140701', 'yyyymmdd')
           and game_id = 2
           and money >= 10000000
         group by trunc(logtime), userid, zoneid
        
        union all
        select trunc(logtime) datetime,
               userid,
               sum(money) / 100 as money,
               zoneid
          from bitask.t_dw_au_billlog
         where game_id = 2
           and money >= 10000000
         group by trunc(logtime), userid, zoneid) a

 
  left join (select zoneid,
                    groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) b
    on a.zoneid = b.zoneid
   and b.rn = 1

  left join (select userid, groupname, roleid, name, type * 100 + lev as lev
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）
            ) c
    on a.userid = c.userid
   and b.groupname = c.groupname

  left join bitask.t_dw_wl_account_status d
    on a.userid = d.userid

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
              where logtime = to_char（sysdate - 2）) e
    on a.userid = e.userid

 order by a.userid
