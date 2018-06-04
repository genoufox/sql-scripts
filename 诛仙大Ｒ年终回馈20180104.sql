create table vip3_zx20180103
as
select a.userid as �˺�id,
       a.passport as �˺�,
       a.truename as ����,
       case a.rank
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
       end as VIP�ȼ�,
       a.mobilephone as �ֻ�,
       a.telephone as �绰,
       a.tamount as �ۼƳ�ֵ,
       b.pay_90 as "��3�³�ֵ(Ԫ)",
       c.pay_180 as "��6�³�ֵ(Ԫ)",
       d.pay_2017 as "2017���ֵ(Ԫ)",
       --     d.log_num          as ��¼����,
       --     d.onlinetime_month as "��¼��ʱ��(Сʱ)",
      -- e.roleid as ��ɫid,
      -- e.name as ��ɫ����,
       b.top_lev as ��ɫ��ߵȼ�,
      -- f.alias as ����������,
       trunc(g.last_logout_time) as ���һ�ε�¼,
       trunc(sysdate - g.first_logout_time) as ��Ϸ����


  from (select userid, passport, truename, rank, mobilephone, telephone,tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char(sysdate - 2)
           and rank >= 3
           and game_au = 4) a

  left join (select userid, sum(pay) / 100 as pay_90,max(top_level) as top_lev
               from bitask.t_dw_zx_account_stat_day
              where userid > 33
                and logtime >= to_char(sysdate - 90)
              group by userid) b
    on a.userid = b.userid

  left join (select userid, sum(money) / 100 as pay_180
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 4
                and logtime >= to_char(sysdate - 180)
              group by userid) c
    on a.userid = c.userid

  left join (select userid, sum(money) / 100 as pay_2017
               from bitask.t_dw_au_billlog
              where userid > 33
                and game_id = 4
                and logtime >= to_date('20170101', 'yyyymmdd')
              group by userid) d
    on a.userid = d.userid

/*  left join (select userid,
                    roleid,
                    groupname,
                    name,
                    type * 150 + lev as lev,
                    -- factionid,
                    row_number() over(partition by userid order by type desc, lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_zx_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) e
    on a.userid = e.userid
   and e.rolelev_rank = 1

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_zx_dic_serverlist) f
    on e.groupname = f.groupname
   and f.rn = 1 */

  left join bitask.t_dw_zx_account_status g
    on a.userid = g.userid



