select a.passport,
       a.game_name,
       b.game_ab as ��Ŀ,
       b.game_au ��Ŀ���,
       b.userid �˺�ID,
       b.passport �˺�,
       case b.rank
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
       b.truename ����,
       b.code ���֤,
       b.mobilephone �ֻ�,
       b.email ����,
       b.starttime ��Ա��ʼʱ��,
       b.endtime ��Ա����ʱ��,
       b.tamount �ۻ���ֵ,
       b.samount �����ڳ�ֵ,
       b.vamount ��3�³�ֵ,
       b.pay7 ��7���ֵ,
       b.pay30 ��30���ֵ,
       b.pay2016 �����ֵ,
       b.pay2015 ȥ���ֵ,
       b.login_cnt_7 ��7���½,
       b.login_cnt_30 ��30���ֵ,
       b.consumption_7 "��7������(Ԫ��)",
       b.lev ��ɫ�ȼ�,
       b.roleid ��ɫid,
       b.rolename ��ɫ����,
       b.alias ����������,
       b.f_city_name ��½����,
       b.first_logout �����½,
       b.last_logout ����½,
       trunc(b.login_time_7) ��7���½ʱ��

  from vip_focus0321 a

  left join TOTAL_VIP_month_0429 b
    on a.passport = b.passport

 order by b.game_ab, b.passport 
