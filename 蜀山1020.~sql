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
          '流失'
       end as 会员级别,
       a.truename 姓名,
       a.mobilephone 手机,
       a.email 邮箱,
       a.province 省份,
       a.city  城市,
       c.pay 充值,
       d.consumption 消耗,
       d.roleid_ 角色id,
       d.name_ 角色名,
       d.lev_ 角色等级,
       d.groupname 服务器ID,
       e.alias 服务器名称,
       TRUNC(first_logout_time) 最早登录,
       TRUNC(last_logout_time) 最后登录

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               starttime,
               endtime,
               city,
               province
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char（trunc(sysdate) - 2）
           and game_au = 73) a

  join (select userid, sum(money) / 100 as pay
          from bitask.t_dw_au_billlog
         where userid > 33
           and game_id = 73
           and logtime >= to_date('20160620', 'yyyymmdd')
         group by userid) c
    on a.userid = c.userid


  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33
                and logtime = trunc(sysdate - 2)) d
    on a.userid = d.userid_
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.T_000073_LOG_SERVERLIST) e
    on d.groupname = e.groupname
   and e.rn = 1
   
   left join (select c.userid,
                    c.f_province_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_province_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_zx_
                              where logtime >= trunc(sysdate - 90, 'MM')
                                and logtime < trunc(sysdate, 'MM')) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name) c) f
    on a.userid = f.userid
   and f.rn = 1
   
   

  left join bitask.t_000073_account_status l

    on a.userid = l.userid

 where c.pay >= 100000

 order by c.pay desc nulls last
