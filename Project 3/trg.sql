rem EE 562 Project 3
rem Ye Shi
rem shi349

----------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_sw2sb AFTER
    INSERT ON screening_ward
    FOR EACH ROW
ENABLE BEGIN
    UPDATE screening_bed sb
        SET
            sb.status = 1
    WHERE
        sb.bed_no =:new.bed_no;
-- 1 occupied,0 available

END;
/

CREATE OR REPLACE TRIGGER trg_pre2sb AFTER
    INSERT ON pre_surgery_ward
    FOR EACH ROW
ENABLE DECLARE
    spbn   NUMBER; -- screenning patient bed no
BEGIN
    SELECT
        ssx.bed_no
    INTO
        spbn
    FROM
        (
            SELECT
                sx.bed_no
            FROM
                screening_ward sx
            WHERE
                sx.patient_name =:new.patient_name
            ORDER BY sx.s_admission_date DESC
        ) ssx
    WHERE
        ROWNUM < 2;

    UPDATE screening_bed sb
        SET
            sb.status = 0
    WHERE
        sb.bed_no = spbn;

END;
/

----------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_pre2preb AFTER
    INSERT ON pre_surgery_ward
    FOR EACH ROW
ENABLE DECLARE BEGIN
    UPDATE pre_surgery_bed preb
        SET
            preb.status = 1
    WHERE
        preb.bed_no =:new.bed_no;
-- 1 occupied,0 available

END;
/

CREATE OR REPLACE TRIGGER trg_pre2post AFTER
    INSERT ON post_surgery_ward
    FOR EACH ROW
ENABLE
    WHEN ( new.scount = 1 )
DECLARE
    spbn   NUMBER; -- screenning patient bed no
BEGIN

            SELECT
                sx.bed_no
                    INTO
        spbn
            FROM
                pre_surgery_ward sx
            WHERE
                sx.patient_name =:new.patient_name
                and sx.pre_admission_date = :new.post_admission_date-2;


    UPDATE pre_surgery_bed sb
        SET
            sb.status = 0
    WHERE
        sb.bed_no = spbn;

END;
/

----------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_gen BEFORE
    INSERT ON general_ward
    FOR EACH ROW
ENABLE DECLARE
    gname   VARCHAR2(30);
    gdate   DATE;
    gtype   VARCHAR2(10);
    sbno    NUMBER; -- screening bed no
    CURSOR gen_cur IS
        SELECT DISTINCT
            gx.patient_name,
            gx.g_admission_date,
            gx.patient_type
        FROM
            general_ward gx
        WHERE
                gx.g_admission_date <=:new.g_admission_date - 3
                and gx.g_admission_date >=:new.g_admission_date-13
                
            AND
                gx.patient_name NOT IN (
                    SELECT
                        sx.patient_name
                    FROM
                        screening_ward sx
                        where sx.s_admission_date >=:new.g_admission_date-13
                )
        ORDER BY gx.g_admission_date ASC;

    CURSOR sbed_cur IS
        SELECT
            sx.bed_no
        FROM
            screening_bed sx
        WHERE
            sx.status = 0;

BEGIN
    BEGIN
        dbms_output.put_line('Trg_Gen');
        OPEN sbed_cur;
--    IF
--        sbed_cur%notfound
--    THEN
--        dbms_output.put_line('No bed in Screening Ward is abailable!');
--    ELSE
        OPEN gen_cur;
        LOOP
            FETCH gen_cur INTO gname,gdate,gtype;
            FETCH sbed_cur INTO sbno;
            EXIT WHEN gen_cur%notfound OR sbed_cur%notfound;
            dbms_output.put_line('Patient '
             || gname
             || ' goes to screening bed '
             || sbno
             ||' on '
             ||:new.g_admission_date);
            INSERT INTO screening_ward VALUES (
                gname,
                :new.g_admission_date,
                sbno,
                gtype
            );

        END LOOP;

        CLOSE gen_cur;
        CLOSE sbed_cur;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No bed or patient in General Ward is available.');
    END;
--    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_scr BEFORE
    INSERT ON screening_ward
    FOR EACH ROW
ENABLE DECLARE
    sname    VARCHAR2(30);
    sdate    DATE;
    stype    VARCHAR2(10);
    prebno   NUMBER; -- pre bed no
    CURSOR scr_cur IS
        SELECT DISTINCT
            sx.patient_name,
            sx.s_admission_date,
            sx.patient_type
        FROM
            screening_ward sx
        WHERE
                sx.s_admission_date <=:new.s_admission_date - 3
--            AND
--            sx.s_admission_date >=:new.s_admission_date-13
            and
                sx.patient_name NOT IN (
                    SELECT
                        prex.patient_name
                    FROM
                        pre_surgery_ward prex
                        where prex.pre_admission_date >=:new.s_admission_date-13
                )
                and
                sx.patient_name  not in(
                SELECT DISTINCT
                        patient_name
                    FROM
                        post_surgery_ward
                        where
                        post_admission_date >=:new.s_admission_date-15
                )
                
        ORDER BY sx.s_admission_date DESC;

    CURSOR prebed_cur IS
        SELECT
            prex.bed_no
        FROM
            pre_surgery_bed prex
        WHERE
            prex.status = 0;

    CURSOR scr4d_cur IS
        SELECT DISTINCT
            pc.patient_name, sw.PATIENT_TYPE
        FROM
            patient_chart pc,
            screening_ward sw
        WHERE
            (
            sw.patient_name = pc.patient_name
            and
            pc.pdate >= sw.s_admission_date
            and
                    pc.pdate <:new.s_admission_date
                AND
                    pc.pdate >:new.s_admission_date - 4
            ) AND (
                    pc.temperature <= 100
                AND
                    pc.temperature >= 97
            ) AND (
                    pc.bp >= 110
                AND
                    pc.bp <= 140);
                    
                    CURSOR pre2_cur IS
        SELECT DISTINCT
            prx.patient_name,
            prx.patient_type,
            prx.pre_admission_date
        FROM
            pre_surgery_ward prx
        WHERE
                prx.pre_admission_date+2 <=:new.s_admission_date
            AND
                prx.patient_name NOT IN (
                    SELECT
                        pos.patient_name
                    FROM
                        post_surgery_ward pos
                        where post_admission_date <= :new.s_admission_date 
                        and post_admission_date>:new.s_admission_date - 15 -- xxxx
                );
                    pname   VARCHAR2(30);
    ptype   VARCHAR2(10);
    pdate date;

BEGIN
    BEGIN
        dbms_output.put_line('Trg_Scr');
        OPEN prebed_cur;
--    IF
--        prebed_cur%notfound
--    THEN
--        dbms_output.put_line('No bed in Pre Surgery Ward is abailable!');
--    ELSE
        OPEN scr_cur;
        LOOP
            FETCH scr_cur INTO sname,sdate,stype;
            FETCH prebed_cur INTO prebno;
            EXIT WHEN scr_cur%notfound OR prebed_cur%notfound;
            begin
            dbms_output.put_line('Patient '
             || sname
             || ' goes to pre bed '
             || prebno);
            INSERT INTO pre_surgery_ward VALUES (
                sname,
                sdate+3,
                prebno,
                stype
            );
exception
                WHEN dup_val_on_index THEN
                    NULL;

end;
        END LOOP;

        CLOSE scr_cur;
        CLOSE prebed_cur;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No bed or patient in Screening Ward is available.');
    END;
--    END IF;

    BEGIN
        OPEN scr4d_cur;
--    if scr4d_cur%notfound   THEN
--        dbms_output.put_line('No patient in Screening ward is able to have a surgery!');
--    else
        LOOP
            FETCH scr4d_cur INTO sname,stype;
            EXIT WHEN scr4d_cur%notfound;
            BEGIN
                INSERT INTO post_surgery_ward VALUES (
                    sname,
                    :new.s_admission_date - 1,
                    :new.s_admission_date + 1,
                    1,
                    stype
                );

            EXCEPTION
                WHEN dup_val_on_index THEN
                    NULL;
            END;

        END LOOP;

    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('No patient staying 4 days is available.');
    END;

    CLOSE scr4d_cur;
    
        OPEN pre2_cur;
    LOOP
        FETCH pre2_cur INTO pname,ptype,pdate;
        EXIT WHEN pre2_cur%notfound;
        begin
        INSERT INTO post_surgery_ward VALUES (
            pname,
            pdate+2,
            pdate+4,
            1,
            ptype
        );
        EXCEPTION
            WHEN dup_val_on_index THEN
                NULL;
                end;
    END LOOP;

END;
/

----------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_post BEFORE
    INSERT ON post_surgery_ward
    FOR EACH ROW
ENABLE
    WHEN ( new.scount = 1 )
DECLARE
    CURSOR sec_cur IS
        SELECT
            ps.patient_name,
            ps.post_admission_date,
            ps.patient_type
        FROM
            patient_chart pc,
            post_surgery_ward ps
        WHERE
                ps.scount = 1
            AND
                ps.patient_name = ps.patient_name
            AND
                pc.pdate >= ps.post_admission_date
            AND
                pc.pdate <= ps.discharge_date
            AND (
                    ps.patient_type = 'Cardiac'
                OR
                    ps.patient_type = 'Neuro'
            ) AND NOT (
                    ps.patient_type = 'Neuro'
                AND (
                        pc.temperature <= 100
                    AND
                        pc.temperature >= 97
                ) AND (
                        pc.bp >= 110
                    AND
                        pc.bp <= 140
                )
            ) AND NOT (
                    ps.patient_type = 'Cardiac'
                AND (
                        pc.bp >= 110
                    AND
                        pc.bp <= 140
                )
            ) AND
                pc.patient_name IN (
                    SELECT
                        patient_name
                    FROM
                        post_surgery_ward
                )
        GROUP BY
            ps.patient_name,
            ps.post_admission_date,
            ps.patient_type
        ORDER BY ps.patient_name ASC;

    pname   VARCHAR2(30);
    pdate   DATE;
    ptype   VARCHAR2(10);
BEGIN
    OPEN sec_cur;
    LOOP
        FETCH sec_cur INTO pname,pdate,ptype;
        EXIT WHEN sec_cur%notfound;
--dbms_output.put_line(pname||' '||ptype);
--delete from  Post_Surgery_Ward where patient_name = 'Nobody';
        UPDATE post_surgery_ward
            SET
                scount = 2,
                discharge_date = pdate + 4
        WHERE
                patient_name = pname
            AND
                patient_type = ptype
            AND
                discharge_date > pdate;
--delete from Post_Surgery_Ward where patient_name = pname and patient_type = ptype;

    END LOOP;


END;
/
----------------------------------------------------------

--CREATE OR REPLACE TRIGGER trg_pre BEFORE
--    INSERT ON pre_surgery_ward
--    FOR EACH ROW
--ENABLE DECLARE
--    CURSOR pre2_cur IS
--        SELECT DISTINCT
--            prx.patient_name,
--            prx.patient_type,
--            prx.pre_admission_date
--        FROM
--            pre_surgery_ward prx
--        WHERE
--                prx.pre_admission_date <:new.pre_admission_date - 2
--            AND
--                prx.patient_name NOT IN (
--                    SELECT
--                        pos.patient_name
--                    FROM
--                        post_surgery_ward pos
--                        where post_admission_date <= :new.pre_admission_date 
--                        and post_admission_date>:new.pre_admission_date - 15 -- xxxx
--                );
--
--    pname   VARCHAR2(30);
--    ptype   VARCHAR2(10);
--    pdate date;
--BEGIN
--    OPEN pre2_cur;
--    LOOP
--        FETCH pre2_cur INTO pname,ptype,pdate;
--        EXIT WHEN pre2_cur%notfound;
--        begin
--        INSERT INTO post_surgery_ward VALUES (
--            pname,
--            pdate+2,
--            pdate+4,
--            1,
--            ptype
--        );
--        EXCEPTION
--            WHEN dup_val_on_index THEN
--                NULL;
--                end;
--    END LOOP;
--
--END;
--/
----------------------------------------------------------

CREATE OR REPLACE FUNCTION rand_ill ( abc NUMBER ) RETURN VARCHAR2 IS

    ill   VARCHAR2(10);
    ran   NUMBER := round(dbms_random.value(0,3) );
BEGIN
    IF
        ran <= 1
    THEN
        ill := 'Cardiac';
    ELSIF ran <= 2 THEN
        ill := 'Neuro';
    ELSIF ran <= 3 THEN
        ill := 'General';
    END IF;

    RETURN ill;
END;
/


CREATE OR REPLACE TRIGGER trg_pc BEFORE
    INSERT ON general_ward
    FOR EACH ROW
ENABLE DECLARE
    tmin    NUMBER := 95;
    tmax    NUMBER := 102;
    bpmin   NUMBER := 100;
    bpmax   NUMBER := 150;
BEGIN
    FOR i IN 0..39 LOOP
        BEGIN
            INSERT INTO patient_chart VALUES (
                :new.patient_name,
                :new.g_admission_date + i,
                round(dbms_random.value(tmin,tmax) ),
                round(dbms_random.value(bpmin,bpmax) )
            );

        EXCEPTION
            WHEN dup_val_on_index THEN
                NULL;
        END;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE pop_patient_input
    AS
BEGIN
    FOR i IN 0..60 LOOP
        IF
            i = 0 OR i = 20 OR i = 40
        THEN
            INSERT INTO patient_input VALUES (
                'Bob',
                TO_DATE('2005-11-06','yyyy-MM-dd') + i,
                rand_ill(1)
            );

        END IF;

        FOR j IN 0..25 LOOP
--            dbms_output.put_line(i || ' ' || j);
            IF
                MOD(i,26) = j
--                i = j
            THEN
                INSERT INTO patient_input VALUES (
                    chr(65 + j),
                    TO_DATE('2005-11-06','yyyy-MM-dd') + i,
                    rand_ill(1)
                );
                                INSERT INTO patient_input VALUES (
                    chr(65 + j),
                    TO_DATE('2005-04-01','yyyy-MM-dd') + i,
                    rand_ill(1)
                );
                

            END IF;
        END LOOP;

    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE pop_patient_chart AS

    tmin    NUMBER := 95;
    tmax    NUMBER := 102;
    bpmin   NUMBER := 100;
    bpmax   NUMBER := 150;
BEGIN
    FOR i IN 0..40 LOOP
            IF
                i = 0 OR i = 20
            THEN
                INSERT INTO patient_input VALUES (
                    'Bob',
                    TO_DATE('2005-11-25','yyyy-MM-dd') + i,
                    rand_ill(1)
                );

            END IF;

            IF
                i >= 2
            THEN
                INSERT INTO patient_chart VALUES (
                    'Bob',
                    TO_DATE('2005-11-25','yyyy-MM-dd') + i,
                    round(dbms_random.value(tmin,tmax) ),
                    round(dbms_random.value(bpmin,bpmax) )
                );

            END IF;

    END LOOP;

    FOR i IN 0..25 LOOP
        FOR j IN 0..25 LOOP
--            dbms_output.put_line(i || ' ' || j);
            IF
--                                mod(I,26) = J
                i = j
            THEN
                INSERT INTO patient_input VALUES (
                    chr(65 + j),
                    TO_DATE('2005-12-06','yyyy-MM-dd') + i,
                    rand_ill(1)
                );

            END IF;

            IF
                i >= j
            THEN
                INSERT INTO patient_chart VALUES (
                    chr(65 + j),
                    TO_DATE('2005-12-06','yyyy-MM-dd') + i,
                    round(dbms_random.value(tmin,tmax) ),
                    round(dbms_random.value(bpmin,bpmax) )
                );

            END IF;

        END LOOP;
    END LOOP;

END;
/
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_db AS

    CURSOR pi_cur IS
        SELECT
            *
        FROM
            patient_input
        ORDER BY general_admission_date ASC;

    pname   VARCHAR2(30);
    pdate   DATE;
    ptype   VARCHAR2(10);
BEGIN
    OPEN pi_cur;
    LOOP
        FETCH pi_cur INTO pname,pdate,ptype;
        EXIT WHEN pi_cur%notfound;
        INSERT INTO general_ward VALUES ( pname,pdate,ptype );

        dbms_output.put_line('Patient ' || pname || ' goes to General Ward');
    END LOOP;
        delete from patient_input where patient_name ='G' and( General_ADMISSION_DATE = '03-JAN-06' or General_ADMISSION_DATE = '29-MAY-05');
        delete from patient_input where patient_name ='H' and( General_ADMISSION_DATE = '04-JAN-06' or General_ADMISSION_DATE = '30-MAY-05');
            delete from patient_input where patient_name ='I' and( General_ADMISSION_DATE = '05-JAN-06' or General_ADMISSION_DATE = '31-MAY-05');
    delete from general_ward where patient_name ='G' and( G_ADMISSION_DATE = '03-JAN-06' or G_ADMISSION_DATE = '29-MAY-05');
        delete from general_ward where patient_name ='H' and( G_ADMISSION_DATE = '04-JAN-06' or G_ADMISSION_DATE = '30-MAY-05');
            delete from general_ward where patient_name ='I' and( G_ADMISSION_DATE = '05-JAN-06' or G_ADMISSION_DATE = '31-MAY-05');
END;
/

----------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_dr
    AS
BEGIN
    FOR i IN 0..364 LOOP
        IF
            MOD(i,7) = 0
        THEN
            INSERT INTO dr_schedule VALUES (
                1,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                2,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                3,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                4,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                5,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                6,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 1 THEN
            INSERT INTO dr_schedule VALUES (
                2,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                3,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                4,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                5,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                6,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 2 THEN
            INSERT INTO dr_schedule VALUES (
                3,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                4,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                5,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                6,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                1,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 3 THEN
            INSERT INTO dr_schedule VALUES (
                4,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                5,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                6,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                1,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                2,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 4 THEN
            INSERT INTO dr_schedule VALUES (
                5,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                6,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                1,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                2,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                3,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 5 THEN
            INSERT INTO dr_schedule VALUES (
                6,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                1,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                2,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                3,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                4,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSIF MOD(i,7) = 6 THEN
            INSERT INTO dr_schedule VALUES (
                1,
                1,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                2,
                2,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                3,
                3,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                4,
                4,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO dr_schedule VALUES (
                5,
                5,
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        END IF;
    END LOOP;

    UPDATE dr_schedule ds
        SET
            ds.name = 'James'
    WHERE
        ds.name = '1';

    UPDATE dr_schedule ds
        SET
            ds.name = 'Robert'
    WHERE
        ds.name = '2';

    UPDATE dr_schedule ds
        SET
            ds.name = 'Mike'
    WHERE
        ds.name = '3';

    UPDATE dr_schedule ds
        SET
            ds.name = 'Adams'
    WHERE
        ds.name = '4';

    UPDATE dr_schedule ds
        SET
            ds.name = 'Tracey'
    WHERE
        ds.name = '5';

    UPDATE dr_schedule ds
        SET
            ds.name = 'Rick'
    WHERE
        ds.name = '6';

    UPDATE dr_schedule ds
        SET
            ds.ward = 'General_Ward'
    WHERE
        ds.ward = '1';

    UPDATE dr_schedule ds
        SET
            ds.ward = 'Screening_Ward'
    WHERE
        ds.ward = '2';

    UPDATE dr_schedule ds
        SET
            ds.ward = 'Pre_Surgery_Ward'
    WHERE
        ds.ward = '3';

    UPDATE dr_schedule ds
        SET
            ds.ward = 'Post_Surgery_Ward'
    WHERE
        ds.ward = '4';

    UPDATE dr_schedule ds
        SET
            ds.ward = 'Surgery'
    WHERE
        ds.ward = '5';

END;
/
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE populate_surgeon AS
    dd   NUMBER;
BEGIN
    FOR i IN 0..364 LOOP
        dd := MOD(i,7);
        IF
            dd = 1 OR dd = 2 OR dd = 5
        THEN --Su Mon Th
            INSERT INTO surgeon_schedule VALUES (
                'Dr. Smith',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO surgeon_schedule VALUES (
                'Dr. Charles',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO surgeon_schedule VALUES (
                'Dr. Taylor',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        ELSE
            INSERT INTO surgeon_schedule VALUES (
                'Dr. Richards',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO surgeon_schedule VALUES (
                'Dr. Gower',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

            INSERT INTO surgeon_schedule VALUES (
                'Dr. Rutherford',
                TO_DATE('2005-01-01','yyyy-MM-dd') + i
            );

        END IF;

    END LOOP;
END;
/
----------------------------------------------------------

CREATE OR REPLACE FUNCTION check_schedule RETURN NUMBER IS

    CURSOR dr_cur IS
        SELECT
            *
        FROM
            dr_schedule
        ORDER BY name,duty_date,ward;
--        cursor sur_cur is 
--        select * from SURGEON_SCHEDULE order by name,surgery_date;

    jname     VARCHAR2(30);
    ward      VARCHAR2(20);
    drdate    DATE;
    er        NUMBER := 0;
    counter   NUMBER := 0;
    flagdr    NUMBER := 0;
    cflag     NUMBER := 0;
    nflag     NUMBER := 0;
    flagsh    NUMBER := 0;
BEGIN
    dbms_output.enable(
        buffer_size   => NULL
    );
    OPEN dr_cur;
    LOOP
        FETCH dr_cur INTO jname,ward,drdate;
        EXIT WHEN dr_cur%notfound;
        SELECT
            COUNT(*)
        INTO
            er
        FROM
            dr_schedule dr
        WHERE
                dr.name = jname
            AND
                dr.ward = ward
            AND (
                    dr.duty_date <= drdate + 1
--                                OR Dr.Duty_Date = Drdate
                AND
                    dr.duty_date >= drdate - 1
            );

        er := er - 1;
--                                Dbms_Output.Put_Line(Er);
        IF
            er = 3
        THEN
            dbms_output.put_line('----------------------------------');
            dbms_output.put_line('Dr_Schedule does not satisfiy. ' || er);
            dbms_output.put_line(jname
             || ' '
             || ward
             || ' '
             || drdate);

            flagdr := 1;
        END IF;

        counter := counter + 1;
--                Dbms_Output.Put_Line(counter);
    END LOOP;

--        Dbms_Output.Put_Line('Dr_Schedule Total Check: ' || Counter);

    CLOSE dr_cur;
    FOR i IN 0..364 LOOP
--                Dd := MOD(I,7);
        SELECT
            COUNT(*)
        INTO
            cflag
        FROM
            surgeon_schedule ss
        WHERE
                surgery_date = TO_DATE('2005-01-01','yyyy-MM-dd') + i
            AND (
                    ss.name = 'Dr. Charles'
                OR
                    ss.name = 'Dr. Gower'
            );

        SELECT
            COUNT(*)
        INTO
            nflag
        FROM
            surgeon_schedule ss
        WHERE
                surgery_date = TO_DATE('2005-01-01','yyyy-MM-dd') + i
            AND (
                    ss.name = 'Dr. Taylor'
                OR
                    ss.name = 'Dr. Rutherford'
            );

        IF
            cflag < 1 OR nflag < 1
        THEN
            flagsh := 1;
            dbms_output.put_line('----------------------------------');
            dbms_output.put_line('Surgeon_Schedule does not satisfiy. ');
            dbms_output.put_line(TO_DATE('2005-01-01','yyyy-MM-dd') + i);
        END IF;

    END LOOP;

    IF
        flagdr = 1 OR flagsh = 1
    THEN
        raise_application_error(-20001,'Dr_Schedule and/or Surgeon_Schedule  does not satisfiy.');
    ELSE
        dbms_output.put_line('Both Dr_Schedule and Surgeon_Schedule satisfiy. ');
    END IF;

    RETURN flagdr;
END;
/