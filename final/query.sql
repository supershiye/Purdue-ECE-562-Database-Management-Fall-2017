rem ee 562 Final
rem Ye Shi
rem shi349

-- Query

EXEC dbms_output.put_line('a)');

SELECT DISTINCT
    px.treatment,
    px.pid
FROM
    patient px
ORDER BY
    px.treatment;

EXEC dbms_output.put_line('b)');

SELECT
    ddx.d_name
FROM
    (
        SELECT
            dx.d_name,
            COUNT(*) AS cnt
        FROM
            doctor dx
        GROUP BY
            dx.d_name
    ) ddx,
    (
        SELECT
            dx.d_name,
            COUNT(*) AS cnt
        FROM
            doctor dx
        GROUP BY
            dx.d_name
    ) gdx
GROUP BY
    ddx.d_name,
    ddx.cnt
HAVING
    ddx.cnt = MIN(gdx.cnt);

EXEC dbms_output.put_line('c)');

SELECT
    gpx.pid,
    ggpy.ave
FROM
    (
        SELECT
            px.pid,
            COUNT(DISTINCT px.treatment) AS cnt
        FROM
            patient px
        GROUP BY
            px.pid
    ) gpx,
    (
        SELECT
            px.pid,
            COUNT(DISTINCT px.treatment) AS cnt
        FROM
            patient px
        GROUP BY
            px.pid
    ) ppx,
    (
        SELECT
            gpy.pid,
            AVG(gpy.cnt) AS ave
        FROM
            (
                SELECT
                    py.pid,
                    py.p_visit_number,
                    COUNT(py.treatment) AS cnt
                FROM
                    patient py
                GROUP BY
                    py.pid,
                    py.p_visit_number
            ) gpy
        GROUP BY
            gpy.pid
    ) ggpy
WHERE
    gpx.pid = ggpy.pid
GROUP BY
    gpx.pid,
    gpx.cnt,
    ggpy.ave
HAVING
    gpx.cnt = MAX(ppx.cnt);

EXEC dbms_output.put_line('d)');

EXEC dbms_output.put_line('PID');

EXEC dbms_output.put_line('-----------------------');

DECLARE
    CURSOR p_cur IS SELECT DISTINCT
        px.pid
                    FROM
        patient px
    GROUP BY
        px.pid,
        px.p_visit_number
    HAVING
        COUNT(*) = 2
    MINUS
    SELECT DISTINCT
        py.pid
    FROM
        patient py
    GROUP BY
        py.pid,
        py.p_visit_number
    HAVING
        COUNT(*) <> 2;

    ppid    NUMBER;
    flag2   NUMBER := 1;
BEGIN
    OPEN p_cur;
    LOOP
        FETCH p_cur INTO ppid;
        EXIT WHEN p_cur%notfound;
        flag2 := 1;
        DECLARE
            CURSOR t_cur IS SELECT DISTINCT
                pa.p_visit_number
                            FROM
                patient pa
                            WHERE
                pa.pid = ppid;

            pvn     NUMBER;
            flag1   NUMBER := 0;
        BEGIN
            OPEN t_cur;
            LOOP
                FETCH t_cur INTO pvn;
                EXIT WHEN t_cur%notfound;
                SELECT
                    COUNT(*)
                INTO
                    flag1
                FROM
                    patient pb
                WHERE
                    pb.pid = ppid
                    AND   pb.p_visit_number = pvn
                    AND   pb.treatment NOT IN (
                        SELECT DISTINCT
                            dx.specialty
                        FROM
                            doctor dx
                    );

                IF
                    flag1 <> 1
                THEN
                    flag2 := 0;
                END IF;
            END LOOP;

            CLOSE t_cur;
        END;

        IF
            flag2 = 1
        THEN
            dbms_output.put_line(ppid);
        END IF;
    END LOOP;

    CLOSE p_cur;
END;
/

EXEC dbms_output.put_line('e)');

SELECT
    dap.d_name,
    dap.specialty
FROM
    (
        SELECT
            dx.d_name,
            dx.specialty,
            px.pid
        FROM
            doctor dx,
            assignment ax,
            patient px
        WHERE
            dx.d_name = ax.d_name
            AND   ax.pid = px.pid
            AND   dx.specialty = px.treatment
        GROUP BY
            dx.d_name,
            dx.specialty,
            px.pid
    ) dap
GROUP BY
    dap.d_name,
    dap.specialty
HAVING
    COUNT(*) = 10;