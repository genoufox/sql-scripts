select payflag as 充值区间,
       count(userid) as 用户数,
       trunc(sum(pay)) as 充值总额,
       trunc(avg(pay) / 12) as 月充值均额
  from (select userid,
               pay,
               case
                 when pay / 12 <= 100 then
                  'rank_100'
                 when pay / 12 <= 300 then
                  'rank_300'
                 when pay / 12 <= 500 then
                  'rank_500'
                 when pay / 12 <= 1000 then
                  'rank_1K'
                 when pay / 12 <= 3000 then
                  'rank_3K'
                 when pay / 12 <= 5000 then
                  'rank_5K'
                 when pay / 12 <= 10000 then
                  'rank_1W'
                 when pay / 12 <= 15000 then
                  'rank_1W5'
                 when pay / 12 <= 20000 then
                  'rank_2W'
                 when pay / 12 <= 30000 then
                  'rank_3W'
                 when pay / 12 <= 40000 then
                  'rank_4W'
                 when pay / 12 <= 50000 then
                  'rank_5W'
               
                 else
                  'rank_5WUP'
               end as payflag
          from (select userid, sum(money) / 100 as pay
                  from (select userid, money
                          from bitask.t_dw_au_billlog @racdb
                         where game_id > 0
                           and game_id <= 18
                           and logtime >= to_date('20130801', 'yyyymmdd')
                           and logtime < to_date('20140307', 'yyyymmdd')
                        
                        union all
                        select userid, money
                          from bitask.t_dw_au_billlog
                         where game_id > 0
                           and game_id <= 18
                           and logtime < to_date('20140801', 'yyyymmdd'))
                 group by userid))
 group by payflag
 order by 4
