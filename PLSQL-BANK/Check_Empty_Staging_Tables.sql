CREATE OR REPLACE PROCEDURE Check_Empty_Staging_Tables AS
    CURSOR c_staging_tables IS
        SELECT table_name
        FROM user_tables
        WHERE table_name LIKE '%_STG_TBL';
        
    v_row_count INTEGER;
BEGIN
    FOR r_staging_table IN c_staging_tables LOOP
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || r_staging_table.table_name INTO v_row_count;

        IF v_row_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Empty staging table: ' || r_staging_table.table_name);
        END IF;
    END LOOP;
END Check_Empty_Staging_Tables;
/