select a.userid           �˺�id,
       b.last_logout_time ����½ʱ��,
       b.last_pay_time    ��󸶷�ʱ��
  from vip_2017_0208 a
  
join bitask.t_dw_xa_account_status b
    on a.userid = b.userid
