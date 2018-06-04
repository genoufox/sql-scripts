select a.account as 账号,
       b.userid as 账号id,
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
       b.truename as vip姓名,
       b.mobilephone as vip手机,
       c.pay2015 as "上半年充值",
       d.pay_total as "累计充值",
       e.groupname 服务器id,
       f.name 服务器名称,
       f.alias 服务器详称

  from VIP_IWM_HX1014 a

  left join bitask.t_dw_vip_vipinfo b
    on a.account = b.passport

  left join (select userid, sum(money) / 100 as pay2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 3
                and logtime >= to_date('20150101', 'yyyymmdd')
                and logtime < to_date('20150701', 'yyyymmdd')
              group by userid) c
    on b.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_total
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where userid > 33
                        and game_id = 3
                        and logtime < to_date('20140307', 'yyyymmdd')
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 3)
              group by userid) d
    on b.userid = d.userid

  left join (select userid,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_iwm_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) e
    on b.userid = e.userid
   and e.rolelev_rank = 1

  join (select groupname,
               name,
               alias,
               version,
               row_number() over(partition by groupname order by version desc) as rn
          from bitask.t_dw_iwm_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1

 where b.logtime = to_date(sysdate - 2)
 order by c.pay2015 desc NULLS LAST, d.pay_total desc NULLS LAST;
