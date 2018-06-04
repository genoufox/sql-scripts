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
        trunc(h.first_logout_time) as �����½,
       trunc(h.last_logout_time) as ����½
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
           and game_au = 3) a
           
  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 30)
                and game_id = 3
              group by userid) b
    on a.userid = b.userid
    
  left join (select userid, sum(money) / 100 as pay2017
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
   
  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_iwm_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1
   
   
  left join bitask.t_dw_iwm_account_status h
    on a.userid = h.userid
    
 order by rank desc, tamount desc nulls last
