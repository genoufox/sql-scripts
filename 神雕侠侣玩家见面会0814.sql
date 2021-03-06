select a.userid 账号id,
       a.passport 账号,
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
       a.truename 姓名,
       a.mobilephone 手机,
       a.code 身份证号,
       a.email 邮箱,
       a.starttime 会员开始时间,
       a.endtime 会员结束时间,
       a.tamount 累计充值,
       a.vamount 近3月充值,
       a.province 省份,
       a.city 登记城市,       
       i.lev 角色级别,
       i.roleid 角色id,
       i.rolename 角色姓名,
       j.f_province_name 最近常登录省份,
       k.f_city_name 最近常登录城市,       
       TRUNC(l.first_logout_time) as 最早登陆,
       TRUNC(l.last_logout_time) as  最迟登陆

  from (select game_au,
               userid,
               passport,
               rank,
               province ,
               city,
               truename,
               mobilephone,
               code,
               email,
               tamount,
               vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（sysdate - 2）
           and rank >= 1
           and game_au = 18) a

  left join (select userid,
                    roleid,
                    rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sdxl_gdb_chardata
              where userid > 33
                and logtime = to_char(sysdate - 2)) i
    on a.userid = i.userid
   and i.rolelev_rank = 1
   
        left join (select c.userid,
                    c.f_province_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_province_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_sdxl_glog_accountlogout
                              where logtime >= to_char（sysdate - 30）) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name) c) j
    on a.userid = j.userid
   and j.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_sdxl_glog_accountlogout
                              where logtime >= to_char（sysdate - 30）) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) k
    on a.userid = k.userid
   and k.rn = 1 

   

  left join bitask.t_dw_sdxl_account_status l
    on a.userid = l.userid
