select *
  from (select game_ab as ��Ŀ,
               game_au ��Ŀ���,
               userid �˺�ID,
               passport �˺�,
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
               tamount �ۻ���ֵ,
               vamount ��1�³�ֵ,
               pay7 ��7���ֵ,
               pay90 ��90���ֵ,
               pay2016 �����ֵ,
               login_cnt_7 ��7���½,
               login_cnt_30 ��30���ֵ,
               consumption_7 ��7������,
               lev ��ɫ�ȼ�,
               roleid ��ɫid,
               rolename ��ɫ����,
               alias ����������,
               f_city_name ��½����,
               first_logout �����½,
               last_logout ����½
        
          from TOTAL_VIP0318
        union all
        select game_ab as ��Ŀ,
               game_au ��Ŀ���,
               userid �˺�ID,
               passport �˺�,
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
               tamount �ۻ���ֵ,
               vamount ��1�³�ֵ,
               pay7 ��7���ֵ,
               pay90 ��90���ֵ,
               pay2016 �����ֵ,
               login_cnt_7 ��7���½,
               login_cnt_30 ��30���½,
               0 as ��7������,
               lev ��ɫ�ȼ�,
               roleid ��ɫid,
               rolename ��ɫ����,
               alias ����������,
               f_city_name ��½����,
               first_logout �����½,
               last_logout ����½
        
          from TOTAL_iwm_VIP0318)

 order by 1, 16 desc
