select year as ���,
       count(distinct userid) as �����˺���,
       sum(case
             when code_t is not null then
              '1'
             else
              '0'
           end) as ������,
       sum(case
             when code_t is null then
              '1'
             else
              '0'
           end) as û������,
       sum(case
             when code_t is not null and code_l is null then
              '1'
             else
              '0'
           end) as ��������
  from vip_return0119_result
 group by year
;

select year as ���,
       count(distinct userid) as �����˺���,
       sum(case
             when code_t is not null then
              '1'
             else
              '0'
           end) as ������,
       sum(case
             when code_t is null then
              '1'
             else
              '0'
           end) as û������,
       sum(case
             when code_t is not null and code_l is null then
              '1'
             else
              '0'
           end) as ��������
  from vip3_return0119_result
 group by year
