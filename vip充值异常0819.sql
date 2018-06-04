select d.pay as ≥‰÷µ◊‹∂Ó, c.passport as ’À∫≈, c.userid as ’À∫≈id
  from bitask.t_dw_vip_vipinfo c
  left join (select userid, sum(money) / 100 as pay
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and game_id = 2
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 2)
              group by userid) d
    on c.userid = d.userid
 where c.passport = 'niurenbang99'
