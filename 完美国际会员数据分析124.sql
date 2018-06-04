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
       2017 - substr(a.code, 7, 4) as ����,
       a.city ����,
       a.province ʡ��,
       a.tamount as "�ۼƳ�ֵ��Ԫ��",
       a.Vamount as "��90���ֵ(Ԫ��",
       c.pay2017 as "�����ֵ��Ԫ��",
       c.server_num ��ֵ����������,
       d.roleid as ��ɫid,
       d.name as ��ɫ����,
       d.lev as ��ɫ�ȼ�,       
       trunc(g.last_logout_time) as ����½ʱ��,
       trunc(g.last_logout_time - g.first_logout_time) as "��Ϸ��������(�죩"
  from
   (select game_au,
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
               city,
               province
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and rank >= 1
           and game_au = 3) a
           
   
  left join (select userid, sum(money) / 100 as pay2017,count(distinct zoneid ) as server_num
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20170101','yyyymmdd')
                and game_id = 3
              group by userid) c
    on a.userid = c.userid
    
  left join (select userid,
                    roleid,
                    name,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_iwm_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1
   
   
  left join bitask.t_dw_iwm_account_status g
    on a.userid = g.userid
    
 order by rank desc, tamount desc nulls last
