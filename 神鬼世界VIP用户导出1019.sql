create table vip_sg2_xm1019
as
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
       a.mobilephone as 手机,
       a.email as 邮箱,
       a.vamount as 近30天充值,
       b.pay_total as 累计充值,
       c.pay90 as 近3月充值,
       c.login_cnt as 近3月登陆次数,
       d.lev as 角色等级,
       d.roleid as 角色ID,
       d.name as 角色名,
       d.groupname as 服务器ID,
       e.name as 服务器名称,
       trunc(sysdate - f.last_logout_time) as 未登陆天数

  from (select userid, passport, rank, mobilephone, email, vamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 1）
           and rank >= 1
           and game = 12) a

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    row_number() over(order by sum(money) desc) as pay_rank
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 12
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                           --  and logtime > to_date('20130601', 'yyyymmdd')
                        and userid > 33
                        and game_id = 12)
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    sum(pay) / 100 as pay90,
                    count(logtime) as login_cnt
               from bitask.t_dw_sg2_account_stat_day
              where userid > 33
                and logtime >= to_char(sysdate - 90)
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    lev,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sg2_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 1）) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    version,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_sg2_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join bitask.t_dw_sg2_account_status f
    on a.userid = f.userid;
  
select * from vip_sg2_xm1019
order by 会员级别 ,近3月充值 desc nulls last
