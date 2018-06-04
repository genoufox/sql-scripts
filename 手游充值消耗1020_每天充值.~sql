create table sy1020_result_2
as
select a.*,b.day,b.pay_day from  UID_SY1020_2 a 
left join 
(select trunc(logtime) day,userid_,sum(addvalue_)/10 pay_day from bitask.t_000138_log_addvipcost

group by trunc(logtime),userid_) b
on a.userid = b.userid_
where b.day < trunc(a.createtime) + 30
