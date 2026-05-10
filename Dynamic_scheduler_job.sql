DECLARE
    
    CURSOR c_entity_names IS
        SELECT entity_name
        FROM INT_T026_MODULE_ENTITY_MAPPING_TBL
        --WHERE ENTITY_NAME NOT IN ('ORA_CWH_APPROVER','ORA_CWH_TRANSACTION','ORA_RO_STATISTICAL_DATA','ORA_MANAGER');
		WHERE ENTITY_NAME IN ('ORA_CHECKLIST','ORA_CHECKLIST_ALLOCATION','ORA_ASSIGNMENT_DATES');

    v_entity_name VARCHAR2(100); 
    v_job_name VARCHAR2(100);
    v_job_action VARCHAR2(1000);
BEGIN
    
    FOR r IN c_entity_names LOOP
        -- Construct the job name dynamically based on the entity name
        v_job_name := r.entity_name || '_DELETE_JOB';

        -- Construct the dynamic PL/SQL block for job action
        v_job_action := 'BEGIN INT_T026_HRDP_STATIC_PKG.INT_TO26_HRDP_MAIN_PRC(P_ENTITY_NAME => ''' || r.entity_name || ''', P_SCHEMA_NAME => ''HRDP_INTG_USER''); END;';

        -- Create the scheduler job dynamically
        EXECUTE IMMEDIATE '
            BEGIN
                DBMS_SCHEDULER.create_job (
                    job_name        => :job_name,
                    job_type        => ''PLSQL_BLOCK'',
                    job_action      => :job_action,
                    start_date      => TO_TIMESTAMP_TZ(''2025-03-29 1:30:00 UTC'', ''YYYY-MM-DD HH24:MI:SS TZR''),
                    repeat_interval => ''FREQ=DAILY; BYHOUR=1; BYMINUTE=30; BYSECOND=0'',
                    enabled         => TRUE
                );
            END;
        ' USING v_job_name, v_job_action;
    END LOOP;
END;
/

--'FREQ=DAILY; BYHOUR=3; BYMINUTE=0; BYSECOND=0',


DECLARE
    
    CURSOR c_entity_names IS
        SELECT entity_name
        FROM INT_T026_MODULE_ENTITY_MAPPING_TBL
        WHERE ENTITY_NAME IN ('ORA_CWH_APPROVER','ORA_CWH_TRANSACTION','ORA_RO_STATISTICAL_DATA','ORA_ASSIGNMENT_DATES','ORA_CHECKLIST_ALLOCATION','ORA_CHECKLIST','ORA_MANAGER');

    v_entity_name VARCHAR2(100); 
    v_job_name VARCHAR2(100);
    v_job_action VARCHAR2(1000);
BEGIN
    
    FOR r IN c_entity_names LOOP
        -- Construct the job name dynamically based on the entity name
        v_job_name := r.entity_name || '_DELTA_JOB';

        -- Construct the dynamic PL/SQL block for job action
        v_job_action := 'BEGIN INT_T026_HRDP_STATIC_PKG.INT_TO26_HRDP_MAIN_PRC(P_ENTITY_NAME => ''' || r.entity_name || ''', P_SCHEMA_NAME => ''HRDP_INTG_USER''); END;';

        -- Create the scheduler job dynamically
        EXECUTE IMMEDIATE '
            BEGIN
                DBMS_SCHEDULER.create_job (
                    job_name        => :job_name,
                    job_type        => ''PLSQL_BLOCK'',
                    job_action      => :job_action,
                    start_date      => TO_TIMESTAMP_TZ(''2025-03-29 3:00:00 UTC'', ''YYYY-MM-DD HH24:MI:SS TZR''),
                    repeat_interval => ''FREQ=DAILY; BYHOUR=3; BYMINUTE=0; BYSECOND=0'',
                    enabled         => TRUE
                );
            END;
        ' USING v_job_name, v_job_action;
    END LOOP;
END;
/





---Drop job

BEGIN
    FOR job IN (
        SELECT job_name
        FROM user_scheduler_jobs
        WHERE job_name LIKE '%_DELETE_JOB'
		OR job_name LIKE '%_DELTA_JOB'
    ) LOOP
        EXECUTE IMMEDIATE 'BEGIN DBMS_SCHEDULER.DROP_JOB(' || 
                          '''' || job.job_name || '''' || ', force => TRUE); END;';
        DBMS_OUTPUT.PUT_LINE('Dropped job: ' || job.job_name);
    END LOOP;
END;
/


SELECT *
FROM user_scheduler_jobs
WHERE job_name  LIKE  '%_DELTA_JOB%';

SELECT *
FROM user_scheduler_jobs
WHERE job_name  LIKE  '%_DELETE_JOB%';


DECLARE
    
    CURSOR c_entity_names IS
        SELECT entity_name
        FROM INT_T026_MODULE_ENTITY_MAPPING_TBL
        --WHERE ENTITY_NAME NOT IN ('ORA_CWH_APPROVER','ORA_CWH_TRANSACTION','ORA_RO_STATISTICAL_DATA','ORA_MANAGER');
		WHERE ENTITY_NAME IN ('ORA_EMPLOYEE_ASSIGNMENT');

    v_entity_name VARCHAR2(100); 
    v_job_name VARCHAR2(100);
    v_job_action VARCHAR2(1000);
BEGIN
    
    FOR r IN c_entity_names LOOP
        -- Construct the job name dynamically based on the entity name
        v_job_name := r.entity_name || '_DELETE_JOB';

        -- Construct the dynamic PL/SQL block for job action
        v_job_action := 'BEGIN INT_T026_HRDP_STATIC_PKG.INT_TO26_HRDP_MAIN_PRC(P_ENTITY_NAME => ''' || r.entity_name || ''', P_SCHEMA_NAME => ''HRDP_INTG_USER''); END;';

        -- Create the scheduler job dynamically
        EXECUTE IMMEDIATE '
            BEGIN
                DBMS_SCHEDULER.create_job (
                    job_name        => :job_name,
                    job_type        => ''PLSQL_BLOCK'',
                    job_action      => :job_action,
                    start_date      => TO_TIMESTAMP_TZ(''2025-05-21 1:30:00 UTC'', ''YYYY-MM-DD HH24:MI:SS TZR''),
                    repeat_interval => ''FREQ=HOURLY; INTERVAL=8'',
                    enabled         => TRUE
                );
            END;
        ' USING v_job_name, v_job_action;
    END LOOP;
END;
/

--'FREQ=DAILY; BYHOUR=3; BYMINUTE=0; BYSECOND=0',
--'FREQ=HOURLY; INTERVAL=8',

DECLARE
    
    CURSOR c_entity_names IS
        SELECT entity_name
        FROM INT_T026_MODULE_ENTITY_MAPPING_TBL
        WHERE ENTITY_NAME IN ('ORA_EMPLOYEE_ASSIGNMENT','ORA_EMPLOYEE_ASSIGNMENT_HCM');

    v_entity_name VARCHAR2(100); 
    v_job_name VARCHAR2(100);
    v_job_action VARCHAR2(1000);
BEGIN
    
    FOR r IN c_entity_names LOOP
        -- Construct the job name dynamically based on the entity name
        v_job_name := r.entity_name || '_DELTA_JOB';

        -- Construct the dynamic PL/SQL block for job action
        v_job_action := 'BEGIN INT_T026_HRDP_STATIC_PKG.INT_TO26_HRDP_MAIN_PRC(P_ENTITY_NAME => ''' || r.entity_name || ''', P_SCHEMA_NAME => ''HRDP_INTG_USER''); END;';

        -- Create the scheduler job dynamically
        EXECUTE IMMEDIATE '
            BEGIN
                DBMS_SCHEDULER.create_job (
                    job_name        => :job_name,
                    job_type        => ''PLSQL_BLOCK'',
                    job_action      => :job_action,
                    start_date      => TO_TIMESTAMP_TZ(''2025-05-21 3:00:00 UTC'', ''YYYY-MM-DD HH24:MI:SS TZR''),
                    repeat_interval => ''FREQ=HOURLY; INTERVAL=8'',
                    enabled         => TRUE
                );
            END;
        ' USING v_job_name, v_job_action;
    END LOOP;
END;
/





---Drop job

BEGIN
    FOR job IN (
        SELECT job_name
        FROM user_scheduler_jobs WHERE job_name LIKE '%ORA_EMPLOYEE_ASSIGNMENT%'
--        WHERE job_name LIKE '%_DELETE_JOB'
--		OR job_name LIKE '%_DELTA_JOB'
    ) LOOP
        EXECUTE IMMEDIATE 'BEGIN DBMS_SCHEDULER.DROP_JOB(' || 
                          '''' || job.job_name || '''' || ', force => TRUE); END;';
        DBMS_OUTPUT.PUT_LINE('Dropped job: ' || job.job_name);
    END LOOP;
END;
/


SELECT *
FROM user_scheduler_jobs
 WHERE job_name LIKE '%ORA_EMPLOYEE_ASSIGNMENT%'

SELECT *
FROM user_scheduler_jobs
WHERE job_name  LIKE  '%_DELETE_JOB%';






