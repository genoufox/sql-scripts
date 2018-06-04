select payflag as ��ֵ����,
       count(userid) as �û���,
       trunc(sum(pay)) as ��ֵ�ܶ�,
       trunc(avg(pay)) as ��ֵ����
  from (select userid,
               pay,
               case
               
                 when pay >= 1000 and pay < 3000 then
                  '����'
                 when pay >= 3000 and pay < 15000 then
                  '��'
                 when pay >= 15000 then
                  '�׽�'
                else '׼VIP'
               
               end as payflag
       
          from (select userid, sum(pwrd_unit) / 100 as pay
                  from bitask.t_dw_dota2_au_billlog
                 where logtime >= to_char(sysdate - 90)
                 group by userid)
         where pay > 0)
 group by payflag
 order by 4
