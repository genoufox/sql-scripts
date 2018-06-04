select payflag as ��ֵ����,
       count(userid) as �û���,
       trunc(sum(pay)) as ��ֵ�ܶ�,
       trunc(avg(pay)/12) as �³�ֵ����
  from (select userid,
               pay,
               case
                 when pay / 12 <= 100 then
                  '100����'
                 when pay / 12 <= 300 then
                  '100~300'
                 when pay / 12 <= 500 then
                  '300~500'
                 when pay / 12 <= 1000 then
                  '500~1ǧ'
                 when pay / 12 <= 3000 then
                  '1ǧ~3ǧ'
                 when pay / 12 <= 5000 then
                  '3ǧ~5ǧ'
                 when pay / 12 <= 10000 then
                  '5ǧ~1W'
                 when pay / 12 <= 15000 then
                  '1W~1W5'
                 when pay / 12 <= 20000 then
                  '1W5~2W'
                 when pay / 12 <= 30000 then
                  '2W~3W'
                 when pay / 12 <= 40000 then
                  '3W~_4W'
                 when pay / 12 <= 50000 then
                  '4W~5W'
               
                 else
                  '5W����'
               end as payflag
          from (select userid, sum(money) / 100 as pay
                  from bitask.t_dw_au_billlog
                 where logtime >= to_date('20140801', 'yyyymmdd')
                   and logtime < to_date('20150801', 'yyyymmdd')
                 group by userid))
group by rollup(payflag)
order by 4
