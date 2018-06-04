create table user_zx_082
as
select a.userid 账号id,
       b.passport 账号,
       case b.rank
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
       a.pay_total 累计充值,
       --2017 - substr(b.code, 7, 4) as 年龄,
       case mod(substr(b.code, -2, 1), 2)
         when 1 then
          '男'
         when 0 then
          '女'
         else
          '未知'
       
       end as 性别,
       
       b.mobilephone 联系方式,
       --c.roleid 角色id,
       --c.lev 角色等级,
       trunc(e.first_logout_time) 最早登陆,
       trunc(e.last_logout_time）最后登陆
       
       from
       
       bitask.t_dw_zx_account_status e
       
       join (select userid,
                    sum(money) / 100 as pay_total
                    --,
                /*    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first */
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 82))
                and logtime < trunc(to_date(sysdate - 0))
              group by userid) a 
              on e.userid = a.userid
       
       left join (select userid, passport, code, mobilephone, rank
                    from bitask.t_dw_vip_vipinfo
                   where logtime = trunc(TO_DATE(sysdate - 2))) b 
                   on e.userid = b.userid
       
       /*       left join (select userid,
             roleid,
             name rolename,
             lev,
             occupation,
             groupname,
             row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
        from bitask.t_dw_zx_gdb_chardata
       where userid > 33
         and logtime = trunc(sysdate) - 2) c 
         on e.userid = c.userid 
         and c.rolelev_rank = 1 */
       
       where pay_total >= 300 and pay_total < 1000 
       and b.rank is null 
       and e.last_logout_time > trunc(sysdate - 7)
