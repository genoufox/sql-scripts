create table user_zx_result0714
as
select a.account, 
       b.userid �˺�id,
       b.passport �˺�,
       b.truename ����,
       b.mobilephone �ֻ�,
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
       c.pay3 ��3���ֵ,
       c.pay3_cnt ��3���ֵ����,
       d.pay7 ��7���ֵ,
       d.pay7_cnt ��7���ֵ����,
       e.lev ��ɫ�ȼ�,
       f.alias ������,
       trunc(g.last_logout_time) ������½

  from user_zx0714 a

  left join bitask.t_dw_vip_vipinfo b
    on a.account = b.passport
   and b.logtime = trunc(sysdate - 2)

  left join (select userid,
                    sum(pay) / 100 as pay3,
                    count(logtime) as pay3_cnt
               from bitask.t_dw_zx_account_stat_day
              where userid > 33
                and logtime >= to_date('20170708', 'yyyymmdd')
                and logtime < to_date('20170711', 'yyyymmdd')
                and pay > 0
              group by userid) c
    on b.userid = c.userid

  left join (select userid,
                    sum(pay) / 100 as pay7,
                    count(logtime) as pay7_cnt
               from bitask.t_dw_zx_account_stat_day
              where userid > 33
                and logtime >= to_date('20170708', 'yyyymmdd')
                and pay > 0
              group by userid) d
    on b.userid = d.userid

  left join (select userid,
                    roleid,
                    name,
                    150 * type + lev lev,
                    occupation,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��
             
             ) e
    on b.userid = e.userid
   and e.rolelev_rank = 1

  left join (select groupname,
                    name,
                 alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1

  left join bitask.t_dw_zx_account_status g
    on b.userid = g.userid
