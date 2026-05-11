create or replace PROCEDURE print_null_columns(p_table_name IN VARCHAR2) IS
    v_sql        VARCHAR2(1000);
    v_count      NUMBER;
    v_column_name VARCHAR2(100);

    -- Cursor to fetch column names from the specified table
    CURSOR c_columns IS
        SELECT column_name 
        FROM user_tab_columns 
        WHERE table_name = UPPER(p_table_name);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Columns with NULL values in table: ' || p_table_name);

    -- Loop through each column of the table
    FOR r_column IN c_columns LOOP
        v_sql := 'SELECT COUNT(*) FROM ' || p_table_name || ' WHERE ' || r_column.column_name || ' IS NULL';
        EXECUTE IMMEDIATE v_sql INTO v_count;

        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE(r_column.column_name || ' has ' || v_count || ' NULL values.');
        END IF;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END print_null_columns;


set serveroutput on
print_null_columns('p_table_name');
