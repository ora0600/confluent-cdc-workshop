# Queries in Oracle DB for analysis

## Hourly Archive generation


connect sys/confluent123@XE as sysdba

```sql
--===========================================================================
--Hourly Archive generation from The last week
--===========================================================================
set lines 300 pages 300
set num 6 
col Day for a9
SELECT 
  TRUNC(COMPLETION_TIME), THREAD#, TO_CHAR(COMPLETION_TIME, 'Day') Day,
  COUNT(1) "Count Files",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '00', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H0",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '01', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H1",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '02', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H2",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '03', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H3",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '04', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H4",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '05', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H5",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '06', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H6",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '07', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H7",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '08', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H8",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '09', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H9",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '10', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H10",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '11', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H11",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '12', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H12",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '13', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H13",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '14', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H14",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '15', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H15",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '16', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H16",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '17', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H17",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '18', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H18",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '19', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H19",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '20', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H20",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '21', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H21",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '22', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H22",
  ROUND(SUM(DECODE(TO_CHAR(COMPLETION_TIME, 'HH24'), '23', ((BLOCKS * BLOCK_SIZE) / 1024 / 1024), 0))) "H23",
  ROUND(SUM(BLOCKS * BLOCK_SIZE) / 1024 / 1024) "Total Size (MB)"
FROM V$ARCHIVED_LOG 
WHERE COMPLETION_TIME BETWEEN trunc(sysdate-7) AND trunc(sysdate)
GROUP BY TRUNC(COMPLETION_TIME), THREAD#, TO_CHAR (COMPLETION_TIME, 'Day')
ORDER BY 1;
```

## Monitoring

connect sys/confluent123@XEPDB1 as sysdba

```sql
-- Monitoring 1
SELECT * FROM
(SELECT status,inst_id,sid,SESSION_SERIAL# as Serial,username,sql_id,SQL_PLAN_HASH_VALUE,MODULE,program,
       TO_CHAR(sql_exec_start,'dd-mon-yyyy hh24:mi:ss') AS sql_exec_start,
       ROUND(elapsed_time/1000000)                      AS "Elapsed (s)",
       ROUND(cpu_time    /1000000)                      AS "CPU (s)",
       substr(sql_text,1,30) sql_text
  FROM gv$sql_monitor where status='EXECUTING' and module not like '%emagent%'
  ORDER BY sql_exec_start  desc
);

-- Monitoring 2
select SID,  MESSAGE, ELAPSED_SECONDS, TIME_REMAINING , 
       (SOFAR/nvl(nullif(TOTALWORK,0),1))*100 pct,
       to_char(START_TIME,'DD-MON-YY HH24:MI') Start_tim,
       to_char(SQL_EXEC_START,'DD-MON-YY HH24:MI') EXEC_TIM,
       to_char(sysdate+(TIME_REMAINING/(24*60*60)),'HH24:MI') tim,
       to_char(sysdate,'HH24:MI') sysdt , 
       sql_id 
 from v$session_longops order by ELAPSED_SECONDS desc;
```

# Redos etc.

```sql
-- You can view the redo_buffer_allocation_retries in V$SYSSTAT to see if your redo log files are too small.
select * from V$SYSSTAT where name = 'redo_buffer_allocation_retries';

-- shows you the time between log switches
select  b.recid,
        to_char(b.first_time, 'dd-mon-yy hh:mi:ss') start_time, 
        a.recid,
        to_char(a.first_time, 'dd-mon-yy hh:mi:ss') end_time,
        round(((a.first_time-b.first_time)*25)*60,2) minutes
from    v$log_history a, v$log_history b
where   a.recid = b.recid + 1
order   by a.first_time asc;

-- log siwtches
SELECT
    substr(to_char(first_time, 'DD-MON-YYYY HH24:MI:SS'),13, 2) as Hour ,
    substr(to_char(first_time, 'DD-MON-YYYY HH24:MI:SS'),1, 12) as Day ,
    count(1) as Nb_switch_per_hour
FROM (
    SELECT DISTINCT CAST(FIRST_TIME AS VARCHAR2(20)), FIRST_TIME, FIRST_CHANGE#, NEXT_TIME, NEXT_CHANGE#,BLOCKS, BLOCK_SIZE,BLOCKS*BLOCK_SIZE AS BLOCK_TOT, ARCHIVED, END_OF_REDO, 1 AS Nb_redo
    FROM v$archived_log
    WHERE CAST(FIRST_TIME AS VARCHAR2(20)) LIKE '%1%-APR-23%'
)
GROUP BY
    substr(to_char(first_time, 'DD-MON-YYYY HH24:MI:SS'),13, 2),
    substr(to_char(first_time, 'DD-MON-YYYY HH24:MI:SS'),1, 12)
    --WHERE ROWNUM < 10
ORDER BY
    Hour ASC;


--current size of redolog files
SELECT
   a.group#,
   substr(b.member,1,30) name,
   a.members,
   a.bytes/1024/1024 as MB,
   a.status
FROM
   v$log     a,
   v$logfile b
WHERE
   a.group# = b.group#;
   
-- resource manager
select * from DBA_RSRC_CONSUMER_GROUP_PRIVS ;
-- connect as cdc c onnector user and check privs
select * from USER_RSRC_CONSUMER_GROUP_PRIVS ;


-- sum of “block_tot” = SUM ( BLOCKS * BLOCK_SIZE )
SELECT CAST(FIRST_TIME AS VARCHAR2(20)), FIRST_TIME, FIRST_CHANGE#, NEXT_TIME, NEXT_CHANGE#,BLOCKS, BLOCK_SIZE,BLOCKS*BLOCK_SIZE AS BLOCK_TOT, ARCHIVED, END_OF_REDO, 1 AS Nb_redo FROM v$archived_log;



--Customer list of archive log
SELECT MIN(LOGFILE.MEMBER) AS NAME, LOG.THREAD#, LOG.SEQUENCE# SEQUENCE#, TO_CHAR(LOG.FIRST_CHANGE#) FIRST_CHANGE#, TO_CHAR(LOG.NEXT_CHANGE#) NEXT_CHANGE#,
LOG.STATUS STATUS, 'NO' AS DICTIONARY_BEGIN, 'ONLINE' AS TYPE, LOGFILE.GROUP# AS GROUP#, LOG.BYTES / 1024 / 1024 LOG_FILE_SIZE FROM V$LOG LOG INNER JOIN V$LOGFILE
LOGFILE ON (LOG.GROUP# = LOGFILE.GROUP#) LEFT OUTER JOIN V$ARCHIVED_LOG ARCHIVED_LOG ON (LOG.THREAD# = ARCHIVED_LOG.THREAD# AND LOG.SEQUENCE# =
ARCHIVED_LOG.SEQUENCE# AND ARCHIVED_LOG.STANDBY_DEST = 'NO') WHERE LOG.NEXT_CHANGE# > 0 AND (ARCHIVED_LOG.STATUS IS NULL OR ARCHIVED_LOG.STATUS <> 'A') GROUP BY
LOG.THREAD#, LOG.SEQUENCE#, LOG.FIRST_CHANGE#, LOG.NEXT_CHANGE#, LOG.STATUS, LOGFILE.GROUP#, LOG.BYTES UNION SELECT A.NAME, A.THREAD#, A.SEQUENCE#,
TO_CHAR(A.FIRST_CHANGE#) FIRST_CHANGE#, TO_CHAR(A.NEXT_CHANGE#) NEXT_CHANGE#, A.STATUS, A.DICTIONARY_BEGIN, 'ARCHIVE' AS TYPE, NULL AS GROUP#, A.BLOCKS *
A.BLOCK_SIZE / 1024 / 1024 AS LOG_FILE_SIZE FROM V$ARCHIVED_LOG A WHERE A.NAME IS NOT NULL AND A.ARCHIVED = 'YES' AND A.STATUS = 'A' AND A.NEXT_CHANGE# > (SELECT
TO_CHAR(MIN(FIRST_CHANGE#)) AS earliest_timestamp FROM V$ARCHIVED_LOG WHERE STATUS = 'A') AND A.STANDBY_DEST = 'NO' ORDER BY 3;
```

open Transactions and locked transactions
connect sys@XEPDB1 as sysdba

```sql
-- Open Transactions = Active
select s.sid,
       s.serial#,
       s.username, 
       s.program, 
       s.status as sessionstatus, 
       t.status as transactionstatus,
       t.name, t.START_SCN, 
       t.START_TIME,
       to_char(sysdate,'MM/DD/YY HH24:MI:SS') as current_time,
       o.sql_text
  from v$session s, v$transaction t, v$open_cursor o 
 where s.taddr = t.addr
   and t.status='ACTIVE'
   and o.sql_id = s.prev_sql_id;
   
-- locked transaction
select 
   lo.session_id, s.serial#, s.username, s.program,  
   o.object_name as Objekt, l.block as blocking_others, l.request, l.TYPE, l.ctime as time_in_sec  
from 
   v$locked_object lo, all_objects o, v$session s, v$lock l 
where 
   lo.object_id = o.object_id 
   and lo.session_id =  s.sid
   and lo.session_id = l.sid
order by 
   lo.session_id;
```

back to [Deployment-Steps Overview](../README.md) or back do [Oracle](README.md)
