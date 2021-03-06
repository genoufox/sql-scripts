select a.userid as 账号id,
       a.passport as 账号,
       a.rank as VIP等级,
       a.mobilephone as 手机,
       --b.pay_total as 累计充值,
       c.pay_total2 as 近3月充值,
       d.lev as 角色等级,
       d.groupname as 服务器,
       d.roleid as 角色ID,
       d.name as 角色名,
       e.f_province_name as 最常登陆省份,
       e.f_city_name     as 最常登陆城市,
       f.last_logout_time as 最后登录时间

  from (select userid, passport, rank, mobilephone
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and rank >= 2
           and game = 8) a

/* join (select userid,
                    sum(money) / 100 as pay_total,
                    row_number() over(order by sum(money) desc) as pay_rank
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 8
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                      --  and logtime > to_date('20130601', 'yyyymmdd')
                        and userid > 33
                        and game_id = 8)
              group by userid) b
    on a.userid = b.userid]
*/

 left join (select userid, sum(money) / 100 as pay_total2
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 8
                and logtime >= to_char(sysdate - 90)
              group by userid) c
    on a.userid = c.userid  

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    lev,
                   -- factionid,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sg_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) d
    on a.userid = d.userid
    and d.rolelev_rank = 1   


left join (select c.userid,
               c.f_province_name,
               c.f_city_name,
               c.cnt,
               row_number() over(partition by c.userid order by c.cnt desc) as rn
          from (select a.userid, b.f_province_name,b.f_city_name, count(*) as cnt
                  from (select userid, ip_num
                          from bitask.t_dw_sg_glog_accountlogout
                         where logtime >= to_date('20150501', 'yyyymmdd')) a,
                       bitask.t_dic_ipseg_int_db b
                 where a.ip_num between b.f_bip and b.f_eip
                   and b.f_floor = trunc(a.ip_num / 65536, 0)
                 group by a.userid, f_province_name,f_city_name) c
         ) e
    on a.userid = e.userid
   and e.rn = 1
  left join bitask.t_dw_sg_account_status f
    on a.userid = f.userid
    order by 10,3 desc;
  
