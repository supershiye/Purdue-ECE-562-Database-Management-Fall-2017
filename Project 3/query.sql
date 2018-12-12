rem EE 562 Project 3
rem Ye Shi
rem shi349

----------------------------------------------------------
EXEC dbms_output.put_line('Query 1');

DECLARE
    CURSOR pi_cur IS SELECT DISTINCT
        patient_name
                     FROM
        general_ward
                     WHERE
        EXTRACT(YEAR FROM g_admission_date) = 2005;

    pname          VARCHAR2(30);
    pdate          DATE;
    ptype          VARCHAR2(10);
    visit          NUMBER := 0;
    icost          NUMBER := 0;
    gstay          NUMBER := 0;
    gflag          NUMBER := 0;
    tstay          NUMBER := 0; -- total stay
    sstay          NUMBER := 0;
    sflag          NUMBER := 0;
    next_ad_date   DATE;
    s4flag         NUMBER := 0; --if stay in screening 4 days to surgery
    preflag        NUMBER := 0;--if stay in pre ward
    surcount       NUMBER := 0;
    postay         NUMBER := 0;
    posflag        NUMBER := 0;
    prestay        NUMBER := 0;
    pcost          NUMBER := 0;
BEGIN
    DELETE FROM query_1;

    OPEN pi_cur;
    LOOP
        FETCH pi_cur INTO pname;
        EXIT WHEN pi_cur%notfound;
        tstay := 0;
        icost := 0;
        pcost := 0;
        gflag := 0;
        sflag := 0;
        s4flag := 0;
        preflag := 0;
        posflag := 0;
        SELECT
            COUNT(*)
        INTO
            visit
        FROM
            general_ward
        WHERE
            patient_name = pname
            AND   EXTRACT(YEAR FROM g_admission_date) = 2005;

        FOR i IN 1..visit LOOP
            IF
                i < visit
            THEN
                BEGIN
                    SELECT
                        g_admission_date
                    INTO
                        next_ad_date
                    FROM
                        (
                            SELECT
                                g_admission_date,
                                ROW_NUMBER() OVER(
                                    ORDER BY
                                        g_admission_date ASC
                                ) rn
                            FROM
                                general_ward
                            WHERE
                                patient_name = pname
                                AND   EXTRACT(YEAR FROM g_admission_date) = 2005
--                            ORDER BY g_admission_date ASC
                        )
                    WHERE
                        rn = i + 1;

                EXCEPTION
                    WHEN no_data_found THEN
                        next_ad_date := TO_DATE('05-12-31','yy-mm-dd');
                END;
            ELSE
                next_ad_date := TO_DATE('05-12-31','yy-mm-dd');
            END IF;

            BEGIN
                SELECT
                    s_admission_date - g_admission_date
                INTO
                    gstay
                FROM
                    (
                        SELECT
                            *
                        FROM
                            (
                                SELECT
                                    g_admission_date,
                                    ROW_NUMBER() OVER(
                                        ORDER BY
                                            g_admission_date ASC
                                    ) rn
                                FROM
                                    general_ward
                                WHERE
                                    patient_name = pname
                                    AND   EXTRACT(YEAR FROM g_admission_date) = 2005
--                                ORDER BY g_admission_date ASC
                            )
                        WHERE
                            rn = i
                    ) gx,
                    (
                        SELECT
                            *
                        FROM
                            (
                                SELECT
                                    s_admission_date,
                                    ROW_NUMBER() OVER(
                                        ORDER BY
                                            s_admission_date ASC
                                    ) rn
                                FROM
                                    screening_ward
                                WHERE
                                    patient_name = pname
                                    AND   EXTRACT(YEAR FROM s_admission_date) = 2005
--                                ORDER BY s_admission_date ASC
                            )
                        WHERE
                            rn = i
                    ) sx;

            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('The Patient '
                    || pname
                    || ' is still in General Ward during '
                    || i
                    || ' visit.');

                    SELECT
                        TO_DATE('05-12-31','yy-mm-dd') - g_admission_date
                    INTO
                        gstay
                    FROM
                        (
                            SELECT
                                g_admission_date,
                                ROW_NUMBER() OVER(
                                    ORDER BY
                                        g_admission_date ASC
                                ) rn
                            FROM
                                general_ward
                            WHERE
                                patient_name = pname
                                AND   EXTRACT(YEAR FROM g_admission_date) = 2005
--                            ORDER BY g_admission_date ASC
                        )
                    WHERE
                        rn = i;

                    gflag := 1;
            END;

--            dbms_output.put_line('Gstay'
--            || gstay);
--                        dbms_output.put_line('Gflag' || gflag);

            tstay := tstay + gstay;
            IF
                gstay <= 3
            THEN
                icost := icost + gstay * 50 * 0.8;
                pcost := pcost + gstay * 50 * 0.2;
            ELSE
                icost := icost + 3 * 50 * 0.8 + ( gstay - 3 ) * 50 * 0.7;

                pcost := pcost + 3 * 50 * 0.2 + ( gstay - 3 ) * 50 * 0.3;

            END IF;

            IF
                gflag = 0
            THEN
                BEGIN
                    SELECT
                        pre_admission_date - s_admission_date
                    INTO
                        sstay
                    FROM
                        (
                            SELECT
                                *
                            FROM
                                (
                                    SELECT
                                        s_admission_date,
                                        ROW_NUMBER() OVER(
                                            ORDER BY
                                                s_admission_date ASC
                                        ) rn
                                    FROM
                                        screening_ward
                                    WHERE
                                        patient_name = pname
                                        AND   EXTRACT(YEAR FROM s_admission_date) = 2005
--                                    ORDER BY s_admission_date ASC
                                )
                            WHERE
                                rn = i
                        ) sx,
                        (
                            SELECT
                                *
                            FROM
                                (
                                    SELECT
                                        pre_admission_date,
                                        ROW_NUMBER() OVER(
                                            ORDER BY
                                                pre_admission_date ASC
                                        ) rn
                                    FROM
                                        pre_surgery_ward
                                    WHERE
                                        patient_name = pname
                                        AND   EXTRACT(YEAR FROM pre_admission_date) = 2005
                                        AND   pre_admission_date <= next_ad_date
                                )
                            WHERE
                                rn = i
                        ) prex;
                                                
--Dbms_Output.Put_Line('Sstay' || Next_Ad_Date);

                EXCEPTION
                    WHEN no_data_found THEN
                        preflag := 1;
                        BEGIN
                            SELECT
                                post_admission_date - s_admission_date
                            INTO
                                sstay
                            FROM
                                (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                s_admission_date,
                                                ROW_NUMBER() OVER(
                                                    ORDER BY
                                                        s_admission_date ASC
                                                ) rn
                                            FROM
                                                screening_ward
                                            WHERE
                                                patient_name = pname
                                                AND   EXTRACT(YEAR FROM s_admission_date) = 2005
--                                            ORDER BY s_admission_date ASC
                                        )
                                    WHERE
                                        rn = i
                                ) sx,
                                (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                post_admission_date,
                                                ROW_NUMBER() OVER(
                                                    ORDER BY
                                                        post_admission_date ASC
                                                ) rn
                                            FROM
                                                post_surgery_ward
                                            WHERE
                                                patient_name = pname
                                                AND   EXTRACT(YEAR FROM post_admission_date) = 2005
                                                AND   post_admission_date <= next_ad_date
--                                            ORDER BY post_admission_date ASC
                                        )
                                    WHERE
                                        rn = i
                                ) post;

                        EXCEPTION
                            WHEN no_data_found THEN
                                dbms_output.put_line('The Patient '
                                || pname
                                || ' is still in Screening Ward during '
                                || i
                                || ' visit.');

                                SELECT
                                    TO_DATE('05-12-31','yy-mm-dd') - s_admission_date
                                INTO
                                    sstay
                                FROM
                                    (
                                        SELECT
                                            s_admission_date,
                                            ROW_NUMBER() OVER(
                                                ORDER BY
                                                    s_admission_date ASC
                                            ) rn
                                        FROM
                                            screening_ward
                                        WHERE
                                            patient_name = pname
                                            AND   EXTRACT(YEAR FROM s_admission_date) = 2005
--                                        ORDER BY s_admission_date ASC
                                    )
                                WHERE
                                    rn = i;

                                sflag := 1;
                                posflag := 1;
                        END;

                END;

--                dbms_output.put_line('Sstay'
--                || sstay);

                tstay := tstay + sstay;
                IF
                    sstay <= 2
                THEN
                    icost := icost + sstay * 70 * 0.85;
                    pcost := pcost + sstay * 70 * 0.15;
                ELSE
                    icost := icost + 2 * 70 * 0.85 + ( sstay - 2 ) * 70 * 0.75;

                    pcost := pcost + 2 * 70 * 0.15 + ( sstay - 2 ) * 70 * 0.25;

                END IF;

                IF
                    preflag = 0 AND sflag = 0
                THEN
                    IF
                        posflag = 0
                    THEN
                        BEGIN
                            SELECT
                                post_admission_date - pre_admission_date
                            INTO
                                prestay
                            FROM
                                (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                pre_admission_date,
                                                ROW_NUMBER() OVER(
                                                    ORDER BY
                                                        pre_admission_date ASC
                                                ) rn
                                            FROM
                                                pre_surgery_ward
                                            WHERE
                                                patient_name = pname
                                                AND   EXTRACT(YEAR FROM pre_admission_date) = 2005
--                                            ORDER BY pre_admission_date ASC
                                        )
                                    WHERE
                                        rn = i
                                ) sx,
                                (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                post_admission_date,
                                                ROW_NUMBER() OVER(
                                                    ORDER BY
                                                        post_admission_date ASC
                                                ) rn
                                            FROM
                                                post_surgery_ward
                                            WHERE
                                                patient_name = pname
                                                AND   EXTRACT(YEAR FROM post_admission_date) = 2005
                                                AND   post_admission_date <= next_ad_date
--                                            ORDER BY post_admission_date ASC
                                        )
                                    WHERE
                                        rn = i
                                ) post;

                        EXCEPTION
                            WHEN no_data_found THEN
                                posflag := 1;
                                prestay := 1;
                        END;
                    END IF;

--                    dbms_output.put_line('Prestay'
--                    || prestay);

                    tstay := tstay + prestay;
                    icost := icost + prestay * 90 * 0.95;
                    pcost := pcost + prestay * 90 * 0.05;
                    IF
                        posflag = 0
                    THEN
                        SELECT
                            patient_type,
                            scount
                        INTO
                            ptype,surcount
                        FROM
                            (
                                SELECT
                                    patient_type,
                                    ROW_NUMBER() OVER(
                                        ORDER BY
                                            post_admission_date ASC
                                    ) rn,
                                    scount
                                FROM
                                    post_surgery_ward
                                WHERE
                                    patient_name = pname
                            )
                        WHERE
                            rn = i;

                        IF
                            ptype = 'General'
                        THEN
                            icost := icost + 2500 * 0.65;
                            pcost := pcost + 2500 * 0.45;
                        ELSIF ptype = 'Neuro' THEN
                            icost := icost + 5000 * 0.85;
                            pcost := pcost + 5000 * 0.15;
                        ELSIF ptype = 'Cardiac' THEN
                            icost := icost + 3500 * 0.75;
                            pcost := pcost + 3500 * 0.35;
                        END IF;

                        IF
                            surcount = 2
                        THEN
                            IF
                                ptype = 'General'
                            THEN
                                icost := icost + 2500 * 0.60;
                                pcost := pcost + 2500 * 0.4;
                            ELSIF ptype = 'Neuro' THEN
                                icost := icost + 5000 * 0.80;
                                pcost := pcost + 5000 * 0.2;
                            ELSIF ptype = 'Cardiac' THEN
                                icost := icost + 3500 * 0.70;
                                pcost := pcost + 3500 * 0.3;
                            END IF;
                        END IF;

                        BEGIN
                            SELECT
                                dd
                            INTO
                                postay
                            FROM
                                (
                                    SELECT
                                        discharge_date - post_admission_date AS dd,
                                        ROW_NUMBER() OVER(
                                            ORDER BY
                                                post_admission_date ASC
                                        ) rn
                                    FROM
                                        post_surgery_ward
                                    WHERE
                                        patient_name = pname
                                        AND   EXTRACT(YEAR FROM post_admission_date) = 2005
                                )
                            WHERE
                                rn = i;

                        EXCEPTION
                            WHEN no_data_found THEN
                                SELECT
                                    TO_DATE('05-12-31','yy-mm-dd') - post_admission_date
                                INTO
                                    postay
                                FROM
                                    (
                                        SELECT
                                            post_admission_date,
                                            ROW_NUMBER() OVER(
                                                ORDER BY
                                                    post_admission_date ASC
                                            ) rn
                                        FROM
                                            post_surgery_ward
                                        WHERE
                                            patient_name = pname
                                            AND   EXTRACT(YEAR FROM post_admission_date) = 2005
                                    )
                                WHERE
                                    rn = i;

                        END;
--
--                        dbms_output.put_line('postay'
--                        || postay);

                        tstay := tstay + postay;
                        icost := icost + 80 * postay * 0.90;
                        pcost := pcost + 80 * postay * 0.1;
                    END IF;

                END IF;

            END IF;

--            dbms_output.put_line(pname
--            || ' '
--            || i
--            || '/'
--            || visit
--            || ' '
--            || tstay
--            || ' '
--            || icost
--            || ' '
--            || pcost);

        END LOOP;

        INSERT INTO query_1 VALUES (
            pname,
            visit,
            tstay / visit,
            icost,
            pcost
        );

    END LOOP;

END;
/

SELECT
    patient_name,
    total_number_of_visits,
    average_stay,
    r_total_cost
FROM
    query_1;

EXEC dbms_output.put_line('Query 2');

SELECT
    SUM(r_total_cost) AS ave_total_cost,
    AVG(r_total_cost) AS ave_patient_cost,
    AVG(r_total_cost / total_number_of_visits) AS ave_total_cost_per_visit
FROM
    query_1;

EXEC dbms_output.put_line('Query 3');

DECLARE
    b2adate   DATE;
    b2ddate   DATE;
    pname     VARCHAR2(30);
    pstay     NUMBER;
BEGIN
    dbms_output.put_line('patient_name    ave_stay');
    dbms_output.put_line('----------------------------');
    BEGIN
        SELECT
            g_admission_date
        INTO
            b2adate
        FROM
            (
                SELECT
                    g_admission_date,
                    ROW_NUMBER() OVER(
                        ORDER BY
                            g_admission_date ASC
                    ) rn
                FROM
                    general_ward
                WHERE
                    patient_name = 'Bob'
            ) bx
        WHERE
            bx.rn = 2;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20003,'Bob does not come twice"');
    END;

    BEGIN
        SELECT
            discharge_date
        INTO
            b2ddate
        FROM
            (
                SELECT
                    discharge_date,
                    ROW_NUMBER() OVER(
                        ORDER BY
                            discharge_date ASC
                    ) rn
                FROM
                    post_surgery_ward
                WHERE
                    patient_name = 'Bob'
            ) bx
        WHERE
            bx.rn = 2;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20003,'Bob has not discharged"');
    END;

    DECLARE
        CURSOR q3_cur IS SELECT DISTINCT
            gw.patient_name
                         FROM
            general_ward gw,
            post_surgery_ward pos
                         WHERE
            gw.g_admission_date = b2adate
            AND   gw.patient_name = pos.patient_name
            AND   pos.discharge_date < b2ddate
            AND   gw.patient_name <> 'Bob';

    BEGIN
        OPEN q3_cur;
        LOOP
            FETCH q3_cur INTO pname;
            EXIT WHEN q3_cur%notfound;
            SELECT
                average_stay
            INTO
                pstay
            FROM
                query_1
            WHERE
                patient_name = pname;

            dbms_output.put_line(pname
            || ' '
            || pstay);
        END LOOP;

    END;

END;
/

EXEC dbms_output.put_line('Query 4');

DECLARE
    tdate     DATE;
    trn       NUMBER;
    tdays     NUMBER;
    sdate     DATE;
    sflag     NUMBER := 0;
    edate     DATE;
    surgeon   VARCHAR2(30);
    CURSOR psv_cur IS SELECT DISTINCT
        surgery_date
                      FROM
        patient_surgery_view
                      WHERE
        EXTRACT(YEAR FROM surgery_date) = 2005
    ORDER BY
        surgery_date ASC;

BEGIN
    OPEN psv_cur;
    LOOP
        FETCH psv_cur INTO tdate;
        EXIT WHEN psv_cur%notfound;
        IF
            sflag = 0
        THEN
            sdate := tdate;
            edate := tdate;
            sflag := 1;
        ELSIF sflag = 1 AND edate = tdate - 1 THEN
            edate := tdate;
--  dbms_output.put_line(edate);
        ELSIF sflag = 1 AND edate <> tdate - 1 THEN
            DECLARE
                CURSOR na_cur IS SELECT
                    name
                                 FROM
                    patient_surgery_view
                                 WHERE
                    surgery_date <= edate
                    AND   surgery_date >= sdate
                                 GROUP BY
                    name
                HAVING
                    COUNT(name) = (
                        SELECT
                            MAX(COUNT(name) )
                        FROM
                            patient_surgery_view
                        WHERE
                            surgery_date <= edate
                            AND   surgery_date >= sdate
                        GROUP BY
                            name
                    );

            BEGIN
                DELETE FROM query_4;

                OPEN na_cur;
                LOOP
                    FETCH na_cur INTO surgeon;
                    EXIT WHEN na_cur%notfound;
--     dbms_output.put_line(sdate|| ' ' ||edate||' '||surgeon);
                    INSERT INTO query_4 VALUES (
                        sdate,
                        edate,
                        surgeon
                    );

                END LOOP;

                CLOSE na_cur;
            END;
  
 
-- dbms_output.put_line(sdate|| ' ' ||edate);

            sdate := tdate;
            edate := tdate;
        END IF;

    END LOOP;
--dbms_output.put_line(sdate|| ' ' ||edate);   

    DECLARE
        CURSOR na_cur IS SELECT
            name
                         FROM
            patient_surgery_view
                         WHERE
            surgery_date <= edate
            AND   surgery_date >= sdate
                         GROUP BY
            name
        HAVING
            COUNT(name) = (
                SELECT
                    MAX(COUNT(name) )
                FROM
                    patient_surgery_view
                WHERE
                    surgery_date <= edate
                    AND   surgery_date >= sdate
                GROUP BY
                    name
            );

    BEGIN
        OPEN na_cur;
        LOOP
            FETCH na_cur INTO surgeon;
            EXIT WHEN na_cur%notfound;
--     dbms_output.put_line(sdate|| ' ' ||edate||' '||surgeon);
            INSERT INTO query_4 VALUES (
                sdate,
                edate,
                surgeon
            );

        END LOOP;

        CLOSE na_cur;
    END;

END;
/

SELECT
    *
FROM
    query_4
ORDER BY
    ( edate - sdate ) DESC;

EXEC dbms_output.put_line('Query 5');

DECLARE
    CURSOR q5_cur IS SELECT DISTINCT
        surgery_date
                     FROM
        patient_surgery_view psv
                     WHERE
        EXTRACT(MONTH FROM surgery_date) = 4
        AND   EXTRACT(YEAR FROM surgery_date) = 2005
    MINUS
    SELECT DISTINCT
        surgery_date
    FROM
        patient_surgery_view psv
    WHERE
        name = 'Dr. Gower'
        OR   name = 'Dr. Taylor';

    tdate   DATE;
    trn     NUMBER;
    tdays   NUMBER;
    sdate   DATE;
    sflag   NUMBER := 0;
    edate   DATE;
BEGIN
    OPEN q5_cur;
    LOOP
        FETCH q5_cur INTO tdate;
        EXIT WHEN q5_cur%notfound;
        IF
            sflag = 0
        THEN
            sdate := tdate;
            edate := tdate;
            sflag := 1;
        ELSIF sflag = 1 AND edate = tdate - 1 THEN
            edate := tdate;
--  dbms_output.put_line(edate);
        ELSIF sflag = 1 AND edate <> tdate - 1 THEN
            dbms_output.put_line(sdate
            || ' '
            || edate);
            sdate := tdate;
            edate := tdate;
        END IF;

    END LOOP;

    dbms_output.put_line(sdate
    || ' '
    || edate);
    CLOSE q5_cur;
END;
/

EXEC dbms_output.put_line('Query 6');

DECLARE
    bob_date   DATE;
BEGIN
    dbms_output.put_line('Patient_Name  Cost');
    dbms_output.put_line('------------------------------------');
    SELECT
        ps.adate
    INTO
        bob_date
    FROM
        (
            SELECT
                adate
            FROM
                (
                    SELECT
                        adate,
                        ROW_NUMBER() OVER(
                            ORDER BY
                                adate ASC
                        ) rn
                    FROM
                        patient_schedule
                    WHERE
                        patient_name = 'Bob'
                        AND   ward = 'G_Admission_Date'
                )
            WHERE
                rn = 3
        ) x3,
        patient_schedule ps
    WHERE
        ps.patient_name = 'Bob'
        AND   ps.adate > x3.adate
        AND   ps.ward = '2nd_Surgery'
        AND   ps.adate < x3.adate + 20;
--                dbms_output.put_line(bob_date);

    DECLARE
        CURSOR q6 IS SELECT
            *
                     FROM
            patient_schedule
                     WHERE
            patient_name IN (
                SELECT
                    patient_name
                FROM
                    patient_schedule
                WHERE
                    ward = 'Discharge_Date'
                    AND   adate <= bob_date + 3
                    AND   adate >= bob_date - 3
            )
            AND   adate <= bob_date + 10
            AND   adate >= bob_date - 18
        ORDER BY
            patient_name,
            adate;

        pname     VARCHAR2(30);
        pward     VARCHAR2(20);
        pdate     DATE;
        oldname   VARCHAR2(30) := 'Alien';
        oldward   VARCHAR2(20);
        olddate   DATE;
        icost     NUMBER := 0;
        ptype     VARCHAR2(10);
        stay      NUMBER := 0;
    BEGIN
        OPEN q6;
        LOOP
            FETCH q6 INTO pname,pward,pdate;
            EXIT WHEN q6%notfound;
--            dbms_output.put_line( pname||pward||pdate);
            IF
                pname <> oldname
            THEN
                oldname := pname;
                oldward := pward;
                olddate := pdate;
                icost := 0;
            END IF;

            stay := pdate - olddate;
            IF
                pward = 'G_Admission_Date'
            THEN
                SELECT
                    patient_type
                INTO
                    ptype
                FROM
                    general_ward
                WHERE
                    patient_name = pname
                    AND   g_admission_date = pdate;

            ELSIF pward = 'S_Admission_Date' THEN
                IF
                    stay <= 3
                THEN
                    icost := icost + stay * 50 * 0.8;
                ELSE
                    icost := icost + 3 * 50 * 0.8 + ( stay - 3 ) * 50 * 0.7;
                END IF;
            ELSIF pward = 'Pre_Admission_Date' THEN
                IF
                    stay <= 2
                THEN
                    icost := icost + stay * 70 * 0.85;
                ELSE
                    icost := icost + 2 * 70 * 0.85 + ( stay - 2 ) * 70 * 0.75;
                END IF;
            ELSIF pward = 'Post_Admission_Date' AND oldward = 'Pre_Admission_Date' THEN
                icost := icost + stay * 90 * 0.95;
                IF
                    ptype = 'General'
                THEN
                    icost := icost + 2500 * 0.65;
                ELSIF ptype = 'Neuro' THEN
                    icost := icost + 5000 * 0.85;
                ELSIF ptype = 'Cardiac' THEN
                    icost := icost + 3500 * 0.75;
                END IF;

            ELSIF pward = 'Post_Admission_Date' AND oldward = 'S_Admission_Date' THEN
                IF
                    stay <= 2
                THEN
                    icost := icost + stay * 70 * 0.85;
                ELSE
                    icost := icost + 2 * 70 * 0.85 + ( stay - 2 ) * 70 * 0.75;
                END IF;

                IF
                    ptype = 'General'
                THEN
                    icost := icost + 2500 * 0.65;
                ELSIF ptype = 'Neuro' THEN
                    icost := icost + 5000 * 0.85;
                ELSIF ptype = 'Cardiac' THEN
                    icost := icost + 3500 * 0.75;
                END IF;

            ELSIF pward = '2nd_Surgery' THEN
                icost := icost + 80 * 2 * 0.90;
                IF
                    ptype = 'General'
                THEN
                    icost := icost + 2500 * 0.60;
                ELSIF ptype = 'Neuro' THEN
                    icost := icost + 5000 * 0.80;
                ELSIF ptype = 'Cardiac' THEN
                    icost := icost + 3500 * 0.70;
                END IF;

            ELSIF pward = 'Discharge_Date' THEN
                icost := icost + 80 * 2 * 0.90;
                IF
                    icost > 3000
                THEN
                    dbms_output.put_line(pname
                    || '     '
                    || icost);
                END IF;

            END IF;

            oldward := pward;
            olddate := pdate;
        END LOOP;

        CLOSE q6;
--        EXCEPTION
--            WHEN no_data_found THEN
--        dbms_output.put_line('No one satisfies the period.');
    END;
--
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Bob luckily avoids 2nd_Surgery in 3rd visit. Please try to populate the database agian for its random.');

END;
/

EXEC dbms_output.put_line('Query 7');

DECLARE
    CURSOR q7 IS SELECT
        *
                 FROM
        patient_surgery_view psv
                 WHERE
        psv.surgery_date <= '09-apr-05'
        AND   psv.surgery_date >= '03-apr-05'
        AND   psv.patient_type = 'Cardiac';

    pname   VARCHAR2(30);
    sdate   DATE;
    ptype   VARCHAR2(10);
    dname   VARCHAR2(10);
BEGIN
    dbms_output.put_line('Patient_Name, Surgery_date, Patient_Type,  Dr_Name');
    dbms_output.put_line('-------------------------------------------------------');
    OPEN q7;
    LOOP
        FETCH q7 INTO pname,sdate,ptype,dname;
        EXIT WHEN q7%notfound;
        dbms_output.put_line(pname
        || '    '
        || sdate
        || '    '
        || ptype
        || '    '
        || dname);

        SELECT
            name
        INTO
            dname
        FROM
            (
                SELECT
                    name
                FROM
                    dr_schedule
                WHERE
                    ward = 'Surgery'
                    AND   duty_date = sdate
            )
        WHERE
            ROWNUM < 2;

        dbms_output.put_line(pname
        || '    '
        || sdate
        || '    '
        || ptype
        || '    '
        || dname);

    END LOOP;

    CLOSE q7;
END;
/

EXEC dbms_output.put_line('Query 8');

DECLARE
    CURSOR q8 IS SELECT
        *
                 FROM
        patient_schedule
                 WHERE
        patient_name = 'Bob'
        AND   EXTRACT(YEAR FROM adate) = 2005
    ORDER BY
        adate;

    pdate     DATE;
    pward     VARCHAR2(20);
    pname     VARCHAR2(30);
    oldward   VARCHAR2(20);
    olddate   DATE;
    stay      NUMBER := 0;
BEGIN
    DELETE FROM query_8;

    OPEN q8;
    LOOP
        FETCH q8 INTO pname,pward,pdate;
        EXIT WHEN q8%notfound;
        IF
            pward = 'G_Admission_Date'
        THEN
            oldward := pward;
            olddate := pdate;
        END IF;
        stay := pdate - olddate;
        IF
            pward = 'S_Admission_Date'
        THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'General_Ward',
                    olddate + i
                );

            END LOOP;
        ELSIF pward = 'Pre_Admission_Date' THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'Screening_Ward',
                    olddate + i
                );

            END LOOP;
        ELSIF pward = 'Post_Admission_Date' AND oldward = 'Pre_Admission_Date' THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'Pre_Surgery_Ward',
                    olddate + i
                );

            END LOOP;
        ELSIF pward = 'Post_Admission_Date' AND oldward = 'S_Admission_Date' THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'Screening_Ward',
                    olddate + i
                );

            END LOOP;
        ELSIF pward = '2nd_Surgery' THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'Post_Surgery_Ward',
                    olddate + i
                );

            END LOOP;
        ELSIF pward = 'Discharge_Date' THEN
            FOR i IN 0..stay - 1 LOOP
                INSERT INTO query_8 VALUES (
                    'Post_Surgery_Ward',
                    olddate + i
                );

            END LOOP;
        END IF;

        oldward := pward;
        olddate := pdate;
    END LOOP;

    CLOSE q8;
END;
/

EXEC dbms_output.put_line('Start_Date    End_date');

EXEC dbms_output.put_line('------------------------------');

DECLARE
    CURSOR q82 IS SELECT
        *
                  FROM
        query_8
    MINUS
    SELECT
        ward,
        duty_date AS indate
    FROM
        dr_schedule
    WHERE
        name = 'Adams';

    ward     VARCHAR2(20);
    tdate    DATE;
    tdays    NUMBER;
    sdate    DATE;
    sflag    NUMBER := 0;
    edate    DATE;
    date3g   DATE;
    date3d   DATE;
BEGIN
    SELECT
        adate
    INTO
        date3g
    FROM
        (
            SELECT
                adate,
                ROW_NUMBER() OVER(
                    ORDER BY
                        adate
                ) AS rn
            FROM
                patient_schedule
            WHERE
                patient_name = 'Bob'
                AND   ward = 'G_Admission_Date'
        )
    WHERE
        rn = 3;

    SELECT
        adate
    INTO
        date3d
    FROM
        (
            SELECT
                adate,
                ROW_NUMBER() OVER(
                    ORDER BY
                        adate
                ) AS rn
            FROM
                patient_schedule
            WHERE
                patient_name = 'Bob'
                AND   ward = 'Discharge_Date'
        )
    WHERE
        rn = 3;

    OPEN q82;
    LOOP
        FETCH q82 INTO ward,tdate;
        EXIT WHEN q82%notfound;
        IF
            tdate <= date3d AND tdate >= date3g
        THEN
            IF
                sflag = 0
            THEN
                sdate := tdate;
                edate := tdate;
                sflag := 1;
            ELSIF sflag = 1 AND edate = tdate - 1 THEN
                edate := tdate;
--  dbms_output.put_line(edate);
            ELSIF sflag = 1 AND edate <> tdate - 1 THEN
                dbms_output.put_line(sdate
                || '    '
                || edate);
                sdate := tdate;
                edate := tdate;
            END IF;
        END IF;

    END LOOP;
--            dbms_output.put_line(sdate
--            || '    '
--            || edate);

    CLOSE q82;
END;
/

EXEC dbms_output.put_line('Query 9');

EXEC dbms_output.put_line('Start_Date    End_date');

EXEC dbms_output.put_line('------------------------------');

DECLARE
    CURSOR q9 IS SELECT
        indate
                 FROM
        query_8
    MINUS
    SELECT
        pdate AS indate
    FROM
        patient_chart pc
    WHERE
        patient_name = 'Bob'
        AND   (
            pc.bp > 140
            OR    pc.bp < 110
        );

    tdate   DATE;
    tdays   NUMBER;
    sdate   DATE;
    sflag   NUMBER := 0;
    edate   DATE;
BEGIN
    OPEN q9;
    LOOP
        FETCH q9 INTO tdate;
        EXIT WHEN q9%notfound;
        IF
            sflag = 0
        THEN
            sdate := tdate;
            edate := tdate;
            sflag := 1;
        ELSIF sflag = 1 AND edate = tdate - 1 THEN
            edate := tdate;
--  dbms_output.put_line(edate);
        ELSIF sflag = 1 AND edate <> tdate - 1 THEN
            IF
                sdate <> edate
            THEN
                dbms_output.put_line(sdate
                || '    '
                || edate);
            END IF;

            sdate := tdate;
            edate := tdate;
        END IF;

    END LOOP;

    IF
        sdate <> edate
    THEN
        dbms_output.put_line(sdate
        || '    '
        || edate);
    END IF;

    CLOSE q9;
END;
/

EXEC dbms_output.put_line('Query 10');

DECLARE
    CURSOR q10 IS SELECT DISTINCT
        patient_name
                  FROM
        query_1
                  WHERE
        total_number_of_visits > 1;

    qname   VARCHAR2(30);
BEGIN
    DELETE FROM query_10;

    OPEN q10;
    LOOP
        FETCH q10 INTO qname;
        EXIT WHEN q10%notfound;
        DECLARE
            CURSOR q101 IS SELECT
                *
                           FROM
                patient_schedule
                           WHERE
                patient_name = qname
                AND   EXTRACT(YEAR FROM adate) = 2005
            ORDER BY
                3;

            pname     VARCHAR2(30);
            pward     VARCHAR2(20);
            pdate     DATE;
            oldname   VARCHAR2(30) := 'Alien';
            oldward   VARCHAR2(20);
            olddate   DATE;
            icost     NUMBER := 0;
            ptype     VARCHAR2(10);
            stay      NUMBER := 0;
            naday     DATE := '01-jan-2006';
            dday      DATE := '01-jan-2005';
            aday      DATE := '01-jan-2006';
            cflag     NUMBER := 0;
            counter   NUMBER := 0;
            tcost     NUMBER := 0;
            oname     VARCHAR2(30);
            ocost     NUMBER := 0;
            otype     VARCHAR2(10);
            oflag     NUMBER := 0;
            tflag     NUMBER := 0;
        BEGIN
            OPEN q101;
            LOOP
                FETCH q101 INTO pname,pward,pdate;
                EXIT WHEN q101%notfound;
                IF
                    pname <> oldname
                THEN
                    oldname := pname;
                    oldward := pward;
                    olddate := pdate;
--                    aday := '01-jan-2006';
                END IF;

                IF
                    pward = 'G_Admission_Date'
                THEN
                    ocost := icost;
                    aday := pdate;
                    icost := 0;
                    SELECT
                        patient_type
                    INTO
                        ptype
                    FROM
                        general_ward
                    WHERE
                        patient_name = pname
                        AND   g_admission_date = pdate;

                    IF
                        otype = ptype
                    THEN
                        tflag := 1;
                    ELSE
                        tflag := 0;
                    END IF;

                    otype := ptype;
                END IF;

                stay := pdate - olddate;
                IF
                    pward = 'S_Admission_Date'
                THEN
                    IF
                        stay <= 3
                    THEN
                        icost := icost + stay * 50 * 0.8;
                    ELSE
                        icost := icost + 3 * 50 * 0.8 + ( stay - 3 ) * 50 * 0.7;
                    END IF;
                ELSIF pward = 'Pre_Admission_Date' THEN
                    IF
                        stay <= 2
                    THEN
                        icost := icost + stay * 70 * 0.85;
                    ELSE
                        icost := icost + 2 * 70 * 0.85 + ( stay - 2 ) * 70 * 0.75;
                    END IF;
                ELSIF pward = 'Post_Admission_Date' AND oldward = 'Pre_Admission_Date' THEN
                    icost := icost + stay * 90 * 0.95;
                    IF
                        ptype = 'General'
                    THEN
                        icost := icost + 2500 * 0.65;
                    ELSIF ptype = 'Neuro' THEN
                        icost := icost + 5000 * 0.85;
                    ELSIF ptype = 'Cardiac' THEN
                        icost := icost + 3500 * 0.75;
                    END IF;

                ELSIF pward = 'Post_Admission_Date' AND oldward = 'S_Admission_Date' THEN
                    IF
                        stay <= 2
                    THEN
                        icost := icost + stay * 70 * 0.85;
                    ELSE
                        icost := icost + 2 * 70 * 0.85 + ( stay - 2 ) * 70 * 0.75;
                    END IF;

                    IF
                        ptype = 'General'
                    THEN
                        icost := icost + 2500 * 0.65;
                    ELSIF ptype = 'Neuro' THEN
                        icost := icost + 5000 * 0.85;
                    ELSIF ptype = 'Cardiac' THEN
                        icost := icost + 3500 * 0.75;
                    END IF;

                ELSIF pward = '2nd_Surgery' THEN
                    icost := icost + 80 * 2 * 0.90;
                    IF
                        ptype = 'General'
                    THEN
                        icost := icost + 2500 * 0.60;
                    ELSIF ptype = 'Neuro' THEN
                        icost := icost + 5000 * 0.80;
                    ELSIF ptype = 'Cardiac' THEN
                        icost := icost + 3500 * 0.70;
                    END IF;

                ELSIF pward = 'Discharge_Date' THEN
                    IF
                        cflag <= 14 AND cflag >= 5
                    THEN
                        icost := icost + 80 * 2 * 0.90;
                    END IF;

--                    dbms_output.put_line(pname
--                    || ' '
--                    || icost
--                    || ' '
--                    || ptype);

                    oflag := cflag;
                    cflag := aday - dday;
--                    dbms_output.put_line(cflag);
                    INSERT INTO query_10 VALUES (
                        pname,
                        icost,
                        ptype,
                        cflag
                    );

--                    dbms_output.put_line(pname
--                    || 'update '
--                    || ocost
--                    || ' '
--                    || oflag);

                    IF
                        cflag <= 15 AND cflag >= 5 AND tflag = 0
                    THEN
                        UPDATE query_10 qq
                            SET
                                qq.cflag = 14
                        WHERE
                            qq.patient_name = pname
                            AND   qq.icost = ocost;

                    END IF;

                    IF
                        tflag = 1
                    THEN
                        UPDATE query_10 qq
                            SET
                                qq.cflag = 1
                        WHERE
                            qq.patient_name = pname
                            AND   qq.icost = ocost;

                    END IF;
--
--                    dbms_output.put_line(aday
--                    || ' '
--                    || dday);

                    dday := pdate;
                    counter := counter + 1;
                END IF;

                oldward := pward;
                olddate := pdate;
            END LOOP;

            CLOSE q101;
        END;

    END LOOP;

    CLOSE q10;
END;
/

SELECT
    patient_name,
    SUM(icost)
FROM
    query_10
WHERE
    cflag >= 5
    AND   cflag <= 14
GROUP BY
    patient_name
ORDER BY
    patient_name;