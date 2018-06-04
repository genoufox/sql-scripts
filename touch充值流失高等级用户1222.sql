select distinct a.userid
  from BITASK.t_dw_touch_aclogout_status a
  join (select userid, sum(cash_delta) / 100 as pay
          from bitask.t_dw_touch_glog_addcash
         group by userid) b
    on a.userid = b.userid
  join bitask.t_dw_touch_gdb_chardata c
    on a.userid = c.userid
 where a.LAST_LOGOUT_TIME < to_date('20150901', 'yyyymmdd')
   and a.LAST_LOGOUT_TIME >= to_date('20141201', 'yyyymmdd')
   and b.pay >= 6
   and c.lev >= 1
   and c.logtime = to_date(sysdate - 2);
