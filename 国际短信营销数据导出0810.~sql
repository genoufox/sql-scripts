create table nvip_iwm0810
as
select a.userid 账号id,
       e.account 账号,
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
       a.pay_cnt 充值次数,
       a.pay_max 最大充值,
       a.pay_min 最小充值,
       a.pay_last 最近充值,
       a.pay_last 最早充值,
       --  c.roleid 角色id,
       -- c.lev 角色等级,
       trunc(e.first_logout_time) 最早登陆,
       trunc(e.last_logout_time）最后登陆
       
       from
       
       bitask.t_dw_iwm_account_status e
       
       join (select userid,
                    sum(money) / 100 as pay_total,
                    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 82))
              and   game_id = 3
              group by userid) a on e.userid = a.userid
       
       left join (select userid, passport, code, mobilephone, rank
                    from bitask.t_dw_vip_vipinfo
                   where logtime = trunc(TO_DATE(sysdate - 2))) b on e.userid = b.userid
       
       left join user_iwm_1 c
       on e.userid  = c.userid
       
       left join user_iwm_2 d
       on e.userid  = d.userid
        
       
       where pay_total >= 300 and pay_total < 1000 and b.userid is null
       
       and e.last_logout_time > trunc(sysdate - 7)
       and c.userid is null
       and d.userid is null

