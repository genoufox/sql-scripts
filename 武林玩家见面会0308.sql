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
       a.mobilephone as �ֻ��� email as ����,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          'δ֪'
       end as �Ա�,
       a.tamount as �ۼƳ�ֵ,
       b.pay30 as ��30���ֵ,
       c.pay90 as ��90���ֵ,
       d.login_cnt as ��30���½����,
       e.roleid as ��ɫid,
       e.rolename as ��ɫ����,
       e.lev as ��ɫ�ȼ�,
       f.alias as ������,
       g.f_province_name as ���½ʡ��,
       h.first_logout as �����½,
       h.last_logout as ����½

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               code,
               email,
               tamount,
               vamount,
               city
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and rank >= 1
           and game_au = 2) a

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 30
                and game_id = 2
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay90
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= sysdate - 90
                and game_id = 2
              group by userid) c
    on a.userid = c.userid

  left join (select userid, count(logtime) as login_cnt
               from BITASK.t_dw_wl_account_stat_day
              where logtime >= sysdate - 30
              group by userid) d
    on a.userid = d.userid

  left join (select userid,
                    roleid,
                    name,
                    type * 100 + lev as lev,
                    groupname,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) e
    on a.userid = e.userid
   and e.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1

  left join (select c.userid,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_city_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_wl_glog_accountlogout
                              where logtime >= to_char��sysdate - 90��) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_city_name) c) g
    on a.userid = g.userid
   and g.rn = 1

  left join bitask.t_dw_wl_account_status h
    on a.userid = h.userid
