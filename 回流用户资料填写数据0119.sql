select year as 年度,
       count(distinct userid) as 回流账号数,
       sum(case
             when code_t is not null then
              '1'
             else
              '0'
           end) as 有资料,
       sum(case
             when code_t is null then
              '1'
             else
              '0'
           end) as 没有资料,
       sum(case
             when code_t is not null and code_l is null then
              '1'
             else
              '0'
           end) as 补填资料
  from vip_return0119_result
 group by year
;

select year as 年度,
       count(distinct userid) as 回流账号数,
       sum(case
             when code_t is not null then
              '1'
             else
              '0'
           end) as 有资料,
       sum(case
             when code_t is null then
              '1'
             else
              '0'
           end) as 没有资料,
       sum(case
             when code_t is not null and code_l is null then
              '1'
             else
              '0'
           end) as 补填资料
  from vip3_return0119_result
 group by year
