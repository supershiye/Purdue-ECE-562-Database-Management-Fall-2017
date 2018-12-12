rem EE 562 Project 1
rem Ye Shi
rem shi349

/* Create Student Table */
CREATE TABLE Student (
        Sid      NUMBER,
        Sname    VARCHAR2(15),
        Major    VARCHAR2(3),
        Levels   VARCHAR2(2),
        Age      NUMBER,
        PRIMARY KEY ( Sid )
);

/* Create Faculty Table */

CREATE TABLE Faculty (
        Fid     NUMBER,
        Fname   VARCHAR2(20),
        Dept    VARCHAR2(5),
        PRIMARY KEY ( Fid )
);

/* Create Class Table */

CREATE TABLE Class (
        Cnum       VARCHAR2(6),
        Meets_At   DATE,
        Room       VARCHAR2(6),
        Fid        NUMBER,
        PRIMARY KEY ( Cnum ),
        FOREIGN KEY ( Fid )
                REFERENCES Faculty
);

/* Create Enrolled Table*/

CREATE TABLE Enrolled (
        Cnum   VARCHAR2(6),
        Sid    NUMBER,
        FOREIGN KEY ( Cnum )
                REFERENCES Class,
        FOREIGN KEY ( Sid )
                REFERENCES Student,
        PRIMARY KEY ( Cnum,Sid )
);

/*Create Prerequisite Table*/

CREATE TABLE Prerequisite (
        Cnum     VARCHAR2(6),
        Prereq   VARCHAR2(6),
        FOREIGN KEY ( Cnum )
                REFERENCES Class,
        FOREIGN KEY ( Prereq )
                REFERENCES Class ( Cnum ),
        PRIMARY KEY ( Cnum,Prereq )
);