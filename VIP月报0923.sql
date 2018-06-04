select game_name,
       game_au,
       week,
       count(userid) as 白金VIP数量,
       count(last_login) as 登陆玩家数,
       trunc((count(userid) - count(last_login)) * 100 / count(userid), 1) as 登陆流失率
  from (select TRUNC(sysdate,'MM')+14 as time,
               b.game_name,
               a.game_au,
               a.userid,
               c.last_login
          from (select t.game_au, t.userid,t.passport,t.rank,t.code,t.mobilephone ,t.telephone
                  from bitask.t_dw_vip_vipinfo t
                 where  t.logtime = to_char(TRUNC(sysdate,'MM')+14)
                   AND t.game_au in (3, 4, 15)) a
                   
                 (select t.game_au, t.userid,t.passport,t.rank
                  from bitask.t_dw_vip_vipinfo t
                 where  t.logtime = to_char(TRUNC(sysdate,'MM')-15)
                   AND t.game_au in (3, 4, 15)) b
                  
        
          join (select distinct bi_aid, game_name, game_ab
                 from bitask.t_dic_aid_mapping) c
            on a.game_au = b.bi_aid
        
          left join (select userid, max(logtime) as last_login
                      from BITASK.t_dw_",var_game,"_account_status_day
                     where logtime <
                           to_date(TRUNC(sysdate, 'D') - 0 * 7 + 1)
                       and logtime >=
                           to_date(TRUNC(sysdate, 'D') - 1 * 7 + 1)
                     group by userid) d
            on a.userid = c.userid
         where b.game_ab = '",var_game,"')

