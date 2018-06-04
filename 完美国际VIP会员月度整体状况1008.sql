create table iwm_vip_total_1008 
as
select trunc(last_day(add_months(sysdate, -1))) as time,
       c.game_ab,
       a.game_au,
       b.game_au as game_au_1m,
       a.userid,
       b.userid as userid_1m,
       a.passport,
       a.rank,
       b.rank as rank_1m,
       a.code,
       a.mobilephone,
       a.telephone,
       d.pay7,
       f.pay30_2,
       f.login_cnt,
       f.top_lev,
       --  f.top_lev_roleid, //Ц���޴��ֶ�
       f.onlinetime,
       trunc(sysdate - g.last_logout_time) as nologin_days
  from (select t.game_au,
               t.userid,
               t.passport,
               t.rank,
               t.code,
               t.mobilephone,
               t.telephone
          from bitask.t_dw_vip_vipinfo t
         where t.logtime = trunc(last_day(add_months(sysdate, -1)))
           AND t.game_au = 3) a

  left join (select t.game_au, t.userid, t.passport, t.rank
               from bitask.t_dw_vip_vipinfo t
              where t.logtime =
                    trunc(last_day(add_months(sysdate, - (1 + 1))))
                AND t.game_au = 3) b
    on a.userid = b.userid
   and a.game_au = b.game_au

  join (select distinct bi_aid, game_name, game_ab from mapping_dy) c
    on a.game_au = c.bi_aid

  left join (select userid, game_id, sum(money) / 100 as pay7
               from bitask.t_dw_au_billlog
              where logtime >= trunc(last_day(add_months(sysdate, -1))) - 7
                and logtime < trunc(last_day(add_months(sysdate, -1)))
              group by userid, game_id) d
    on a.userid = d.userid
   and a.game_au = d.game_id

/*       left join (select userid, game_id, sum(money) / 100 as pay30
           from bitask.t_dw_au_billlog
          where logtime >=
                trunc(last_day(add_months(sysdate, -1))) - 30
            and logtime <
                trunc(last_day(add_months(sysdate, -1)))
          group by userid, game_id) e
 on a.userid = e.userid
and a.game_au = e.game_id */ -- ���ô��㷨����������

  left join (select userid,
                    count(logtime) as login_cnt,
                    sum(pay) / 100 as pay30_2,
                    max(nvl(top_level, 0)) as top_lev,
                    trunc(sum(onlinetime) / 3600, 2) as onlinetime
               from BITASK.t_dw_iwm_account_status_day
              where logtime < trunc(last_day(add_months(sysdate, -1)))
                and logtime >= trunc(last_day(add_months(sysdate, -1))) - 30
              group by userid) f
    on a.userid = f.userid

  left join bitask.t_dw_iwm_account_status g
    on a.userid = g.userid;
          


select to_char(time, 'mm') as �·�,
       game_ab as ��Ϸ��Ŀ,
       userid as �˺�id,
       passport as�˺�,
       case rank
         when 1 then
          '����'
         when 2 then
          '�ƽ�'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          '��ʧ'
       end as ��Ա����,
       code as ���֤,
       mobilephone as �ֻ�,
       telephone as �绰,
       case
         when rank >= 1 and rank = rank_1m then
          1
         else
          null
       end as vip����,
       case
         when rank > rank_1m and rank_1m is not null then
          1
         else
          null
       end as vip����,
       case
         when rank < rank_1m and rank_1m is not null then
          1
         else
          null
       end as vip����,
       
       case
         when rank >= 1 and (rank_1m < 1 or rank_1m is null) then
          1
       
         else
          null
       end as vip����,
       case
         when rank < 1 and rank_1m >= 1 then
          1
         else
          null
       end as vip��ʧ,
       NVL(pay7,0) as ��7���ֵ,
       NVL(pay30_2,0) as ��30���ֵ,
       NVL(login_cnt,0) as ��½����,
       NVL(trunc(onlinetime / login_cnt, 2),0) as "ʱ��(Сʱ,ÿ��)",
       nologin_days as δ��¼����

  from iwm_vip_total_1008 
  order by rank desc,nologin_days desc;
