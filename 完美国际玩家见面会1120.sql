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
       a.mobilephone as 手机,
       a.telephone as 座机,
       a.email as 邮箱,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '男'
         when 0 then
          '女'
         else
          '未知'
       end as 性别,
       a.tamount as 累计充值,
       a.Vamount as 近90天充值,
       b.pay30 as 近30天充值,
       c.pay2017 as "今年充值",
       d.roleid as 角色id,
       d.name as 角色名称,
       d.lev as 角色等级,
       e.alias as 服务器,
        trunc(h.first_logout_time) as 最早登陆,
       trunc(h.last_logout_time) as 最后登陆
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
           and rank >= 1
           and game_au = 3) a
           
  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 30)
                and game_id = 3
              group by userid) b
    on a.userid = b.userid
    
  left join (select userid, sum(money) / 100 as pay2017
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20170101','yyyymmdd')
                and game_id = 3
              group by userid) c
    on a.userid = c.userid
    
  left join (select userid,
                    roleid,
                    name,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_iwm_gdb_chardata
              where userid > 33
                and logtime = to_char（sysdate - 2）) d
    on a.userid = d.userid
   and d.rolelev_rank = 1
   
  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_iwm_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1
   
   
  left join bitask.t_dw_iwm_account_status h
    on a.userid = h.userid
    
 order by rank desc, tamount desc nulls last
