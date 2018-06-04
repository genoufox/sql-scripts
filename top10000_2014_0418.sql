create table  top10000_2014_0418
as
select *
  from (select d.bi_aid,
               d.game_ab,
               d.game_name,
               a.userid,
               c.passport,
               c.truename,
               c.mobilephone,
               c.game_au as game_new,
               b.pay2014,
               e.reg_time,
               g.pay2015,
               h.pay2016,
               row_number() over(order by b.pay2014 desc) as pay_rank
        
          from (select userid, game_au
                  from bitask.t_dw_vip_vipinfo 
                 where logtime = to_date('20141231', 'yyyymmdd')) a
        
          join (select userid, sum(money) / 100 as pay2014
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
                group by userid) b
            on a.userid = b.userid
        
          join (select userid, code, passport, truename, mobilephone,game_au
                 from bitask.t_dw_vip_vipinfo partition(p20160416)) c
            on a.userid = c.userid
        
          join (select distinct bi_aid, game_ab, game_name from mapping_dy) d
            on a.game_au = d.bi_aid
        
          left join (select userid, reg_time
                      from bitask.t_dw_passport_userinfo
                    union
                    select userid, reg_time
                      from bitask.t_dw_passport_userinfo @racdb) e
            on a.userid = e.userid
        
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
