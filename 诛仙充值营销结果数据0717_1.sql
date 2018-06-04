select a.账号id,
       a.账号,
       a.会员级别 会员级别1,
       case c.rank
         when 4 then
          '终身'
         when 3 then
          '白金'
         when 2 then
          '金卡'
         when 1 then
          '银卡'
         when 0 then
          '流失'
         else
          '非vip'
       end as 会员级别2,
       a.累计充值 充值1,
       d.pay_total - a.累计充值 新增充值,
       a.充值次数 充值次数1,
       d.pay_cnt - a.充值次数 新增充值次数,
       a.最大充值,
       a.最近充值 最近充值1,
       d.pay_last - a.最近充值 最近充值2,
       a.角色等级,
       a.最早登陆,
       a.最后登陆 最后登陆1,
       trunc(e.last_logout_time) - a.最后登陆 最后登陆2

  from NVIP_ZX0707 a
  join sms_zx0717 b
    on a.账号id = b.userid

  left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(sysdate - 2)) c
    on a.账号id = c.userid

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
    on a.账号id = d.userid

  left join bitask.t_dw_zx_account_status e
    on a.账号id = e.userid
