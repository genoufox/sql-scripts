select a.userid �˺�id,
       e.passport �˺�,
       a.datetime ��ֵ����,
       a.money ���ճ�ֵ��,
       case e.rank
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
       e.truename ����,
       e.mobilephone �ֻ�,
       e.email ����,
       e.city ����,
       e.address סַ,
       e.vamount �ۼƳ�ֵ,
       b.alias ��ֵ������,
       c.roleid ��ɫid,
       c.name ��ɫ����,
       c.lev ��ɫ�ȼ�,
       trunc(d.last_logout_time) ���һ�ε�¼

  from (select trunc(logtime) datetime,
               userid,
               sum(money) / 100 as money,
               zoneid
          from bitask.t_dw_au_billlog @racdb
         where logtime < to_date('20140701', 'yyyymmdd')
           and game_id = 2
           and money >= 10000000
         group by trunc(logtime), userid, zoneid
        
        union all
        select trunc(logtime) datetime,
               userid,
               sum(money) / 100 as money,
               zoneid
          from bitask.t_dw_au_billlog
         where game_id = 2
           and money >= 10000000
         group by trunc(logtime), userid, zoneid) a

 
  left join (select zoneid,
                    groupname,
                    name,
                    alias,
                    row_number() over(partition by groupname order by version desc) as rn
               from bitask.t_dw_wl_dic_serverlist) b
    on a.zoneid = b.zoneid
   and b.rn = 1

  left join (select userid, groupname, roleid, name, type * 100 + lev as lev
               from bitask.t_dw_wl_gdb_chardata
              where userid > 33
                and logtime = to_char��sysdate - 2��
            ) c
    on a.userid = c.userid
   and b.groupname = c.groupname

  left join bitask.t_dw_wl_account_status d
    on a.userid = d.userid

 left join (select userid,
                    passport,
                    rank,
                    truename,
                    mobilephone,
                    email,
                    city,
                    address,
                    Vamount
               from bitask.t_dw_vip_vipinfo
              where logtime = to_char��sysdate - 2��) e
    on a.userid = e.userid

 order by a.userid
