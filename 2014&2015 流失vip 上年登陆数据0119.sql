select year as 年度,
       count(distinct userid) as 回流账号数,
       sum(case
             when login_cnt is null then
              '1'
             else
              '0'
           end) as 未登陆,
       sum(case
             when login_cnt >= 1 and login_cnt < 5 then
              '1'
             else
              '0'
           end) as 登陆4次以内,
       sum(case
             when login_cnt >= 5 then
              '1'
             else
              '0'
           end) as 登陆5次以上
  from vip_return0119_result
 group by year
;

select year as 年度,
       count(distinct userid) as 回流账号数,
       sum(case
             when login_cnt is null then
              '1'
             else
              '0'
           end) as 未登陆,
       sum(case
             when login_cnt >= 1 and login_cnt < 5 then
              '1'
             else
              '0'
           end) as 登陆4次以内,
       sum(case
             when login_cnt >= 5 then
              '1'
             else
              '0'
           end) as 登陆5次以上
  from vip3_return0119_result
 group by year
;
