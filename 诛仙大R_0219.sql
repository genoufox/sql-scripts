create table zx_zcx0217
as
select a.*,
       c.pay_total,
       c.pay_last,
       d.reg_time,
       f.last_logout_time,
       g.lev,
       h.alias
  from (select userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               code,
               Vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date(sysdate - 2)
           and game_au = 4
           and rank >= 3) a

/*  left join (select userid, sum(money) / 100 as pay2015
           from (select userid, money
                   from bitask.t_dw_au_billlog
                  where game_id = 4
                    )
          group by userid) b
on a.userid = b.userid */

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    max(logtime) as pay_last
               from (select userid, money, logtime
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140701', 'yyyymmdd')
                        and game_id = 4
                     
                     union all
                     select userid, money, logtime
                       from bitask.t_dw_au_billlog
                      where game_id = 4)
              group by userid) c
    on a.userid = c.userid

  left join (select userid, reg_time
               from bitask.t_dw_passport_userinfo
             union
             select userid, reg_time
               from bitask.t_dw_passport_userinfo @racdb) d
    on a.userid = d.userid

  left join bitask.t_dw_zx_account_status f
    on a.userid = f.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    substr(occupation, 1, 2) as occupation,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char£¨sysdate - 2£©) g
    on a.userid = g.userid
   and g.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) h
    on g.groupname = h.groupname
   and h.rn = 1
