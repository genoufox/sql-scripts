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
          null
       end as VIP等级,
       a.mobilephone as 手机,
       a.tamount as 累计充值,
       NVL(c.pay_total2, 0) as 近3月充值,
       d.lev as 角色等级,
       d.groupname as 服务器,
       d.roleid as 角色ID,
       d.name as 角色名,
       e.f_province_name as 最常登陆省份,
       e.f_city_name as 最常登陆城市,
       trunc(f.last_logout_time) as 最后登录时间

  from (select userid, passport, rank, mobilephone, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char(sysdate - 2)
           and rank >= 1
           and game = 12) a

/* join (select userid,
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
    on a.userid = b.userid]
*/

  left join (select userid, sum(money) / 100 as pay_total2
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 12
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
               from bitask.t_dw_sg2_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select c.userid,
                    c.f_province_name,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid,
                            b.f_province_name,
                            b.f_city_name,
                            count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_sg2_glog_accountlogout
                              where logtime >= to_date('20160101', 'yyyymmdd')) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name, f_city_name) c) e
    on a.userid = e.userid
   and e.rn = 1
  left join bitask.t_dw_sg2_account_status f
    on a.userid = f.userid
 order by a.rank desc, c.pay_total2 desc nulls last;
