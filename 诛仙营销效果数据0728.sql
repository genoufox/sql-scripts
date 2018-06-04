select a.userid �˺�id,
       a.passport �˺�,
       a.truename ����,
       a.mobilephone �ֻ�,
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
       b.pay7 as "7�ճ�ֵ",
       f.consumption_7 as "7������",
       c.pay "7��7�������ֵ",
       c.pay_last ���һ�γ�ֵ,
       d.name ��ɫ����,
       d.lev ��ɫ�ȼ�,
       e.alias ������,
       trunc(g.last_logout_time) ������½

       
from account_zx0728 t

join (select userid, passport, rank, mobilephone, truename, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
          ) a
on t.account = a.passport
 


left join (select userid, sum(pay) / 100 as pay7
               from bitask.t_dw_zx_account_status_day
              where userid > 33
                and logtime >= trunc(sysdate - 7)
                and pay > 0
              group by userid) b
    on a.userid = b.userid  
    

left join (select userid, sum(money) / 100 as pay,trunc(max(logtime)) as pay_last
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime >= to_date('20170707', 'yyyymmdd')               
                and game_id = 4
              group by userid) c
    on a.userid = c.userid


  left join (select userid,
                    roleid,
                    name,
                    type*150+lev lev,
                    occupation,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��
             
             ) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) e
    on d.groupname = e.groupname
   and e.rn = 1

  left join (select userid, sum(cash_need) as consumption_7
               from bitask.t_dw_zx_glog_shoptrade
              where logtime >= trunc(sysdate) - 7
              group by userid) f
              on a.userid = f.userid

  left join bitask.t_dw_zx_account_status g
    on a.userid = g.userid


