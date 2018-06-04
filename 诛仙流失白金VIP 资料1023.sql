create table zx_vip3_lost1023
as 
select userid from bitask.t_dw_vip_vipinfo @racdb
where game_id = 4
and  rank >= 3
union 
select userid from bitask.t_dw_vip_vipinfo 
where game_id = 4
and  rank >= 3 ;


select b.userid as 账号id,
       b.passport as 账号,
       b.truename as vip姓名,
       b.mobilephone as vip手机,
       case b.rank
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
       c.pay2015 as "2015充值",
       d.pay_total as 充值总额,
       e.reg_time as 注册时间,
       trunc(f.last_logout_time) as 最后登录时间,
       g.roleid as 角色ID,
       g.lev as 角色等级,
       g.occupation as 职业代码,
       g.groupname as 服务器id,
       h.alias as 服务器名称

  from zx_vip3_lost1023 a

  join

 (select userid, passport, truename, mobilephone, rank
    from bitask.t_dw_vip_vipinfo
   where logtime = to_date(sysdate - 2)) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay2015
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 4
                        and logtime >= to_date('20150101', 'yyyymmdd'))
              group by userid) c
    on b.userid = c.userid

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
    on b.userid = d.userid

  left join (select userid, reg_time
               from bitask.t_dw_passport_userinfo
             union
             select userid, reg_time
               from bitask.t_dw_passport_userinfo @racdb) e
    on b.userid = e.userid

  left join bitask.t_dw_zx_account_status f
    on b.userid = f.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    substr(occupation, 1, 2) as occupation,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) g
    on b.userid = g.userid
   and g.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) h
    on g.groupname = h.groupname
   and h.rn = 1

 where f.last_logout_time < sysdate - 15;
 




