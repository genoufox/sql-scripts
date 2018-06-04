create table pay_zxsy1027
as
select trunc(logtime,'mm')  month,
       count(distinct roleid_) roleid_num,
       sum(cash_) / 100 pay_total
  from bitask.t_000138_log_addcash
 where logtime >= date '2017-07-02'
 group by trunc(logtime,'mm') 
