select *
from
(select 2013 as 定業,userid,pay_2013 as Y2013,pay2014 as Y2014,pay2015 as Y2015,pay2016 as Y2016 from vip_top10000_2013_0418

union all
select 2014 as 定業,userid,0 as Y2013,pay2014 as Y2014,pay2015 as Y2015,pay2016 as Y2016 from vip_top10000_2014_0418

union all
select 2015 as 定業,userid,0 as Y2013,0 as Y2014,pay2015 as Y2015,pay2016 as Y2016 from vip_top10000_2015_0418
)
order by 1, Y2013 desc  nulls last ,Y2014 desc  nulls last ,Y2015 desc  nulls last 
