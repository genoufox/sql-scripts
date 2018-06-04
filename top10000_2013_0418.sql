create table  top10000_2013_0418
as
select *
  from (select d.bi_aid,
               d.game_ab,
               d.game_name,
               a.userid,
               c.passport,
               c.truename,
               c.mobilephone,
               c.code,
               b.pay_2013,
               e.reg_time,
               f.pay2014,
               g.pay2015,
               h.pay2016,
               row_number() over(order by b.pay_2013 desc) as pay_rank
        
          from (select userid, game_au
                  from bitask.t_dw_vip_vipinfo @racdb
                 where logtime = to_date('20131231', 'yyyymmdd')) a
        
          join (select userid, sum(money) / 100 as pay_2013
                 from (select logtime, userid, money
                         from bitask.t_dw_au_billlog @racdb
                        where logtime >= to_date('20130101', 'yyyymmdd')
                          and logtime < to_date('20140101', 'yyyymmdd')
                          and game_id != 4004)
                group by userid) b
            on a.userid = b.userid
        
          join (select userid, code, passport, truename, mobilephone
                 from bitask.t_dw_vip_vipinfo partition(p20160416)) c
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
            on a.userid = f.userid
        
          left join (select userid, sum(money) / 100 as pay2015
                      from (select userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150101', 'yyyymmdd')
                               and logtime < to_date('20160101', 'yyyymmdd')
                               and game_id != 4004)
                     group by userid) g
            on a.userid = g.userid
        
          left join (select userid, sum(money) / 100 as pay2016
                      from (select userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20160101', 'yyyymmdd')
                               and game_id != 4004)
                     group by userid) h
            on a.userid = h.userid)
 where pay_rank <= 10000;
