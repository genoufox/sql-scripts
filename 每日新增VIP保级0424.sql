create table VIP_EDM0514_2
as
 select a.datetime ,
       a.userid ,
       b.passport ,
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
       end as rank,
       a.pay_total ,
       /*   a.pay_cnt ��ֵ����,
       a.pay_max ����ֵ,
       a.pay_min ��С��ֵ,
       a.pay_last �����ֵ,
       a.pay_last �����ֵ,*/
       /* 2017 - substr(b.code, 7, 4) as ����,
       case mod(substr(b.code, -2, 1), 2)
         when 1 then
          '��'
         when 0 then
          'Ů'
         else
          "δ֪"
       end as �Ա�,*/
       
       b.mobilephone 

   from (select trunc(sysdate - 2) datetime,
               userid,
               sum(money) / 100 as pay_total /*,
                               count(logtime) as pay_cnt,
                               max(money) / 100 as pay_max,
                               min(money) / 100 as pay_min,
                               trunc(max(logtime)) as pay_last,
                               trunc(max(logtime)) as pay_first */
          from bitask.t_dw_au_billlog
         where logtime > trunc(to_date(sysdate - 174))
           and logtime < trunc(to_date(sysdate - 2))
           and game_id != 4004
           and userid > 32
          /* and userid not in 
           (select distinct userid from VIP_EDM0423_2 
             where datetime >= to_date('20180422','yyyymmdd'))*/
         group by userid) a

    left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(TO_DATE(sysdate - 2)) )b
    on a.userid = b.userid
   where a.pay_total >= 1200;   
