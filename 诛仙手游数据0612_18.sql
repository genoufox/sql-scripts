create table yy_zxsy_20170612_xq_v13_v18 as  
  select roleid_, pay, 
      CASE 
      WHEN PAY>=50000 AND PAY<100000 THEN 'V13'
      WHEN PAY>=100000 AND PAY<200000 THEN 'V14'
      WHEN PAY>=200000 AND PAY<400000 THEN 'V15'
      WHEN PAY>=400000 AND PAY<600000 THEN 'V16'
      WHEN PAY>=600000 AND PAY<1000000 THEN 'V17'
      WHEN PAY>=1000000  THEN 'V18' end vip from
     (select roleid_, sum(cash_)/100 pay 
        from BITASK.T_000138_LOG_ADDCASH
       where logtime >= date'2016-08-03' and logtime < date'2017-06-13'
         and groupname != 995
         and userid_ like'9_%'
       group by roleid_ having sum(cash_)/100 >= 50000);
       
select * from yy_zxsy_20170612_xq_v13_v18;


create table yy_zxsy_20170612_xq_0601_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170612_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-12' and logtime < date'2017-06-12'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-12' and logtime < date'2017-06-12'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-12' and logtime < date'2017-06-12'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170612_xq_0601_1;


/*create table yy_zxsy_20170608_xq_0601_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0601_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-01'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0601_2; 


create table yy_zxsy_20170608_xq_0601_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0601_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-01' and logtime < date'2017-06-01'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0601_3; 







create table yy_zxsy_20170608_xq_0602_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0602_1;


create table yy_zxsy_20170608_xq_0602_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0602_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-02'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0602_2; 


create table yy_zxsy_20170608_xq_0602_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0602_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-02' and logtime < date'2017-06-02'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0602_3; 





create table yy_zxsy_20170608_xq_0603_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0603_1;


create table yy_zxsy_20170608_xq_0603_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0603_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-03'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0603_2; 


create table yy_zxsy_20170608_xq_0603_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0603_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-03' and logtime < date'2017-06-03'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0603_3; 







create table yy_zxsy_20170608_xq_0604_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0604_1;


create table yy_zxsy_20170608_xq_0604_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0604_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-04'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0604_2; 


create table yy_zxsy_20170608_xq_0604_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0604_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-04' and logtime < date'2017-06-04'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0604_3; 





create table yy_zxsy_20170608_xq_0605_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0605_1;


create table yy_zxsy_20170608_xq_0605_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0605_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-05'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0605_2; 


create table yy_zxsy_20170608_xq_0605_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0605_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-05' and logtime < date'2017-06-05'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0605_3; 







create table yy_zxsy_20170608_xq_0606_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0606_1;


create table yy_zxsy_20170608_xq_0606_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0606_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-06'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0606_2; 


create table yy_zxsy_20170608_xq_0606_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0606_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-06' and logtime < date'2017-06-06'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0606_3; 








create table yy_zxsy_20170608_xq_0607_1 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all from
 (select roleid_, pay payall, vip from yy_zxsy_20170608_xq_v13_v18)a,
 (select roleid_, userid_, groupname, rolename_, yb_, ybbind_ 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1)b,
 (select roleid_, sum(cash_)/100 pay from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_ = b.roleid_(+) and a.roleid_ = c.roleid_(+) and a.roleid_ = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0607_1;


create table yy_zxsy_20170608_xq_0607_2 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       a.roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz from
 (select a1.*, ApprenGuid_ roleid_dz from
   (select * from yy_zxsy_20170608_xq_0607_1)a1,
   (select roleid_, ApprenGuid_ from bitask.t_000138_log_AddProApprentice where logtime < date'2017-06-07'+1 group by roleid_, ApprenGuid_)a2
   where a1.roleid_ = a2.roleid_(+))a,
 (select roleid_, userid_ userid_dz, groupname groupname_dz, rolename_ rolename_dz, viplev_ viplev_dz, yb_ yb_dz, ybbind_ ybbind_dz 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1)b,
 (select roleid_, sum(cash_)/100 pay_dz from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
   group by roleid_)c, 
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_dz
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_dz = b.roleid_(+) and a.roleid_dz = c.roleid_(+) and a.roleid_dz = d.roleid_(+);

select * from yy_zxsy_20170608_xq_0607_2; 


create table yy_zxsy_20170608_xq_0607_3 as
select a.roleid_, payall, vip, userid_, groupname, rolename_, yb_, ybbind_, pay, slot_2_all, 
       roleid_dz, userid_dz, groupname_dz, rolename_dz, viplev_dz, yb_dz, ybbind_dz, pay_dz, slot_2_all_dz,
       roleid_po, userid_po, groupname_po, rolename_po, viplev_po, yb_po, ybbind_po, pay_po, slot_2_all_po from
 (select a1.*, roleid_po from
   (select * from yy_zxsy_20170608_xq_0607_2)a1,
   (select roleid_ roleid_po, marriage_ from bitask.t_000138_log_chardata_base 
     where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1 group by roleid_, marriage_)a2
   where a1.roleid_ = a2.marriage_(+))a,
 (select roleid_, userid_ userid_po, groupname groupname_po, rolename_ rolename_po, viplev_ viplev_po, yb_ yb_po, ybbind_ ybbind_po 
    from bitask.t_000138_log_chardata_base
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1)b,
 (select roleid_, sum(cash_)/100 pay_po from bitask.t_000138_log_addcash 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
   group by roleid_)c,
 (select roleid_, (decode(slot10_,-1,0,substr(slot10_,-2))+decode(slot11_,-1,0,substr(slot11_,-2))+decode(slot12_,-1,0,substr(slot12_,-2))+
                   decode(slot13_,-1,0,substr(slot13_,-2))+decode(slot14_,-1,0,substr(slot14_,-2))+decode(slot15_,-1,0,substr(slot15_,-2))+
                   decode(slot16_,-1,0,substr(slot16_,-2))+decode(slot17_,-1,0,substr(slot17_,-2))+decode(slot18_,-1,0,substr(slot18_,-2))) slot_2_all_po
    from bitask.t_000138_log_chardata_Psychic 
   where logtime >= date'2017-06-07' and logtime < date'2017-06-07'+1
     and slot10_ is not null and slot11_ is not null and slot12_ is not null and slot13_ is not null and slot14_ is not null and slot15_ is not null 
     and slot16_ is not null and slot17_ is not null and slot18_ is not null)d
 where a.roleid_po = b.roleid_(+) and a.roleid_po = c.roleid_(+) and a.roleid_po = d.roleid_(+);
 
select * from yy_zxsy_20170608_xq_0607_3; 
