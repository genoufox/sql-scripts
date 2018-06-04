select *
  from (select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20140630) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20140601', 'yymmdd')
                               and logtime < to_date('20140701', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20140731) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20140701', 'yymmdd')
                               and logtime < to_date('20140801', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20140831) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20140801', 'yymmdd')
                               and logtime < to_date('20140901', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20140930) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20140901', 'yymmdd')
                               and logtime < to_date('20141001', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20141031) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20141001', 'yymmdd')
                               and logtime < to_date('20141101', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20141130) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20141101', 'yymmdd')
                               and logtime < to_date('20141201', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20141207) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20141201', 'yymmdd')
                               and logtime < to_date('20150101', 'yymmdd')
                               and game_id = 8
                            
                            ) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo t
                         where t.rank > = 3
                           and t.logtime = to_date('20150131', 'yyyymmdd')
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150101', 'yymmdd')
                               and logtime < to_date('20150201', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo t
                         where t.rank > = 3
                           and t.logtime = to_date('20150228', 'yyyymmdd')
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150201', 'yymmdd')
                               and logtime < to_date('20150301', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo t
                         where t.rank > = 3
                           and t.logtime = to_date('20150331', 'yyyymmdd')
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150301', 'yymmdd')
                               and logtime < to_date('20150401', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20150430) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150401', 'yymmdd')
                               and logtime < to_date('20150501', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                )
        
        union
        select *
          from (select trunc(a.logtime) as 月份,
                       a.rank as VIP等级,
                       count(distinct a.passport) as VIP数量,
                       sum(b.money) / 100 as 充值额
                  from (select t.logtime,
                               t.userid,
                               t.passport,
                               t.rank,
                               t.game_au
                          from bitask.t_dw_vip_vipinfo partition(p20150531) t
                         where t.rank > = 3
                           and game_au = 8) a
                  left join (select logtime, billid, userid, money
                              from bitask.t_dw_au_billlog
                             where logtime >= to_date('20150501', 'yymmdd')
                               and logtime < to_date('20150601', 'yymmdd')
                               and game_id = 8) b
                    on a.userid = b.userid
                 group by a.rank, a.logtime
                
                ))
 order by 1, 2
