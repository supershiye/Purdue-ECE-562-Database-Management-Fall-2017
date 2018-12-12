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
                icost:=0;
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
                if icost > 3000 then
                dbms_output.put_line(pname
                || '     '
                || icost);
                end if;
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
--EXCEPTION
--    WHEN no_data_found THEN
--        dbms_output.put_line('Bob luckily avoids 2nd_Surgery in 3rd visit. Please try to populate the database agian for its random.');

END;
/