select a.userid �˺�id,
       a.passport �˺�,
       a.Tamount �ۼƳ�ֵ,
       case a.rank
         when 4 then
          '����'
         when 3 then
          '�׽�'
         when 2 then
          '��'
         when 1 then
          '����'
         when 0 then
          '��ʧ'
         else
          '��vip'
       end as ��Ա����,
       case mod(substr(a.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          'δ֪'
       end as �Ա�,
       b.log_cnt "6�µ�½����",
       c.consumption_7 ���7������,
       d.roleid ��ɫid,
       d.lev ��ɫ�ȼ�,
       e.alias ��ɫ������,
       trunc(f.last_logout_time������½, trunc(f.last_pay_time) ����ֵ
       
       from
       
        (select userid,passport, rank, truename, mobilephone, code, tamount
           from bitask.t_dw_vip_vipinfo
          where logtime = trunc��sysdate - 2��
            and game_au = 4
         
         ) a
       
       left join (select userid, count(logtime) as log_cnt
                    from bitask.t_dw_zx_account_status_day
                   where logtime >= to_date('20170601', 'yyyymmdd')
                     and logtime < to_date('20170620', 'yyyymmdd')
                   group by userid) b on a.userid = b.userid
       
       left join (select userid, sum(cash_need) as consumption_7
                    from bitask.t_dw_zx_glog_shoptrade
                   where logtime >= trunc(sysdate) - 7
                   group by userid) c on a.userid = c.userid
       
       left join (select userid,
                         roleid,
                         name rolename,
                         lev,
                         occupation,
                         groupname,
                         row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
                    from bitask.t_dw_zx_gdb_chardata
                   where userid > 33
                     and logtime = to_char(trunc(sysdate) - 2)) d on a.userid = d.userid and d.rolelev_rank = 1
       
       left join (select groupname,
                         name,
                         alias,
                         row_number() over(partition by groupname order by version desc) as rn
                    from bitask.t_dw_zx_dic_serverlist) e on d.groupname = e.groupname and e.rn = 1
       
       left join bitask.t_dw_zx_account_status f on a.userid = f.userid
       
       where f.last_logout_time >= to_date('20150625', 'yyyymmdd')
