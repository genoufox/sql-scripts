select a.userid 账号id,
       a.passport 账号,
       a.Tamount 累计充值,
       case a.rank
         when 4 then
          '终身'
         when 3 then
          '白金'
         when 2 then
          '金卡'
         when 1 then
          '银卡'
         when 0 then
          '流失'
         else
          '非vip'
       end as 会员级别,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '男'
         when 0 then
          '女'
         else
          '未知'
       end as 性别,
       b.log_cnt "6月登陆次数",
       c.consumption_7 最近7日消费,
       d.roleid 角色id,
       d.lev 角色等级,
       e.alias 角色服务器,
       trunc(f.last_logout_time）最后登陆, trunc(f.last_pay_time) 最后充值
       
       from
       
        (select userid,passport, rank, truename, mobilephone, code, tamount
           from bitask.t_dw_vip_vipinfo
          where logtime = trunc（sysdate - 2）
            and game_au = 4
         
         ) a
       
       left join (select userid, count(logtime) as log_cnt
                    from bitask.t_dw_zx_account_status_day
                   where logtime >= to_date('20170601', 'yyyymmdd')
                     and logtime < to_date('20170620', 'yyyymmdd')
                   group by userid) b on a.userid = b.userid
       
       left join (select userid, sum(cash_need) as consumption_7
                    from bitask.t_dw_zx_glog_shoptrade
                   where logtime >= trunc(sysdate) - 7
                   group by userid) c on a.userid = c.userid
       
       left join (select userid,
                         roleid,
                         name rolename,
                         lev,
                         occupation,
                         groupname,
                         row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                    from bitask.t_dw_zx_gdb_chardata
                   where userid > 33
                     and logtime = to_char(trunc(sysdate) - 2)) d on a.userid = d.userid and d.rolelev_rank = 1
       
       left join (select groupname,
                         name,
                         alias,
                         row_number() over(partition by groupname order by version desc) as rn
                    from bitask.t_dw_zx_dic_serverlist) e on d.groupname = e.groupname and e.rn = 1
       
       left join bitask.t_dw_zx_account_status f on a.userid = f.userid
       
       where f.last_logout_time >= to_date('20150625', 'yyyymmdd')
