select b.账号id,
       b.账号,
       b.会员级别 会员级别1,
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
       b.累计充值 充值1,
       d.pay_total 充值2,
       b.充值次数 充值次数1,
       d.pay_cnt 充值次数2,
       b.最大充值,
       b.最近充值 最近充值1,
       d.pay_last 最近充值2,
       b.角色等级,
       b.最早登陆,
       b.最后登陆 最后登陆1,
       trunc(e.last_logout_time) 最后登陆2,
       2017 - a.birth 年龄,
       case a.gender
         when 1 then
          '男'
         when 0 then
          '女'
         else
          '其他'
       end as 性别

  from USER_IWM0620 a
  join user_iwm0612 b
    on a.id = b.账号id

  left join (select userid, passport, code, mobilephone, rank
               from bitask.t_dw_vip_vipinfo
              where logtime = trunc(sysdate - 2)) c
    on a.id = c.userid

  left join (select userid,
                    sum(money) / 100 as pay_total,
                    count(money) as pay_cnt,
                    max(money) / 100 as pay_max,
                    min(money) / 100 as pay_min,
                    trunc(max(logtime)) as pay_last,
                    trunc(max(logtime)) as pay_first
               from bitask.t_dw_au_billlog
              where logtime > trunc(to_date(sysdate - 90))
              group by userid) d
    on a.id = d.userid

  left join bitask.t_dw_iwm_account_status e
    on a.id = e.userid
