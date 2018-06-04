select a.userid as �˺�id,
       a.passport as �˺�,
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
       end as ��Ա����,
       a.truename as ����,
       a.mobilephone as �ֻ�,
       a.tamount as �ۼƳ�ֵ,
       b.pay_2015 as "15���ֵ",
       d.lev as ��ɫ�ȼ�,
       d.roleid as ��ɫID,
       d.name as ��ɫ��,
       f.alias as ������,
       e.name as ����,
       TRUNC(g.first_logout_time) as �����½,
       TRUNC(g.last_logout_time) as �����¼

  from (select userid, passport, rank, mobilephone, truename, tamount
          from bitask.t_dw_vip_vipinfo
         where logtime = to_char��sysdate - 2��
           and game_au = 15) a

  left join (select userid, sum(money) / 100 as pay_2015
               from bitask.t_dw_au_billlog
              where userid > 33
                and logtime < to_date('20160101', 'yyyymmdd')
                and logtime > to_date('20150101', 'yyyymmdd')
                and userid > 33
                and game_id = 15
              group by userid) b
    on a.userid = b.userid

  left join (select userid,
                    roleid,
                    name,
                    lev,
                    factionid,
                    groupname,
                    row_number() over(partition by userid order by lev desc, exp desc) as rolelev_rank
               from bitask.t_dw_xa_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��) d
    on a.userid = d.userid
   and d.rolelev_rank = 1

  left join (select distinct fid, name from bitask.t_dw_xa_gdb_faction) e
    on d.factionid = e.fid

  left join (select groupname,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_xa_dic_serverlist) f
    on d.groupname = f.groupname
   and f.rn = 1

  left join bitask.t_dw_xa_account_status g
    on a.userid = g.userid
 order by  b.pay_2015 desc nulls last,a.tamount desc
