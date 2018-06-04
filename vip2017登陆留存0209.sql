select a.userid           账号id,
       b.last_logout_time 最后登陆时间,
       b.last_pay_time    最后付费时间
  from vip_2017_0208 a
  
join bitask.t_dw_xa_account_status b
    on a.userid = b.userid
