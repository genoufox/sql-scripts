create table zx_vip3_lost1023
as 
select userid from bitask.t_dw_vip_vipinfo @racdb
where game_id = 4
and  rank >= 3
union 
select userid from bitask.t_dw_vip_vipinfo 
where game_id = 4
and  rank >= 3 ;


select b.userid as �˺�id,
       b.passport as �˺�,
       b.truename as vip����,
       b.mobilephone as vip�ֻ�,
       case b.rank
         when 1 then
          '����'
         when 2 then
          '��'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          '��ʧVIP'
       end as ��Ա����,
       c.pay2015 as "2015��ֵ",
       d.pay_total as ��ֵ�ܶ�,
       e.reg_time as ע��ʱ��,
       trunc(f.last_logout_time) as ����¼ʱ��,
       g.roleid as ��ɫID,
       g.lev as ��ɫ�ȼ�,
       g.occupation as ְҵ����,
       g.groupname as ������id,
       h.alias as ����������

  from zx_vip3_lost1023 a

  join

 (select userid, passport, truename, mobilephone, rank
    from bitask.t_dw_vip_vipinfo
   where logtime = to_date(sysdate - 2)) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay2015
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 4
                        and logtime >= to_date('20150101', 'yyyymmdd'))
              group by userid) c
    on b.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_total
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and game_id = 4
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 4)
              group by userid) d
    on b.userid = d.userid

  left join (select userid, reg_time
               from bitask.t_dw_passport_userinfo
             union
             select userid, reg_time
               from bitask.t_dw_passport_userinfo @racdb) e
    on b.userid = e.userid

  left join bitask.t_dw_zx_account_status f
    on b.userid = f.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    substr(occupation, 1, 2) as occupation,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) g
    on b.userid = g.userid
   and g.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) h
    on g.groupname = h.groupname
   and h.rn = 1

 where f.last_logout_time < sysdate - 15;
 




