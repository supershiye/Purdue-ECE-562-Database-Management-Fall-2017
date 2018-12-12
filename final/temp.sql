DECLARE
    CURSOR t_cur IS SELECT DISTINCT
        pa.p_visit_number
                    FROM
        patient pa
                    WHERE
        pa.pid = 4;
    pvn     NUMBER;
BEGIN
    OPEN t_cur;
    LOOP
        FETCH t_cur INTO pvn;
        EXIT WHEN t_cur%notfound;
dbms_output.put_line(pvn);
        CLOSE t_cur;
    END LOOP;
END;
/