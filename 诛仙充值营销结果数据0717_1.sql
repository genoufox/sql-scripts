select a.�˺�id,
       a.�˺�,
       a.��Ա���� ��Ա����1,
       case c.rank
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
       end as ��Ա����2,
       a.�ۼƳ�ֵ ��ֵ1,
       d.pay_total - a.�ۼƳ�ֵ ������ֵ,
       a.��ֵ���� ��ֵ����1,
       d.pay_cnt - a.��ֵ���� ������ֵ����,
       a.����ֵ,
       a.�����ֵ �����ֵ1,
       d.pay_last - a.�����ֵ �����ֵ2,
       a.��ɫ�ȼ�,
       a.�����½,
       a.����½ ����½1,
       trunc(e.last_logout_time) - a.����½ ����½2

  from NVIP_ZX0707 a
  join sms_zx0717 b
    on a.�˺�id = b.userid

  left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(sysdate - 2)) c
    on a.�˺�id = c.userid

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 92))
                and logtime < to_date('20170715', 'yyyymmdd')
              group by userid) d
    on a.�˺�id = d.userid

  left join bitask.t_dw_zx_account_status e
    on a.�˺�id = e.userid
