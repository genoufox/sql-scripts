SELECT a.userid  as �˻�id,
       a.account as �˺�,
       a.phone   as �ֻ�,
       a.mail    as ����


  FROM (SELECT USERID,
               REGEXP_REPLACE(ACCOUNT, '^.{3}', '***') ACCOUNT,
               PHONE,
               MAIL,
               ROLE_NAME,
               ROLE_ID,
               ROLE_MAX_LEV,
               GROUPNAME,
               LAST_LOGOUT_TIME,
               PAY_SUM,
               CONSUME_SUM
          FROM FORUSERS.T_QUERY_USER_LABEL_CB
         WHERE MAIL IS NOT NULL
           AND LAST_LOGOUT_TIME >= TO_DATE('2014-04-18', 'yyyy-mm-dd')
           AND LAST_LOGOUT_TIME <= TO_DATE('2015-01-19', 'yyyy-mm-dd')
           AND ROLE_MAX_LEV >= 80
           AND TYPE >= 1
           AND NVL(PAY_SUM, 0) > 100) a

  left join FORUSERS.T_WG_USER_CB b
    on a.userid = b.userid
 where b.userid is null
