select a.userid �˺�id,
       a.passport �˺�,
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
          '��ʧ'
       end as ��Ա����,
       a.truename ����,
       a.mobilephone �ֻ�,
       a.email ����,
       trunc(a.starttime) ��Ա��ʼʱ��,
       trunc(a.endtime) ��Ա�����ʱ��,
       a.vamount "��90���ֵ",
       a.samount "���������ڳ�ֵ",
       b.month ��ֵ�·ݣ�
       b.pay_cnt ��ֵ����,
       b.pay_month ��ֵ���,
       c.roleid ��ɫid,
       c.rolename ��ɫ����,
       d.alias ������,
       TRUNC(e.first_logout_time) �����½,
       TRUNC(e.last_logout_time) ����¼
  

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               tamount,
               samount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��trunc(sysdate) - 2��
           and game_au = 9
           and rank >= 3) a

  left join (select userid,TRUNC(logtime, 'MM') as month, sum(money) / 100 as pay_month,count(logtime) as pay_cnt
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20151101','yyyymmdd')
                and game_id = 9 
              group by userid,TRUNC(logtime, 'MM')) b
    on a.userid = b.userid

  
left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_mz_gdb_chardata
              where userid > 33
                and logtime = to_char(trunc(sysdate) - 2)) c
    on a.userid = c.userid
   and c.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_mz_dic_serverlist) d
    on c.groupname = d.groupname
   and d.rn = 1

  left join bitask.t_dw_mz_account_status e
    on a.userid = e.userid
    
order by a.userid
