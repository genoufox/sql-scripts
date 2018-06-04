

select a.userid as 账号id,
       a.account as 账号,
       b.truename as 姓名,
       b.mobilephone as 手机,
       d.pay as 期间充值额,
       trunc(d.last_logout_time) as 最后登录时间,
       trunc(g.uptime) as 角色更新时间,
       g.roleid as 角色ID,
       g.occupation as 职业代码,
       g.groupname as 服务器id,
       h.alias as 服务器名称

  from ZX_ZCX1111_2 a
  
  join

 (select userid, passport, truename, mobilephone, rank
    from bitask.t_dw_vip_vipinfo
   where logtime = to_date(sysdate - 2)) b
    on a.userid = b.userid
  
  

  left join (select userid, sum(pay) / 100 as pay,max(logtime) as last_logout_time
               from bitask.t_dw_zx_account_status_day
              where logtime < to_date('20151103', 'yyyymmdd')
                and logtime >= to_date('20150602', 'yyyymmdd')
                group by userid) d
    on a.userid = d.userid

   left join (select userid,
                    roleid,
                    groupname,
                    occupation,
                    uptime,
                    row_number() over(partition by userid order by uptime desc) as rank
               from (select userid,
                            roleid,
                            groupname,
                            TO_DATE('19700101', 'yyyymmdd') +
                            updatetime / 86400 +
                            TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone), 1, 3)) / 24 as uptime,
                            substr(occupation, 1, 2) as occupation
                       from bitask.t_dw_zx_gdb_chardata
                      where userid > 33
                        and logtime = to_date('20151102', 'yyyymmdd'))) g
    on a.userid = g.userid
   and g.rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) h
    on g.groupname = h.groupname
   and h.rn = 1
 order by d.last_logout_time desc;
