create table top_1002013
as
select d.game_name as 游戏,
       a.userid as 账号id,
       a.passport as 账号,
       a.truename as 姓名,
       a.mobilephone as 手机,
       b.pay_2013 as "2013充值",
       c.pay_total as 累计充值,
       trunc(b.lastpay) as 最后充值时间,
       case
         when c.pay_servernum > 5 then
          '是'
         else
          '否'
       end as 充值多服务器

  from bitask.t_dw_vip_vipinfo  a

  join (select userid,
                    sum(money) / 100 as pay_2013,
                    max(logtime) as lastpay,
                    row_number() over(order by sum(money) desc) as pay_rank
               from (
                     select logtime,userid, money, zoneid
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140101', 'yyyymmdd')
                        and logtime >= to_date('20130101', 'yyyymmdd')
                        and userid >= 33)
                        group by userid
                        ) b
    on a.userid = b.userid
   and b.pay_rank <= 250

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    count(distinct zoneid) as pay_servernum
               from (select userid, money, zoneid
                       from bitask.t_dw_au_billlog @racdb
                      where userid > 33
                      and logtime < to_date('20140101', 'yyyymmdd')
                     
                    )
              group by userid) c
    on a.userid = c.userid

  join (select distinct bi_aid, game_name, game_ab from mapping_dy) d
    on a.game_au = d.bi_aid

 where a.logtime = to_date('20151116','yyyymmdd')
 ;




select * from top_1002013
 order by 6 desc
