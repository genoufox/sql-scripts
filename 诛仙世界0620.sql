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
       c.pay ��ʷ��ֵ,
       j.roleid ��ɫid,
       j.rolename ��ɫ��,
       j.lev ��ɫ�ȼ�,
       j.groupname ������ID,
       k.alias ����������,
       TRUNC(l.first_logout_time) �����½,
       TRUNC(l.last_logout_time) ����¼

  from (select game_au,
               userid,
               passport,
               rank,
               truename,
               mobilephone,
               email,
               vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��trunc(sysdate) - 2��
           and game_au = 15
           and rank = 0) a

  left join (select userid, sum(money) / 100 as pay
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 73
              group by userid) c
    on a.userid = c.userid

  left join (select userid,
                    roleid,
                    name rolename,
                    lev,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zxsj_gdb_chardata
              where userid > 33) j
    on a.userid = j.userid
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zxsj_dic_serverlist) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join bitask.t_dw_zxsj_account_status l
    on a.userid = l.userid

 where pay >= 500

 order by c.pay desc nulls last
