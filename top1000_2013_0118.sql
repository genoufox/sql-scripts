create table  top1000_2013_new
as
select *
  from (select d.bi_aid,
               d.game_ab,
               d.game_name,
               a.userid,
               a.passport,
               c.truename,
               c.code,
               b.pay_2013,
               e.reg_time,
               f.pay2014,
               row_number() over(order by b.pay_2013 desc) as pay_rank
        
          from (select userid, passport, game_au, truename
                  from bitask.t_dw_vip_vipinfo @racdb
                 where logtime = to_date('20131231', 'yyyymmdd')
                 ) a
        
          join (select userid, sum(money) / 100 as pay_2013
                 from (select logtime, userid, money
                         from bitask.t_dw_au_billlog @racdb
                        where logtime >= to_date('20130101', 'yyyymmdd')
                          and logtime < to_date('20140101', 'yyyymmdd')
                          and game_id != 4004)
                group by userid) b
            on a.userid = b.userid
        
          join (select userid, code, truename
                 from bitask.t_dw_vip_vipinfo partition(p20151231)) c
            on a.userid = c.userid
        
          join (select distinct bi_aid, game_ab, game_name from mapping_dy) d
            on a.game_au = d.bi_aid
        
          left join bitask.t_dw_passport_userinfo @racdb e
            on a.userid = e.userid
        
          left join (select userid, sum(money) / 100 as pay2014
                      from (select userid, money
                              from bitask.t_dw_au_billlog @racdb
                             where logtime >= to_date('20140101', 'yyyymmdd')
                               and logtime < to_date('20140701', 'yyyymmdd')
                               and game_id != 4004
                            union all
                            select userid, money
                              from bitask.t_dw_au_billlog
                             where logtime < to_date('20150101', 'yyyymmdd')
                               and game_id != 4004)
                     group by userid) f
            on a.userid = f.userid)

 where pay_rank <= 1000;
