create table nvip_zx0809
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
       a.pay_cnt ��ֵ����,
       a.pay_max ����ֵ,
       a.pay_min ��С��ֵ,
       a.pay_last �����ֵ,
       a.pay_last �����ֵ,
       --  c.roleid ��ɫid,
       -- c.lev ��ɫ�ȼ�,
       trunc(e.first_logout_time) �����½,
       trunc(e.last_logout_time������½
       
       from
       
       bitask.t_dw_zx_account_status e
       
       join (select userid,
                    sum(money) / 100 as pay_total,
                    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 82))
              AND   game_id = 4
              group by userid) a on e.userid = a.userid
       
       left join (select userid, passport, code, mobilephone, rank
                    from bitask.t_dw_vip_vipinfo
                   where logtime = trunc(TO_DATE(sysdate - 2))) b on e.userid = b.userid
       
       left join user_zx_1 c
       on e.userid  = c.userid
       
       left join user_zx_2 d
       on e.userid  = d.userid
        
       
       where pay_total >= 300 and pay_total < 1000 and b.userid is null
       
       and e.last_logout_time > trunc(sysdate - 7)
       and c.userid is null
       and d.userid is null

