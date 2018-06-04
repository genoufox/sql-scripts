select c.pay     as ��ֵ�ܶ�,
       b.Vamount as "��30���ֵ",
       
       case b.rank
         when 1 then
          '����'
         when 2 then
          '�ƽ�'
         when 3 then
          '�׽�'
         when 4 then
          '����'
         else
          '��ʧVIP'
       end as ��Ա����,
       a.userid as �˺�id,
       b.passport as �˺�,
       b.truename as vip����,
       case mod(substr(b.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          null
       end as �Ա�,
       b.telephone as ����,
       b.mobilephone as vip�ֻ�,
       d.groupname as ���µ�½������id,
       e.name as ���µ�½����������,
       d.roleid as ��ɫid,
       d.name as ��ɫ����,
       d.lev as ��ɫ�ȼ�,
       f.f_province_name as ��90�����½����

  from (select userid
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20151101', 'yyyymmdd')
           and game_au = 2
           and rank >= 1
        minus
        select userid
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date('20150101', 'yyyymmdd')
           and game_au = 2
           and rank >= 1) a

  left join bitask.t_dw_vip_vipinfo b
    on a.userid = b.userid
   and b.logtime = to_date('20151101', 'yyyymmdd')

  left join (select userid, sum(money) / 100 as pay
               from (select userid, money
                       from bitask.t_dw_au_billlog @racdb
                      where logtime < to_date('20140307', 'yyyymmdd')
                        and game_id = 2
                     
                     union all
                     select userid, money
                       from bitask.t_dw_au_billlog
                      where game_id = 2)
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    name,
                    groupname,
                    type * 100 + lev as lev,
                    TO_DATE('19700101', 'yyyymmdd') + updatetime / 86400 +
                    TO_NUMBER(SUBSTR(TZ_OFFSET(sessiontimezone), 1, 3)) / 24 as uptime,
                    row_number() over(partition by userid order by updatetime desc) as rank
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_date('20151101', 'yyyymmdd')) d
    on a.userid = d.userid
   and d.rank = 1

  left join (select groupname,
                    name,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join (select c.userid,
                    c.f_province_name,
                    -- c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid, b.f_province_name, count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_wl_glog_accountlogout
                              where logtime >= to_char��sysdate - 90��) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name) c) f
    on a.userid = f.userid
   and f.rn = 1

 order by f_province_name, Vamount desc
