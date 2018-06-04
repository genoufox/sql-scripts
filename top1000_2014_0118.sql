create table top1000_2014_0118
as
select *
  from (select d.bi_aid,
               d.game_ab,
               d.game_name,
               a.userid,
               a.passport,
               a.truename,
               a.mobilephone,
               a.code,
               b.pay_2014,
               row_number() over(order by b.pay_2014 desc) as pay_rank
        
          from (select userid,
                       passport,
                       rank,
                       mobilephone,
                       game_au,
                       truename,
                       code
                  from bitask.t_dw_vip_vipinfo partition(p20141231)
                  ) a
        
          join (select userid, sum(money) / 100 as pay_2014
                 from (select userid, logtime, money
                         from bitask.t_dw_au_billlog @racdb
                        where logtime >= to_date('20140101', 'yyyymmdd')
                          and logtime < to_date('20140701', 'yyyymmdd')
                          and game_id != 4004
                       union all
                       select userid, logtime, money
                         from bitask.t_dw_au_billlog
                        where logtime < to_date('20150101', 'yyyymmdd')
                          and game_id != 4004)
                group by userid) b
            on a.userid = b.userid
        
          join (select distinct bi_aid, game_ab, game_name from mapping_dy) d
            on a.game_au = d.bi_aid)
 where pay_rank <= 1000;
