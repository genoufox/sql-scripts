select a.userid ,a.rank,mobilephone,endtime,trunc(sysdate - b.LAST_LOGOUT_TIME) no_loggon
from 
(select userid, rank,mobilephone ,endtime
          from bitask.t_dw_vip_vipinfo t
         where t.logtime = trunc(sysdate - 1)
           and rank = 0
           and game_au = 4
           and endtime >= trunc(sysdate - 7)) a

left join bitask.t_dw_zx_account_status b
on a.userid = b.userid 
where b.last_logout_time >= to_date(sysdate - 7) 
