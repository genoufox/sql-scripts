create table vip_nologin0818
as
      select b.game_ab,
             a.game_au,
             a.userid,
             a.passport,
             a.rank,
             a.mobilephone,
             a.email,
             a.tamount,
             c.pay2016,
             d.last_logout_time
        from (select t.game_au,
                     t.userid,
                     t.passport,
                     t.rank,
                     t.mobilephone,
                     t.email,
                     Tamount
                from bitask.t_dw_vip_vipinfo t
               where t.rank > = 1
                 and game_au = 17
                 and t.logtime = trunc(sysdate - 2)) a
      
        join (select distinct bi_aid, game_name, game_ab
                from bitask.t_dic_aid_mapping) b
          on a.game_au = b.bi_aid
      
        left join (select userid, sum(money) / 100 as pay2016
                     from bitask.t_dw_au_billlog
                    where userid > 33
                      and logtime >= to_date('20160101', 'yyyymmdd')
                      and game_id != 4004
                    group by userid) c
          on a.userid = c.userid
      
        left join bitask.T_000073_account_status d
          on a.userid = d.userid
      
       where b.game_ab = 'zxsj'
         and d.last_logout_time > trunc(sysdate - 90)
         and d.last_logout_time < trunc(sysdate - 7)
;

insert into vip_nologin0818
select b.game_ab,
       a.game_au,
       a.userid,
       a.passport,
       a.rank,
       a.mobilephone,
       a.email,
       a.tamount,
       c.pay2016,
       d.last_logout_time
  from (select t.game_au,
               t.userid,
               t.passport,
               t.rank,
               t.mobilephone,
               t.email,
               Tamount
          from bitask.t_dw_vip_vipinfo t
         where t.rank > = 1
           and t.game_au = 17
           and t.logtime = trunc(sysdate - 2)) a

  join (select distinct bi_aid, game_name, game_ab
          from bitask.t_dic_aid_mapping) b
    on a.game_au = b.bi_aid

  left join (select userid, sum(money) / 100 as pay2016
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160101', 'yyyymmdd')
                and game_id != 4004
              group by userid) c
    on a.userid = c.userid

  left join bitask.t_dw_sds_account_status d
    on a.userid = d.userid

 where last_logout_time > trunc(sysdate - 90)
   and d.last_logout_time < trunc(sysdate - 7)

