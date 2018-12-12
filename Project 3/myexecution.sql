rem EE 562 Project 3
rem Ye Shi
rem shi349
----------------------------------------------------------
@dropall;

@createtable;

@trg;

@populate;
----------------------------------------------------------

EXEC dbms_output.put_line('Populate Dr_Schedule');

EXEC populate_dr;
----------------------------------------------------------

EXEC dbms_output.put_line('Populate Surgeon_Schedule');

EXEC populate_surgeon;
----------------------------------------------------------

EXEC dbms_output.put_line('Check Dr_Schedule and Surgeon_Schedule');

DECLARE
    er   NUMBER;
BEGIN
    er := check_schedule;
END;
/
----------------------------------------------------------

EXEC dbms_output.put_line('Schedule of Each Patient');

DECLARE
    CURSOR pi_cur IS SELECT
        *
                     FROM
        patient_input;

    pname    VARCHAR2(30);
    pdate    DATE;
    ptype    VARCHAR2(10);
    nname    VARCHAR2(30);
    ndate    DATE;
    ddate    DATE;
    s2date   DATE;
BEGIN
--    dbms_output.put_line('Schedule of Each Patient');
    dbms_output.put_line('Patient Name     Ward    Date');
    OPEN pi_cur;
    LOOP
        FETCH pi_cur INTO pname,pdate,ptype;
        EXIT WHEN pi_cur%notfound;
        dbms_output.put_line('--------------------------------------------');
        SELECT
            patient_name,
            g_admission_date
        INTO
            nname,ndate
        FROM
            general_ward
        WHERE
            patient_name = pname
            AND   patient_type = ptype
            AND   g_admission_date >= pdate
            AND   g_admission_date <= pdate + 15;

        dbms_output.put_line(nname
        || ' G_Admission_Date '
        || ndate);
        INSERT INTO patient_schedule VALUES (
            nname,
            'G_Admission_Date',
            ndate
        );

        BEGIN
            SELECT
                patient_name,
                s_admission_date
            INTO
                nname,ndate
            FROM
                screening_ward
            WHERE
                patient_name = pname
                AND   patient_type = ptype
                AND   s_admission_date >= pdate
                AND   s_admission_date <= pdate + 15;

            dbms_output.put_line(nname
            || ' S_Admission_Date '
            || ndate);
            INSERT INTO patient_schedule VALUES (
                nname,
                'S_Admission_Date',
                ndate
            );

        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;

        BEGIN
            SELECT
                patient_name,
                pre_admission_date
            INTO
                nname,ndate
            FROM
                pre_surgery_ward
            WHERE
                patient_name = pname
                AND   patient_type = ptype
                AND   pre_admission_date >= pdate
                AND   pre_admission_date <= pdate + 15;

            dbms_output.put_line(nname
            || ' Pre_Admission_Date '
            || ndate);
            INSERT INTO patient_schedule VALUES (
                nname,
                'Pre_Admission_Date',
                ndate
            );

        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;

        BEGIN
            SELECT
                patient_name,
                post_admission_date,
                discharge_date
            INTO
                nname,ndate,ddate
            FROM
                post_surgery_ward
            WHERE
                patient_name = pname
                AND   patient_type = ptype
                AND   post_admission_date >= pdate
                AND   post_admission_date <= pdate + 15;

            dbms_output.put_line(nname
            || ' Post_Admission_Date '
            || ndate);
            INSERT INTO patient_schedule VALUES (
                nname,
                'Post_Admission_Date',
                ndate
            );

            IF
                ddate - ndate = 4
            THEN
                s2date := ddate - 2;
                dbms_output.put_line(nname
                || ' 2nd_Surgery '
                || s2date);
                INSERT INTO patient_schedule VALUES (
                    nname,
                    '2nd_Surgery',
                    s2date
                );

            END IF;

            dbms_output.put_line(nname
            || ' Discharge_Date '
            || ddate);
            INSERT INTO patient_schedule VALUES (
                nname,
                'Discharge_Date',
                ddate
            );

        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;

    END LOOP;

END;
/

----------------------------------------------------------

EXEC dbms_output.put_line('Dr_Schedule');

SELECT
    *
FROM
    dr_schedule
ORDER BY
    duty_date;
----------------------------------------------------------

EXEC dbms_output.put_line('Surgeon_Schedule');

SELECT
    *
FROM
    surgeon_schedule
ORDER BY
    surgery_date;
----------------------------------------------------------

EXEC dbms_output.put_line('CREATE VIEW Patient_Surgery_View');

CREATE OR REPLACE VIEW patient_surgery_view AS
    SELECT
        pos.patient_name,
        ss.surgery_date,
        pos.patient_type,
        ss.name
    FROM
        post_surgery_ward pos,
        surgeon_schedule ss
    WHERE
        (
            pos.post_admission_date = ss.surgery_date
            AND   (
                (
                    pos.patient_type = 'Cardiac'
                    AND   (
                        ss.name = 'Dr. Charles'
                        OR    ss.name = 'Dr. Gower'
                    )
                )
                OR    (
                    pos.patient_type = 'General'
                    AND   (
                        ss.name = 'Dr. Smith'
                        OR    ss.name = 'Dr. Richards'
                    )
                )
                OR    (
                    pos.patient_type = 'Neuro'
                    AND   (
                        ss.name = 'Dr. Taylor'
                        OR    ss.name = 'Dr. Rutherford'
                    )
                )
            )
        )
        OR    (
            pos.post_admission_date + 2 = ss.surgery_date
            AND   pos.scount = 2
            AND   (
                (
                    pos.patient_type = 'Cardiac'
                    AND   (
                        ss.name = 'Dr. Charles'
                        OR    ss.name = 'Dr. Gower'
                    )
                )
                OR    (
                    pos.patient_type = 'General'
                    AND   (
                        ss.name = 'Dr. Smith'
                        OR    ss.name = 'Dr. Richards'
                    )
                )
                OR    (
                    pos.patient_type = 'Neuro'
                    AND   (
                        ss.name = 'Dr. Taylor'
                        OR    ss.name = 'Dr. Rutherford'
                    )
                )
            )
        )
    ORDER BY
        ss.surgery_date ASC;

----------------------------------------------------------

EXEC dbms_output.put_line('Patient_Surgery_View');

SELECT
    *
FROM
    patient_surgery_view;
    
----------------------------------------------------------
@query;
----------------------------------------------------------
@dropall;
