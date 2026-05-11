ALTER SESSION ENABLE PARALLEL DML;

SELECT *
--table_name, inserts, updates, deletes
FROM ALL_tab_modifications
WHERE TABLE_NAME LIKE  '%SCHEDULER%';
SELECT * FROM DBA_HIST_SQLTEXT;
SELECT * FROM V$VERSION;
SELECT * FROM V$SQL_HISTORY;
SELECT * FROM V$SQL;
select * from v$session;


--Filter by Specific Date
SELECT *
FROM my_table
WHERE TRUNC(my_timestamp) = TO_DATE('2024-01-01', 'YYYY-MM-DD');

--Filter by Date Range
SELECT *
FROM my_table
WHERE my_timestamp BETWEEN TO_TIMESTAMP('2024-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
                       AND TO_TIMESTAMP('2024-01-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS');
					   
--Filter by a Specific Time					   
SELECT * FROM my_table WHERE my_timestamp = TO_TIMESTAMP('2024-01-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS');


----Filter last 7 days
SELECT * FROM my_table WHERE my_timestamp >= SYSTIMESTAMP - INTERVAL '7' DAY;

--Filter by Year, Month, or Day
SELECT * FROM my_table WHERE EXTRACT(YEAR FROM my_timestamp) = 2024;

---Filter for Records with Time Portion
SELECT * FROM my_table WHERE TO_CHAR(my_timestamp, 'HH24:MI:SS') BETWEEN '14:00:00' AND '16:00:00';


--Query scheduled Job
SELECT job_name, NEXT_RUN_DATE,enabled, state
FROM user_scheduler_jobs
WHERE job_name  LIKE  '%_DELETE_JOB%';

--Drop particular job
BEGIN
    DBMS_SCHEDULER.drop_job(
        job_name => 'my_daily_package_job',  -- Replace with your job name
        force    => TRUE                      -- Optional: use TRUE to forcefully drop if the job is running
    );
END;
/

---Drop multiple Job at a time
BEGIN
    FOR job IN (
        SELECT job_name
        FROM user_scheduler_jobs
        WHERE job_name LIKE '%_DELETE_JOB'
    ) LOOP
        EXECUTE IMMEDIATE 'BEGIN DBMS_SCHEDULER.DROP_JOB(' || 
                          '''' || job.job_name || '''' || ', force => TRUE); END;';
        DBMS_OUTPUT.PUT_LINE('Dropped job: ' || job.job_name);
    END LOOP;
END;
/


---Create Job  Schedule to run every 6 hours, Monday to Saturday
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'my_job_name',  -- Specify a unique job name
        job_type        => 'PLSQL_BLOCK',   -- Type of job
        job_action      => 'BEGIN my_procedure; END;',  -- PL/SQL block to execute
        start_date      => SYSTIMESTAMP,    -- Start date for the job
        repeat_interval  => 'FREQ=HOURLY; INTERVAL=6; BYDAY=MON,TUE,WED,THU,FRI,SAT',  -- Schedule to run every 6 hours, Monday to Saturday
        enabled         => TRUE               -- Enable the job immediately
    );
END;
/

-----Create Job  Schedule to run every day at 3 am, starting from date
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'my_daily_package_job',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN my_package.my_procedure; END;',
        start_date      => TO_TIMESTAMP('2023-10-26 03:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        repeat_interval => 'FREQ=DAILY; BYHOUR=3; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/