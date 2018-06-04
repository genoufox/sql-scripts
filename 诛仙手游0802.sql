create table zx_sy0801_result
as
select t.*,a.login_last from ZX_SY0801 t

left join
(select roleid_,max(logtime) login_last from bitask.t_000138_log_rolelogout
where logtime > to_date('20170701','yyyymmdd')
group by roleid_
) a
on t.roleid_ = a.roleid_

