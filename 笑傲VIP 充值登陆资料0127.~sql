select a.userid as 账号id,
       a.passport as 账号,
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
          '流失VIP'
       end as 会员级别,
       a.truename as 姓名,
       a.mobilephone as 手机,
       a.tamount as 累计充值,
       b.pay_2015 as "15年充值",
       d.lev as 角色等级,
       d.roleid as 角色ID,
       d.name as 角色名,
       f.alias as 服务器,
       e.name as 帮派,
       TRUNC(g.first_logout_time) as 最早登陆,
       TRUNC(g.last_logout_time) as 最近登录

  from (select userid, passport, rank, mobilephone, truename, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and game_au = 15) a

  left join (select userid, sum(money) / 100 as pay_2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime < to_date('20160101', 'yyyymmdd')
                and logtime > to_date('20150101', 'yyyymmdd')
                and userid > 33
                and game_id = 15
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    roleid,
                    name,
                    lev,
                    factionid,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_xa_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select distinct fid, name from bitask.t_dw_xa_gdb_faction) e
    on d.factionid = e.fid

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_xa_dic_serverlist) f
    on d.groupname = f.groupname
   and f.rn = 1

  left join bitask.t_dw_xa_account_status g
    on a.userid = g.userid
 order by  b.pay_2015 desc nulls last,a.tamount desc
