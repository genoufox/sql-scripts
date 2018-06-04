create table user_zx_082
as
select a.userid �˺�id,
       b.passport �˺�,
       case b.rank
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
       a.pay_total �ۼƳ�ֵ,
       --2017 - substr(b.code, 7, 4) as ����,
       case mod(substr(b.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          'δ֪'
       
       end as �Ա�,
       
       b.mobilephone ��ϵ��ʽ,
       --c.roleid ��ɫid,
       --c.lev ��ɫ�ȼ�,
       trunc(e.first_logout_time) �����½,
       trunc(e.last_logout_time������½
       
       from
       
       bitask.t_dw_zx_account_status e
       
       join (select userid,
                    sum(money) / 100 as pay_total
                    --,
                /*    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first */
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 82))
                and logtime < trunc(to_date(sysdate - 0))
              group by userid) a 
              on e.userid = a.userid
       
       left join (select userid, passport, code, mobilephone, rank
                    from bitask.t_dw_vip_vipinfo
                   where logtime = trunc(TO_DATE(sysdate - 2))) b 
                   on e.userid = b.userid
       
       /*       left join (select userid,
             roleid,
             name rolename,
             lev,
             occupation,
             groupname,
             row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
        from bitask.t_dw_zx_gdb_chardata
       where userid > 33
         and logtime = trunc(sysdate) - 2) c 
         on e.userid = c.userid 
         and c.rolelev_rank = 1 */
       
       where pay_total >= 300 and pay_total < 1000 
       and b.rank is null 
       and e.last_logout_time > trunc(sysdate - 7)
