select year as ���,
       game_name as ��Ϸ,
       userid as �˺�id,
       passport as �˺�,
       trunc(reg_time) as ע��ʱ��,
       firstlogin as ��һ�ε�½,
       lastlogin as ����½,
       truename as ����,
       code ������as ���֤��,
       login_cnt as ��½����,
       total_time as ��Ϸʱ��,
       pay_2013 as �����ֵ,
       pay2014 as �����ֵ
  from (select 2013 year, t.*
          from top1000_2013_new_0121 t
        union
        select 2014 year, t.*
          from top1000_2014_new_0121 t
        union
        select 2015 year, t.*
          from top1000_2015_new_0121 t)
 order by year, pay_2013 desc
