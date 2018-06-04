select a.userid      as 账号id,
       a.account     as 账号,
       b.rank        as vip等级,
       b.mobilephone as 手机
  from bitask.t_dw_cb_account_status a
  join bitask.t_dw_vip_vipinfo b
    on a.userid = b.userid
   and trunc(a.last_logout_time) = b.logtime
 where a.last_logout_time < sysdate - 15
   and a.last_logout_time > sysdate - 365
   and b.game_au = 5
   and b.rank > 0
   and b.rank < 3;
