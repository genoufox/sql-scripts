  --����¼ʱ����2015.6.1-2015.7.31������ʷ��ֵ��¼���ҵȼ���10�����û���
  select distinct a.userid
    from BITASK.t_dw_touch_aclogout_status a
    join bitask.t_dw_touch_glog_addcash b
      on a.userid = b.userid
    join bitask.t_dw_touch_gdb_chardata c
      on a.userid = c.userid
   where a.LAST_LOGOUT_TIME < to_date('20150801', 'yyyymmdd')
     and a.LAST_LOGOUT_TIME >= to_date('20150601', 'yyyymmdd')
     and c.lev >= 10
     and c.logtime = to_date('20150822', 'yyyymmdd');

  --����¼ʱ����2015.6.1-2015.7.31������ʷ��ֵ��¼���ҵȼ���10�����û���
  select distinct a.userid
    from BITASK.t_dw_touch_aclogout_status a
    left join bitask.t_dw_touch_glog_addcash b
      on a.userid = b.userid
      
    join bitask.t_dw_touch_gdb_chardata c
      on a.userid = c.userid
   where a.LAST_LOGOUT_TIME < to_date('20150801', 'yyyymmdd')
     and a.LAST_LOGOUT_TIME >= to_date('20150601', 'yyyymmdd')
     and c.lev >= 10
     and c.logtime = to_date('20150822', 'yyyymmdd')
     and b.userid is null;


  --����¼ʱ����2015.3.1-2015.5.31������ʷ��ֵ��¼���ҵȼ���10�����û���
  select distinct a.userid
    from BITASK.t_dw_touch_aclogout_status a
    join bitask.t_dw_touch_glog_addcash b
      on a.userid = b.userid
    join bitask.t_dw_touch_gdb_chardata c
      on a.userid = c.userid
   where a.LAST_LOGOUT_TIME < to_date('20150601', 'yyyymmdd')
     and a.LAST_LOGOUT_TIME >= to_date('20150301', 'yyyymmdd')
     and c.lev >= 10
     and c.logtime = to_date('20150822', 'yyyymmdd');
     
  --����¼ʱ����2015.3.1-2015.5.31������ʷ��ֵ��¼���ҵȼ���10�����û���
  select distinct a.userid
    from BITASK.t_dw_touch_aclogout_status a
    left join bitask.t_dw_touch_glog_addcash b
      on a.userid = b.userid
     
    join bitask.t_dw_touch_gdb_chardata c
      on a.userid = c.userid
   where a.LAST_LOGOUT_TIME < to_date('20150601', 'yyyymmdd')
     and a.LAST_LOGOUT_TIME >= to_date('20150301', 'yyyymmdd')
     and c.lev >= 10
     and c.logtime = to_date('20150822', 'yyyymmdd')
     and b.userid is null;     
