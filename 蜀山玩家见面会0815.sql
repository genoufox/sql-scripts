create table sh0815
as

select a.game_au ��ĿID,
       a.userid �˺�id,
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
       a.mobilephone �绰,
       a.code ���֤,
       a.email ����,
       trunc(a.starttime) ��Ա��ʼʱ��,
       trunc(a.endtime) ��Ա�����ʱ��,
       c.pay30 ��1�³�ֵ,
       d.pay90 ��3�³�ֵ,
       e.pay_total �ۼƳ�ֵ,  
       j.roleid_ ��ɫid,
       j.name_ ��ɫ��,
       j.lev_ ��ɫ�ȼ�,
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
               code,
               email,
               tamount,
               Samount,
               Vamount,
               starttime,
               endtime
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��trunc(sysdate) - 2��
           and game_au = 73
           and rank >= 1) a

  left join (select userid, sum(money) / 100 as pay30
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate) - 30
                and game_id =73
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay90
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= trunc(sysdate - 90)
               
                and game_id =73
              group by userid) d
    on a.userid = d.userid

  left join (select userid, sum(money) / 100 as pay_total
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20160620', 'yyyymmdd')
                and game_id =73
              group by userid) e
    on a.userid = e.userid

  left join (select userid_,
                    roleid_,
                    name_,
                    lev_,
                    groupname,
                    row_number() over(partition by userid_ order by lev_ desc, exp_) as rolelev_rank
               from bitask.t_000073_log_chardata
              where userid_ > 33) j
    on a.userid = j.userid_
   and j.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.T_000073_LOG_SERVERLIST) k
    on j.groupname = k.groupname
   and k.rn = 1

  left join bitask.T_000073_account_status l
    on a.userid = l.userid
