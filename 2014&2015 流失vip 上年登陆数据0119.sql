select year as ���,
       count(distinct userid) as �����˺���,
       sum(case
             when login_cnt is null then
              '1'
             else
              '0'
           end) as δ��½,
       sum(case
             when login_cnt >= 1 and login_cnt < 5 then
              '1'
             else
              '0'
           end) as ��½4������,
       sum(case
             when login_cnt >= 5 then
              '1'
             else
              '0'
           end) as ��½5������
  from vip_return0119_result
 group by year
;

select year as ���,
       count(distinct userid) as �����˺���,
       sum(case
             when login_cnt is null then
              '1'
             else
              '0'
           end) as δ��½,
       sum(case
             when login_cnt >= 1 and login_cnt < 5 then
              '1'
             else
              '0'
           end) as ��½4������,
       sum(case
             when login_cnt >= 5 then
              '1'
             else
              '0'
           end) as ��½5������
  from vip3_return0119_result
 group by year
;
