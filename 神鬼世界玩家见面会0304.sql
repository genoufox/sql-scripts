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
          null
       end as VIP�ȼ�,
       a.mobilephone as �ֻ�,
       a.tamount as �ۼƳ�ֵ,
       NVL(c.pay_total2, 0) as ��3�³�ֵ,
       d.lev as ��ɫ�ȼ�,
       d.groupname as ������,
       d.roleid as ��ɫID,
       d.name as ��ɫ��,
       e.f_province_name as ���½ʡ��,
       e.f_city_name as ���½����,
       trunc(f.last_logout_time) as ����¼ʱ��

  from (select userid, passport, rank, mobilephone, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char(sysdate - 2)
           and rank >= 1
           and game = 12) a

/* join (select userid,
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
    on a.userid = b.userid]
*/

  left join (select userid, sum(money) / 100 as pay_total2
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 12
                and logtime >= to_char(sysdate - 90)
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    lev,
                    -- factionid,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_sg2_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select c.userid,
                    c.f_province_name,
                    c.f_city_name,
                    c.cnt,
                    row_number() over(partition by c.userid order by c.cnt desc) as rn
               from (select a.userid,
                            b.f_province_name,
                            b.f_city_name,
                            count(*) as cnt
                       from (select userid, ip_num
                               from bitask.t_dw_sg2_glog_accountlogout
                              where logtime >= to_date('20160101', 'yyyymmdd')) a,
                            bitask.t_dic_ipseg_int_db b
                      where a.ip_num between b.f_bip and b.f_eip
                        and b.f_floor = trunc(a.ip_num / 65536, 0)
                      group by a.userid, f_province_name, f_city_name) c) e
    on a.userid = e.userid
   and e.rn = 1
  left join bitask.t_dw_sg2_account_status f
    on a.userid = f.userid
 order by a.rank desc, c.pay_total2 desc nulls last;
