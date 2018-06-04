select a.userid      as 账号id,
       a.account     as 账号,
       b.rank        as vip等级,
       b.mobilephone as 手机
  from bitask.t_dw_cb_account_status a
  join (select logtime, userid, rank, mobilephone, game_au
          from bitask.t_dw_vip_vipinfo
        union all
        select logtime, userid, rank, mobilephone, game_au
          from bitask.t_dw_vip_vipinfo @racdb
         where logtime < to_date('20140307', 'yyyymmdd')
           and logtime > to_date('20130201', 'yyyymmdd')) b
    on a.userid = b.userid
   and trunc(a.last_logout_time) = b.logtime
  join bitask.t_dw_vip_vipinfo partition(p20150911) C
    on a.userid = c.userid
 where a.last_logout_time < sysdate - 15
   and b.game_au = 5
   and b.rank >= 3
   and c.rank = 0
