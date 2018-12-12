rem EE 562 Project 3
rem Ye Shi
rem shi349

----------------------------------------------------------
create table query_10(
patient_name varchar2(30),
icost number,
patient_type varchar2(10),
cflag   number
);



--create table query_9(
--indate date,
--primary key(indate)
--);


create table query_8(
ward varchar2(20),
indate date,
primary key(ward,indate)
);

create table patient_schedule(
patient_name varchar2(30),
ward varchar2(20),
adate date,
primary key (patient_name,ward,adate)
);

create table query_4(
sdate date,
edate date,
sname varchar2(30),
primary key(sdate, edate,sname)
);
create table query_1(
patient_name varchar2(30),
total_number_of_visits number,
average_stay number,
r_total_cost number,
p_total_cost number,
primary key(patient_name)
);
----------------------------------------------------------
CREATE TABLE screening_bed (
    bed_no   NUMBER,
    status   NUMBER,-- 1 occupied,0 available
    PRIMARY KEY ( bed_no ),
    CHECK (
            bed_no > 0
        OR
            bed_no < 6
    ) -- 5 beds
);

INSERT INTO screening_bed VALUES ( 1,0 );

INSERT INTO screening_bed VALUES ( 2,0 );

INSERT INTO screening_bed VALUES ( 3,0 );

INSERT INTO screening_bed VALUES ( 4,0 );

INSERT INTO screening_bed VALUES ( 5,0 );

CREATE TABLE pre_surgery_bed (
    bed_no   NUMBER,
    status   NUMBER,-- 1 occupied,0 available
    PRIMARY KEY ( bed_no ),
    CHECK (
            bed_no > 0
        OR
            bed_no < 5
    ) -- 4 beds
);

INSERT INTO pre_surgery_bed VALUES ( 1,0 );

INSERT INTO pre_surgery_bed VALUES ( 2,0 );

INSERT INTO pre_surgery_bed VALUES ( 3,0 );

INSERT INTO pre_surgery_bed VALUES ( 4,0 );

--create table patient_status(
--    patient_name       VARCHAR2(30),
--    status varchar2(10),
--    update_date   DATE,
--    PRIMARY KEY (patient_name)
--);

----------------------------------------------------------

CREATE TABLE general_ward (
    patient_name       VARCHAR2(30),
    g_admission_date   DATE,
    patient_type       VARCHAR2(10),
    PRIMARY KEY ( patient_name,g_admission_date )
);

CREATE TABLE screening_ward (
    patient_name       VARCHAR2(30),
    s_admission_date   DATE,
    bed_no             NUMBER,
    patient_type       VARCHAR2(10),
    PRIMARY KEY ( patient_name,s_admission_date ),
--    FOREIGN KEY ( patient_name )
--        REFERENCES general_ward ( patient_name ),
    FOREIGN KEY ( bed_no )
        REFERENCES screening_bed ( bed_no )
);

CREATE TABLE pre_surgery_ward (
    patient_name         VARCHAR2(30),
    pre_admission_date   DATE,
    bed_no               NUMBER,
    patient_type         VARCHAR2(10),
    PRIMARY KEY ( patient_name,pre_admission_date ),
--    FOREIGN KEY ( patient_name )
--        REFERENCES screening_ward ( patient_name ),
    FOREIGN KEY ( bed_no )
        REFERENCES pre_surgery_bed ( bed_no )
);

CREATE TABLE post_surgery_ward (
    patient_name          VARCHAR2(30),
    post_admission_date   DATE,
    discharge_date        DATE,
    scount                NUMBER,
    patient_type          VARCHAR2(10),
    PRIMARY KEY ( patient_name,post_admission_date ),
--    FOREIGN KEY ( patient_name )
--        REFERENCES pre_surgery_ward ( patient_name ),
    CHECK (
        scount < 3
    )
);
----------------------------------------------------------

CREATE TABLE patient_chart (
    patient_name   VARCHAR2(30),
    pdate          DATE,
    temperature    NUMBER,
    bp             NUMBER,
    PRIMARY KEY ( patient_name,pdate )
--    FOREIGN KEY ( patient_name )
--        REFERENCES general_ward ( patient_name )
);

CREATE TABLE dr_schedule (
    name        VARCHAR2(30),
    ward        VARCHAR2(20),
    duty_date   DATE,
    PRIMARY KEY ( name,ward,duty_date )
);

CREATE TABLE surgeon_schedule (
    name           VARCHAR2(30),
    surgery_date   DATE,
    PRIMARY KEY ( name,surgery_date )
);

CREATE TABLE patient_input (
    patient_name             VARCHAR2(30),
    general_admission_date   DATE,
    patient_type             VARCHAR2(10),
    PRIMARY KEY ( patient_name,general_admission_date ),
    CHECK (
            patient_type = 'Cardiac'
        OR
            patient_type = 'Neuro'
        OR
            patient_type = 'General'
    )
);
----------------------------------------------------------