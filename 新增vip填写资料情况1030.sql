create table vip_fyp20151030
as
select a.userid, d.rank,d.game_au, b.time1, c.time2
  from (select userid
          from bitask.t_dw_vip_vipinfo
          where logtime = to_date('20151015', 'yyyymmdd')
        minus
        select userid
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20150930', 'yyyymmdd')) a
  left join (select userid, min(logtime) time1
               from bitask.t_dw_vip_vipinfo
              where logtime > to_date('20150930', 'yyyymmdd')
                and logtime <= to_date('20151015', 'yyyymmdd')
                and telephone is null
              group by userid) b
    on a.userid = b.userid
  left join (select userid, min(logtime) time2
               from bitask.t_dw_vip_vipinfo
              where logtime > to_date('20150930', 'yyyymmdd')
                and telephone is not null
              group by userid) c
    on a.userid = c.userid
  join (select userid, rank,game_au
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20151015', 'yyyymmdd')) d
    on a.userid = d.userid;


select  game_name,
        case rank
         when 1 then
          '����'
         when 2 then
          '��'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          null
       end as ��Ա����, 
       count(userid) as ��Ա����,
       sum(case
             when time2 is not null then
              1
             else
              0
           end) as ��д����,
       sum(case
             when time2 is null then
              1
             else
              0
           end) as ��δ��д����,
       sum(case
             when time1 is  null then
              1
             else
              0
           end) as ������д,
       sum(case
             when time2 is not null and time1 is not null then
              time2 - time1
             else
              0
           end) as "��д�ۼƺ�ʱ���죩"
  from (select b.game_name, a.*
          from vip_fyp20151030 a
          join (select distinct bi_aid, game_name from mapping_dy) b
            on a.game_au = b.bi_aid
         where a.rank >= 1)

group by game_name, rank
order by game_name, rank desc
