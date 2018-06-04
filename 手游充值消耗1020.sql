create table uid_sy1020_1_result
as
select a.*, b.time_5W,c.time_10W,d.time_20W,e.time_40W,f.time_60W,g.time_100W


  from UID_SY1020_1 a
  left join (select userid_, min(logtime) time_5W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 500000
              group by userid_) b
    on a.userid = b.userid_

  left join (select userid_, min(logtime) time_10W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 1000000
              group by userid_) c
    on a.userid = c.userid_
    
    left join (select userid_, min(logtime) time_20W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 2000000
              group by userid_) d
    on a.userid = d.userid_

    left join (select userid_, min(logtime) time_40W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 4000000
              group by userid_) e
    on a.userid = e.userid_
    
     left join (select userid_, min(logtime) time_60W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 6000000
              group by userid_) f
    on a.userid = f.userid_
    
         left join (select userid_, min(logtime) time_100W
               from bitask.t_000138_log_addvipcost
              where newvalue_ >= 10000000
              group by userid_) g
    on a.userid = g.userid_
