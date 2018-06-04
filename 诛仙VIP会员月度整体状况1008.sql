create table zx_vip_total1203
as
select to_char(time, 'mm') as月份,
       game_ab as 游戏项目,
       userid as 账号id,
       passport as账号,
       case rank
         when 1 then
          '银卡'
         when 2 then
          '黄金'
         when 3 then
          '白金'
         when 4 then
          '终身'
         else
          '流失VIP'
       end as 会员级别,
       code as 身份证,
       mobilephone as 手机,
       telephone as 电话,
       case
         when rank >= 1 and rank = rank_1m then
          1
         else
          null
       end as vip留存,
       case
         when rank > rank_1m and rank_1m is not null then
          1
         else
          null
       end as vip升级,
       case
         when rank < rank_1m and rank_1m is not null then
          1
         else
          null
       end as vip降级,
       
       case
         when rank >= 1 and (rank_1m < 1 or rank_1m is null) then
          1
       
         else
          null
       end as vip新增,
       case
         when rank < 1 and rank_1m >= 1 then
          1
         else
          null
       end as vip流失,
       pay7 as 近7天充值,
       pay30_2 as 近30天充值,
       login_cnt as 登陆次数,
       trunc(onlinetime / login_cnt, 2) as "时长(小时,每次)",
       nologin_days as 未登录天数,
       roleid as 角色ID,
       name as 角色名称,
       lev as 角色等级

  from (select trunc(last_day(add_months(sysdate, -1))) as time,
               c.game_ab,
               a.game_au,
               b.game_au as game_au_1m,
               a.userid,
               b.userid as userid_1m,
               a.passport,
               a.rank,
               b.rank as rank_1m,
               a.code,
               a.mobilephone,
               a.telephone,
               d.pay7,
               f.pay30_2,
               f.login_cnt,
               f.top_lev,
               f.onlinetime,
               h.roleid,
               h.name,
               h.lev,
               trunc(sysdate - g.last_logout_time) as nologin_days
          from (select t.game_au,
                       t.userid,
                       t.passport,
                       t.rank,
                       t.code,
                       t.mobilephone,
                       t.telephone
                  from bitask.t_dw_vip_vipinfo t
                 where t.logtime =
                       trunc(last_day(add_months(sysdate, -1)))
                   AND t.game_au = 4) a
        
          left join (select t.game_au, t.userid, t.passport, t.rank
                      from bitask.t_dw_vip_vipinfo t
                     where t.logtime =
                           trunc(last_day(add_months(sysdate, - (1 + 1))))
                       AND t.game_au = 4) b
            on a.userid = b.userid
           and a.game_au = b.game_au
        
          join (select distinct bi_aid, game_name, game_ab from mapping_dy) c
            on a.game_au = c.bi_aid
        
          left join (select userid, game_id, sum(money) / 100 as pay7
                      from bitask.t_dw_au_billlog
                     where logtime >=
                           trunc(last_day(add_months(sysdate, -1))) - 7
                       and logtime <
                           trunc(last_day(add_months(sysdate, -1)))
                     group by userid, game_id) d
            on a.userid = d.userid
           and a.game_au = d.game_id
        
          left join (select userid,
                           sum(pay) / 100 as pay30_2,
                           count(logtime) as login_cnt,
                           max(nvl(type * 150 + top_level, 0)) as top_lev,
                           trunc(sum(onlinetime) / 3600, 2) as onlinetime
                      from BITASK.t_dw_zx_account_stat_day
                     where logtime <
                           trunc(last_day(add_months(sysdate, -1)))
                       and logtime >=
                           trunc(last_day(add_months(sysdate, -1))) - 30
                     group by userid) f
            on a.userid = f.userid
          left join bitask.t_dw_zx_account_status g
            on a.userid = g.userid
        
          left join (select userid,
                           roleid,
                           name,
                           type * 150 + lev as lev,
                           row_number() over(partition by userid order by type desc,lev desc, exp desc) as rolelev_rank
                      from bitask.t_dw_zx_gdb_chardata
                     where userid > 33
                       and logtime = to_char（sysdate - 2）) h
            on a.userid = h.userid
           and h.rolelev_rank = 1)
;        

select * from  zx_vip_total1203
order by 未登录天数 asc
