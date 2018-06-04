                          select b.game_ab,
                                 a.game_au,
                                 a.userid, 
                                 a.rank,
                                 nvl(to_char(d.logtime, 'yymm'),0) as month,
                                 nvl(count(d.logtime),0) as login_cnt,
                                 nvl(sum(d.pay)/100,0) as pay 
                                                                                        
                                 from  bitask.t_dw_vip_vipinfo partition(p20141201) a
                                 
                                 join (select distinct bi_aid, game_name, game_ab from mapping_dy) b
                                 on a.game_au = b.bi_aid
                                 
                                 join (select distinct userid
                                 from BITASK.t_dw_",var_game,"_account_stat_day
                                 where logtime >= to_date('20141201', 'yyyymmdd')
                                 and logtime < to_date('20150101', 'yyyymmdd')
                                 ) c
                                 on a.userid = c.userid
                                 
                                 left join 
                                 from BITASK.t_dw_",var_game,"_account_stat_day d
                                 on a.userid = d.userid                             
                                 where d.logtime >= to_date('20150101', 'yyyymmdd')
                                 and   b.game_ab = '",var_game,"'
                                  
                                 
                                 group by a.userid
                                 
                                 
                                 
                                 
                                 
                                    
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 group by userid, to_char(logtime, 'yymm')) d
                                 on a.userid = d.userid
                                 
                                 left join (select userid,
                                 game_id,
                                 to_char(logtime, 'yymm') as month2,
                                 sum(money) / 100 as pay_month
                                 from bitask.t_dw_au_billlog
                                 where logtime >= to_date('20141001', 'yyyymmdd')
                                 group by userid, game_id, to_char(logtime, 'yymm')) e
                                 on a.userid = e.userid
                                 and d.month = e.month2
                                 where b.game_ab = '",var_game,"' 
                                 order by game_ab,month )
                                 
                                                                 
                                 
                                 (select userid,
                                 to_char(logtime, 'yymm') as month,
                                 count(logtime) as login_cnt
