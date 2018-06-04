create table vip_sg2_xm1019
as
select a.userid as �˺�id,
       a.passport as �˺�,
       case a.rank
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
       a.mobilephone as �ֻ�,
       a.email as ����,
       a.vamount as ��30���ֵ,
       b.pay_total as �ۼƳ�ֵ,
       c.pay90 as ��3�³�ֵ,
       c.login_cnt as ��3�µ�½����,
       d.lev as ��ɫ�ȼ�,
       d.roleid as ��ɫID,
       d.name as ��ɫ��,
       d.groupname as ������ID,
       e.name as ����������,
       trunc(sysdate - f.last_logout_time) as δ��½����

  from (select userid, passport, rank, mobilephone, email, vamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 1��
           and rank >= 1
           and game = 12) a

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    row_number() over(order by sum(money) desc) as pay_rank
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 12
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                           --  and logtime > to_date('20130601', 'yyyymmdd')
                        and userid > 33
                        and game_id = 12)
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    sum(pay) / 100 as pay90,
                    count(logtime) as login_cnt
               from bitask.t_dw_sg2_account_stat_day
              where userid > 33
                and logtime >= to_char(sysdate - 90)
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    lev,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sg2_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 1��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    version,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_sg2_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join bitask.t_dw_sg2_account_status f
    on a.userid = f.userid;
  
select * from vip_sg2_xm1019
order by ��Ա���� ,��3�³�ֵ desc nulls last
