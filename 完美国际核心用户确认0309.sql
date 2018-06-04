select b.game_ab ��Ŀ,
       a.userid,
       a.passport,
       a.rank �ȼ�,
       a.truename ����,
       a.mobilephone,
       a.code,
       a.email,
       a.tamount �ۼƳ�ֵ,
       a.vamount,
       c.pay_30 "2�³�ֵ",
       /*d.login_cnt ���µ�½����,
       e.lev,
       e.roleid,
       e.name as rolename,
       f.name,
       f.alias,*/
       TRUNC(g.first_logout_time) as �����½,
       TRUNC(g.last_logout_time) as ��ٵ�½

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               code,
               email,
               tamount,
               vamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and rank >= 3) a

  join (select distinct bi_aid, game_ab, game_name from mapping_dy) b
    on a.game_au = b.bi_aid

  left join (select userid, sum(money) / 100 as pay_30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime < to_date('20160301', 'yyyymmdd')
                and logtime >= to_date('20160201', 'yyyymmdd')
                and game_id != 4004
              group by userid) c
    on a.userid = c.userid

  left join (select userid, count(logtime) as login_cnt
               from BITASK.t_dw_iwm_account_stat_day
              where logtime >= sysdate - 30
              group by userid) d
    on a.userid = d.userid

/*  left join (select userid,
                    roleid,
                    name,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_iwm_gdb_chardata
              where userid > 33
                and logtime = to_char(sysdate - 2)) e
    on a.userid = e.userid
   and e.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_iwm_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1 */

  left join bitask.t_dw_iwm_account_status g
    on a.userid = g.userid
 where b.game_ab = 'iwm'
