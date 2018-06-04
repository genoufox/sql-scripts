create table vip3_zx0723_4
as 
select a.userid    as �˺�id,
       a.passport  as �˺�,
       b.pay_total     as ��ֵ,
       b.zoneid    as ������id,
       c.groupname as ������,
       d.roleid    as ��ɫid

  from (select userid, passport
          from bitask.t_dw_vip_vipinfo
         where logtime = to_date�� '20150720', 'yyyymmdd' ��
           and rank >= 3
           and game_au = 4) a

  left join (select userid, zoneid, sum(money) / 100 as pay_total
               from (select userid, money, zoneid
                       from bitask.t_dw_au_billlog
                      where userid > 33
                        and game_id = 4
                     --   and logtime >= to_date('20150122', 'yyyymmdd')
                    --    and logtime < to_date('20150720', 'yyyymmdd') 
                    union all
                    select userid, money, zoneid
                       from bitask.t_dw_au_billlog @racdb
                      where userid > 33
                        and game_id = 4
                        and logtime < to_date('20140307', 'yyyymmdd')                     
                        )
              group by userid, zoneid) b
    on a.userid = b.userid

  left join (select *
               from (select groupname,
                            zoneid,
                            row_number() over(partition by zoneid order by version desc) as rn
                       from bitask.t_dw_zx_dic_serverlist)
              where rn = 1) c
    on b.zoneid = c.zoneid

  left join (select userid,
                    roleid,
                    groupname,
                    row_number() over(partition by userid order by lev desc) as rolelev_rank
               from (select userid,
                            roleid,
                            groupname,
                            type * 150 + lev as lev
                       from bitask.t_dw_zx_gdb_chardata  partition(p20150720)
                 
                     union
                     select userid,
                            roleid,
                            groupname,
                            type * 150 + lev as lev
                       from bitask.t_dw_zx_gdb_chardata_his partition(p201506)
                     
                     )) d
    on a.userid = d.userid
   and c.groupname = d.groupname
   and d.rolelev_rank = 1

;

select a.*, b.������id,b.������, b.��ֵ as ��ɫ��ֵ
  from (select �˺�, sum(��ֵ) as �ܳ�ֵ from vip3_zx0723_4 group by �˺�) a

  left join (select �˺�, ��ֵ, ������id,������, ��ɫid
               from vip3_zx0723_4
              where ��ɫid is not null) b
    on a.�˺� = b.�˺�
