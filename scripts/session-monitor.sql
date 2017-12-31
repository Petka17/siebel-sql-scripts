-------------------------------------------------
SELECT *
FROM V$SESSION
WHERE USERNAME = 'SADMIN' --AND S.TERMINAL = 'term_name'
-------------------------------------------------
SELECT *
FROM V$SESSION_WAIT
WHERE SID = 1025
-------------------------------------------------
SELECT SID, 'SESSION_TRACE' trace_type
FROM v$session
WHERE sql_trace = 'ENABLED'
-------------------------------------------------
SELECT
    SID,
    SERIAL#,
    SQL_ID,
    PREV_SQL_ID,
    LOGON_TIME
FROM V$SESSION S
WHERE S.USERNAME = 'SADMIN' AND S.MACHINE = 'machine_name' --AND S.TERMINAL = 'term_name'
ORDER BY LOGON_TIME DESC
-------------------------------------------------
SELECT DISTINCT
       TIMESTAMP,
       OPERATION,
       OPTIONS,
       OBJECT_NAME,
       OBJECT_TYPE,
       ACCESS_PREDICATES,
       FILTER_PREDICATES,
       COST,
       CPU_COST
FROM
     V$SQL_PLAN P
     JOIN V$SQL Q ON Q.SQL_ID = P.SQL_ID
WHERE
      P.SQL_ID = '6ma1c835sbwa7'
ORDER BY TIMESTAMP
-------------------------------------------------
SELECT * FROM V$SQL_PLAN_STATISTICS_ALL
SELECT * FROM V$SQL Q WHERE Q.SQL_ID IN ('6ma1c835sbwa7')
SELECT * FROM V$SQL Q WHERE Q.DISK_READS > 1000000
-------------------------------------------------
BEGIN
  SYS.DBMS_SYSTEM.SET_EV(987,6717,10046,12,'');
END;

BEGIN
  SYS.DBMS_SYSTEM.SET_EV(1025,48167,10046,0,'');
END;

BEGIN
  DBMS_MONITOR.SESSION_TRACE_DISABLE(1034, 31284);
  --DBMS_MONITOR.SESSION_TRACE_ENABLE(1034, 31284, TRUE, TRUE);
END;
-------------------------------------------------
SELECT P.PLAN_TABLE_OUTPUT
  FROM V$SESSION S,
       TABLE(DBMS_XPLAN.DISPLAY_CURSOR(S.SQL_ID, S.SQL_CHILD_NUMBER)) P
 WHERE S.SID = 1034
-------------------------------------------------
SELECT * FROM DBA_ENABLED_TRACES;
SELECT * FROM V$CLIENT_STATS
-------------------------------------------------
SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR((SELECT SQL_ID
                                         FROM V$SESSION
                                        WHERE SID = '1034')));
--
