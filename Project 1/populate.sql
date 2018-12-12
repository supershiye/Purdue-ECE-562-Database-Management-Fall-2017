rem EE 562 Project 1
rem Ye Shi
rem shi349

-- insert student data
INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        1,
        'John',
        'EE',
        'FR',
        18
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        2,
        'Tim',
        'EE',
        'FR',
        19
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        3,
        'Richard',
        'EE',
        'SO',
        20
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        4,
        'Edward',
        'EE',
        'SO',
        21
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        5,
        'Alber',
        'CS',
        'JR',
        22
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        6,
        'Mary',
        'EE',
        'JR',
        22
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        7,
        'Jack',
        'EE',
        'SR',
        23
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        8,
        'Julian',
        'EE',
        'SR',
        22
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        9,
        'Sam',
        'CS',
        'SR',
        24
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        10,
        'Ram',
        'EE',
        'SR',
        23
);

INSERT INTO Student (
        Sid,
        Sname,
        Major,
        Levels,
        Age
) VALUES (
        11,
        'Rick',
        'EE',
        'SR',
        24
);

-- insert faculty data

INSERT INTO Faculty ( Fid,Fname,Dept ) VALUES ( 1,'Prof. James','EE' );

INSERT INTO Faculty ( Fid,Fname,Dept ) VALUES ( 2,'Prof. Brown','CS' );

INSERT INTO Faculty ( Fid,Fname,Dept ) VALUES ( 3,'Prof. Wasfi','EE' );

INSERT INTO Faculty ( Fid,Fname,Dept ) VALUES ( 4,'Prof. Latif','EE' );

INSERT INTO Faculty ( Fid,Fname,Dept ) VALUES ( 5,'Prof. Rutherford','MA' );

-- insert class data

ALTER SESSION SET Nls_Date_Format = 'HH24:MI';

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE101',
        '9:00',
        117,
        1
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE102',
        '10:00',
        '117',
        '2'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE104',
        '13:00',
        '117',
        '3'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE151',
        '15:00',
        '117',
        '4'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE261',
        '09:00',
        '118',
        '4'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'MA365',
        '10:00',
        '118',
        '5'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE347',
        '13:00',
        '118',
        '1'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'EE404',
        '09:00',
        '115',
        '3'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'MA448',
        '12:00',
        '115',
        '5'
);

INSERT INTO Class (
        Cnum,
        Meets_At,
        Room,
        Fid
) VALUES (
        'CS480',
        '13:00',
        '115',
        '1'
);

-- insert enrolled data

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE101',1 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE101',2 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE101',3 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE101',4 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE102',1 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE102',2 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE102',4 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE104',1 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE104',2 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE104',3 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE151',4 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE151',5 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE151',6 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',1 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',2 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',3 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',4 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',5 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE261',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA365',5 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA365',6 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA365',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA365',8 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE347',5 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE347',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE347',8 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE347',9 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE404',9 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE404',10 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'EE404',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA448',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA448',8 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA448',9 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'MA448',10 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'CS480',6 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'CS480',7 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'CS480',8 );

INSERT INTO Enrolled ( Cnum,Sid ) VALUES ( 'CS480',9 );

-- insert prerequisite data

INSERT INTO Prerequisite ( Cnum,Prereq ) VALUES ( 'CS480','EE347' );

INSERT INTO Prerequisite ( Cnum,Prereq ) VALUES ( 'EE347','EE261' );

INSERT INTO Prerequisite ( Cnum,Prereq ) VALUES ( 'EE261','EE151' );

INSERT INTO Prerequisite ( Cnum,Prereq ) VALUES ( 'CS480','MA365' );