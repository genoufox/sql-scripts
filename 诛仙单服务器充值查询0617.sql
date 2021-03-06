select a.userid as 账号ID,
       a.account as 账号,
       trunc(last_logout_time) as 最后登录,
       b.zoneid as 充值服务器,
       b.pay as 充值金额,
       c.roleid as 角色id,
       c.rolename as 角色名称,
       c.lev as 角色等级,
       e.mobilephone as 手机

  from bitask.t_dw_zx_account_status a

  join (select userid, zoneid, sum(money) / 100 as pay
          from bitask.t_dw_au_billlog b
         where game_id = 4
           and zoneid in (968, 947, 961)
           and logtime >=
               to_date('20160531 12:00:00', 'yyyymmdd hh24:mi:ss')
           and logtime < to_date('20160607', 'yyyymmdd')
         group by userid, zoneid) b
    on a.userid = b.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) c
    on a.userid = c.userid
   and c.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) d
    on c.groupname = d.groupname
   and d.rn = 1

  left join bitask.t_dw_vip_vipinfo partition(p20160618) e
    on a.userid = e.userid

 order by pay desc
