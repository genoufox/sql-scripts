create table vip3_zx20180103
as
select a.userid as 账号id,
       a.passport as 账号,
       a.truename as 姓名,
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
       end as VIP等级,
       a.mobilephone as 手机,
       a.telephone as 电话,
       a.tamount as 累计充值,
       b.pay_90 as "近3月充值(元)",
       c.pay_180 as "近6月充值(元)",
       d.pay_2017 as "2017年充值(元)",
       --     d.log_num          as 登录次数,
       --     d.onlinetime_month as "登录总时长(小时)",
      -- e.roleid as 角色id,
      -- e.name as 角色名称,
       b.top_lev as 角色最高等级,
      -- f.alias as 服务器名称,
       trunc(g.last_logout_time) as 最后一次登录,
       trunc(sysdate - g.first_logout_time) as 游戏生涯


  from (select userid, passport, truename, rank, mobilephone, telephone,tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char(sysdate - 2)
           and rank >= 3
           and game_au = 4) a

  left join (select userid, sum(pay) / 100 as pay_90,max(top_level) as top_lev
               from bitask.t_dw_zx_account_stat_day
              where userid > 33
                and logtime >= to_char(sysdate - 90)
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay_180
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 4
                and logtime >= to_char(sysdate - 180)
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_2017
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 4
                and logtime >= to_date('20170101', 'yyyymmdd')
              group by userid) d
    on a.userid = d.userid

/*  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    -- factionid,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) e
    on a.userid = e.userid
   and e.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1 */

  left join bitask.t_dw_zx_account_status g
    on a.userid = g.userid



