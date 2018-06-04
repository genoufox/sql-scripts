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
       a.truename as 姓名,
      -- a.mobilephone as 手机,
       --a.telephone as 座机,
      -- a.email as 邮箱,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '男'
         when 0 then
          '女'
         else
          '未知'
       end as 性别,
       a.Tamount as 累计充值,
       b.pay2017 as 今年充值,
       f.roleid as 角色id,
       f.name as 角色名称,
       f.lev as 角色等级,
       g.alias as 服务器,
       h.f_province_name as 最常登陆省份,
       i.f_city_name as 最常登陆城市,
       trunc(j.first_logout_time) as 最早登陆,
       trunc(j.last_logout_time) as 最后登陆
  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               telephone,
               code,
               email,
               tamount,
               vamount,
               city
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and rank >= 3
           and game_au = 6) a /*  left join (select userid, sum(money) / 100 as pay_total             from (select userid, money                     from bitask.t_dw_au_billlog                    where userid > 33                      and game_id = 4                   union all                   select userid, money                     from bitask.t_dw_au_billlog @racdb                    where userid > 33                      and game_id = 4                      and logtime < to_date('20140701', 'yyyymmdd'))            group by userid) b  on a.userid = b.userid */

  left join (select userid, sum(money) / 100 as pay2017
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20170101', 'yyyymmdd')
                and game_id = 6
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    roleid,
                    name,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_rw_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) f
    on a.userid = f.userid
   and f.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_rw_dic_serverlist) g
    on f.groupname = g.groupname
   and g.rn = 1

  left join (select c.userid,
                    c.f_province_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, f_province_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_rw_glog_accountlogout
                              where logtime >= to_char（sysdate - 30）) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name) c) h
    on a.userid = h.userid
   and h.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_rw_glog_accountlogout
                              where logtime >= to_char（sysdate - 30）) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) i
    on a.userid = i.userid
   and i.rn = 1
   
  left join bitask.t_dw_rw_account_status j
    on a.userid = j.userid

 order by a.rank desc, b.pay2017 desc nulls last
