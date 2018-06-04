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
       a.truename as ����,
       a.mobilephone as �ֻ�,
       a.telephone as ����,
       a.email as ����,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          'δ֪'
       end as �Ա�,
       a.tamount as �ۼƳ�ֵ,
       a.Vamount as ��90���ֵ,
       b.pay30 as ��30���ֵ,
       c.pay2017 as "�����ֵ",
       d.roleid as ��ɫid,
       d.name as ��ɫ����,
       d.lev as ��ɫ�ȼ�,
       e.alias as ������,
       f.f_city_name as ���½����,
       trunc(g.first_logout_time) as �����½,
       trunc(g.last_logout_time) as ����½
  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               telephone,
               code,
               email,
               tamount,
               vamount,
               city
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and rank >= 1
           and game_au = 6) a
  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 30)
                and game_id = 6
              group by userid) b
    on a.userid = b.userid
  left join (select userid, sum(money) / 100 as pay2017
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20170101','yyyymmdd')
                and game_id = 6
              group by userid) c
    on a.userid = c.userid
  left join (select userid,
                    roleid,
                    name,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_rw_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1
  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_rw_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1
  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_rw_glog_accountlogout
                              where logtime >= to_char��sysdate - 30��) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) f
    on a.userid = f.userid
   and f.rn = 1
  left join bitask.t_dw_rw_account_status g
    on a.userid = g.userid
 order by rank desc, tamount desc nulls last
