create table vip3_zx_zcx0824
as
select 
       a.account     as 账号,
       b.userid      as 账号id,
       b.truename    as vip姓名,
       b.mobilephone as vip手机,
       b.email       as vip邮箱,
       c.pay2015     as "2015充值",
       d.pay_total   as 充值总额,
       e.reg_time    as 注册时间,
       f.last_logout_time as 最后登录时间,
       
       
  from VIP_ZX_ZCX0824 a

  left join(bitask.t_dw_vip_vipinfo) b
    on a.account = b.passport
   and c.logtime = to_date(sysdate - 2)
   and c.game_au = 4
 
 left join (select userid, sum(money) / 100 as pay2015
               from ( select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 4
                      and   logtime >= to_date('20150101','yyyymmdd')
              group by userid) c
    on c.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_total
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and game_id = 4
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 4)
              group by userid) d
    on c.userid = d.userid

left join (select account,reg_time from bitask.t_dw_passport_userinfo
           union 
           select account,reg_time from bitask.t_dw_passport_userinfo @racdb) e
           on a.account = e.account

left join bitask.t_dw_zx_accounmt_status f
on a.acount = f.account

 left join (select userid,
                    --   roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    occupation,
                    -- factionid,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) c
    on a.userid = c.userid
   and c.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) d
    on c.groupname = d.groupname
   and d.rn = 1


