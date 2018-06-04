create table login_mon_vip_top10000_2013
as
select a.userid, a.game_ab, month, login_cnt, onlinetime
  from top10000_2015_0418 a
  left join (select userid,
                    TRUNC(logtime, 'MM') month,
                    count(logtime) as login_cnt,
                    trunc(sum(onlinetime) / 3600, 1) as onlinetime
               from (select userid, logtime, onlinetime
                       from BITASK.t_dw_sdyx_account_stat_day @racdb
                      where logtime < to_date('20140701', 'yyyymmdd')
                     union all
                     select userid, logtime, onlinetime
                       from BITASK.t_dw_sdyx_account_stat_day)
              group by userid, TRUNC(logtime, 'MM')) b
    on a.userid = b.userid
