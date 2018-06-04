select a.*,
       b.login_cnt  as 登陆次数,
       b.pay        as 充值,
       c.roleid     角色id,
       c.rolename   as 角色名称,
       c.lev        as 角色等级,
       c.occupation as 职业代码,
       c.groupname  as 服务器id,
       d.name       as 服务器名称
  from sds_zpl1028_2 a
  left join (select userid,
                    count(logtime) as login_cnt,
                    sum(pay) / 100 as pay
               from bitask.t_dw_sds_account_status_day
              where logtime >= to_date('20151016', 'yyyymmdd')
                and logtime < to_date('20151026', 'yyyymmdd')
              group by userid) b

    on a.userid = b.userid

  left join (select userid,
                    roleid,
                    rolename,
                    lev,
                    occupation,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sds_gdb_chardata
              where userid > 33
                and logtime = to_date（sysdate - 3）) c
    on a.userid = c.userid
   and c.rolelev_rank = 1

  left join (select groupname, name
               from (select groupname,
                            name,
                            row_number() over(partition by groupname order by version desc) as rn
                       from bitask.t_dw_sds_dic_serverlist)
              where rn = 1) d
    on c.groupname = d.groupname
