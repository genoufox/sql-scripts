
select b.pay_total as "�ۼƳ�ֵ(Ԫ)",
       c.pay_2015 as "2015��ֵ",
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
       a.userid as �˺�id,
       a.passport as �˺�,
       d.lev as ��ɫ�ȼ�,
       d.name as ��ɫ����,
       d.groupname as ������id,
       e.name as ����������,
       a.truename as ����,
       a.address as �Ǽǵ�ַ,
       a.city as �Ǽǳ���,
       a.mobilephone as �ֻ�,
       a.email as ����,
       f.f_province_name as ���½����,
       trunc(g.first_logout_time) as �����½,
       trunc(g.last_logout_time) as ����½

  from (select userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               city,
               address,
               Vamount
          from bitask.t_dw_vip_vipinfo
         where game_au = 9
           and logtime = to_char��sysdate - 2��
           and rank >= 3) a

  left join (select userid,
                    sum(money) / 100 as pay_total
               from (select userid, money
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 9
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140701', 'yyyymmdd')
                        and userid > 33
                        and game_id = 9)
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay_2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 9
                and logtime >= to_date('20150101', 'yyyymmdd')
                and logtime < to_date('20160101', 'yyyymmdd')
             
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    --   roleid,
                    groupname,
                    name,
                    lev,
                    -- factionid,
                    row_number() over(partition by userid order by  lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_mz_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_mz_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join (select c.userid,
                    c.f_province_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_province_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_mz_glog_accountlogout
                              where logtime >= to_char��sysdate - 90��) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name) c) f
    on a.userid = f.userid
   and f.rn = 1

  left join bitask.t_dw_mz_account_status g
    on a.userid = g.userid
   
;

