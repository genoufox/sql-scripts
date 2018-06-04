select a.userid 账号id,
       a.account 账号,
       a.payall 累计充值,
       b.code 身份证号,
       c.userid 新id,
       c.passport 新账号,
       c.mobilephone 新联系方式,
       d.roleid 角色id,
       d.lev 角色等级,
       d.occupation 职业id,
       e.alias 角色服务器,
       trunc(f.last_logout_time）最后登陆,
       trunc(f.last_pay_time) 最后充值

  from ZX_VIP_LOST0525 a

  join

 (select userid, code
    from bitask.t_dw_vip_vipinfo
   where logtime = trunc（sysdate - 2）
  
  ) b
    on a.userid = b.userid

  join

 (select userid, passport, code, mobilephone
    from bitask.t_dw_vip_vipinfo
   where logtime = trunc（sysdate - 2）
     and game_au = 4) c

    on b.code = c.code
   and b.userid != c.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    occupation,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) d
    on c.userid = d.userid
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join bitask.t_dw_zx_account_status f
    on c.userid = f.userid

 where c.userid > b.userid
   and f.last_logout_time >= to_date('20170401', 'yyyymmdd')
