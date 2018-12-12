rem EE 562 Project 2
rem Ye Shi
rem shi349
-- Project 2:
-- Populate tables
-- Insert records into Author
INSERT INTO author VALUES ( 1,'C.J. DATES' );

INSERT INTO author VALUES ( 2,'H. ANTON' );

INSERT INTO author VALUES ( 3,'ORACLE PRESS' );

INSERT INTO author VALUES ( 4,'IEEE' );

INSERT INTO author VALUES ( 5,'C.J. CATES' );

INSERT INTO author VALUES ( 6,'W. GATES' );

INSERT INTO author VALUES ( 7,'CLOIS KICKLIGHTER' );

INSERT INTO author VALUES ( 8,'J.R.R. TOLKIEN' );

INSERT INTO author VALUES ( 9,'TOM CLANCY' );

INSERT INTO author VALUES ( 10,'ROGER ZELAZNY' );

-- Insert records into Books

INSERT INTO books VALUES (
    1,
    'DATA MANAGEMENT',
    1,
    1998,
    3,
    'not charged'
);

INSERT INTO books VALUES (
    2,
    'CALCULUS',
    2,
    1995,
    7,
    'not charged'
);

INSERT INTO books VALUES (
    3,
    'ORACLE',
    3,
    1999,
    8,
    'not charged'
);

INSERT INTO books VALUES (
    4,
    'IEEE MULTIMEDIA',
    4,
    2001,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    5,
    'MIS MANAGEMENT',
    5,
    1990,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    6,
    'CALCULUS II',
    2,
    1997,
    3,
    'not charged'
);

INSERT INTO books VALUES (
    7,
    'DATA STRUCTURE',
    6,
    1992,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    8,
    'CALCULUS III',
    2,
    1999,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    9,
    'CALCULUS III',
    2,
    2000,
    2,
    'not charged'
);

INSERT INTO books VALUES (
    10,
    'ARCHITECTURE',
    7,
    1977,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    11,
    'ARCHITECTURE',
    7,
    1980,
    2,
    'not charged'
);

INSERT INTO books VALUES (
    12,
    'ARCHITECTURE',
    7,
    1985,
    3,
    'not charged'
);

INSERT INTO books VALUES (
    13,
    'ARCHITECTURE',
    7,
    1990,
    4,
    'not charged'
);

INSERT INTO books VALUES (
    14,
    'ARCHITECTURE',
    7,
    1995,
    5,
    'not charged'
);

INSERT INTO books VALUES (
    15,
    'ARCHITECTURE',
    7,
    2000,
    6,
    'not charged'
);

INSERT INTO books VALUES (
    16,
    'THE HOBBIT',
    8,
    1960,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    17,
    'THE BEAR AND THE DRAGON',
    9,
    2000,
    1,
    'not charged'
);

INSERT INTO books VALUES (
    18,
    'NINE PRINCES IN AMBER',
    10,
    1970,
    1,
    'not charged'
);

-- Insert records into Borrower

INSERT INTO borrower VALUES ( 1,'BRAD KICKLIGHTER','student' );

INSERT INTO borrower VALUES ( 2,'JOE Studio','student' );

INSERT INTO borrower VALUES ( 3,'GEDDY LEE','student' );

INSERT INTO borrower VALUES ( 4,'JOE Ferrari','faculty' );

INSERT INTO borrower VALUES ( 5,'ALBERT EINSTEIN','faculty' );

INSERT INTO borrower VALUES ( 6,'MIKE POWELL','student' );

INSERT INTO borrower VALUES ( 7,'DAVID GOWER','faculty' );

INSERT INTO borrower VALUES ( 8,'ALBERT SUNARTO','student' );

INSERT INTO borrower VALUES ( 9,'GEOFFERY BYCOTT','faculty' );

INSERT INTO borrower VALUES ( 10,'JOHN KACSZYCA','student' );

INSERT INTO borrower VALUES ( 11,'IAN LAMB','faculty' );

INSERT INTO borrower VALUES ( 12,'ANTONIO AKE','student' );