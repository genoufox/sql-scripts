select game_ab,
       game_au ��Ŀ���,
       b.userid �˺�id,
       passport,
       case rank
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
       truename ����,
       mobilephone �ֻ�,
       code ���֤,
       email ����,
       trunc(starttime) as ��Ա��ʼʱ��,
       endtime ��Ա����ʱ��,
       -- tamount �ۻ���ֵ,
       pay30         ��1�³�ֵ,
       pay7          ��7���ֵ,
       vamount       ��90���ֵ,
       login_cnt_7   ��7���½,
       login_cnt_30  ��30���½,
       consumption_7 ��7������,
       first_logout  �����½,
       last_logout   ����½,
       logtime_7     ��7���½ʱ��

  from SuperVIP0505 a

  join TOTAL_VIP_weekly_0422 b
    on a.userid = b.userid

 order by game_ab
