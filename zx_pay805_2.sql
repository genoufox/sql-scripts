select a.*, b.*
  from ��select year,
       count(userid) as pay_total,
       sum(case
             when pay_cnt = 1 then
              1
             else
              0
           end) as ���θ���,
       sum(case
             when pay_cnt > 1 then
              1
             else
              0
           end) as ��θ���
  from pay0805_2
 group by year�� a

  left join

��select year,
       sum(case
             when pay_cnt <= 3 then
              1
             else
              0
           end) as ���θ���,
       sum(case
             when pay_cnt > 3 and pay_cnt <= 12 then
              1
             else
              0
           end) as ʮ���θ���,
       sum(case
             when pay_cnt > 12 then
              1
             else
              0
           end) as ����ʮ���θ���
  from pay0805_2
 group by year�� b
    on a.year = b.year
