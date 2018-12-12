rem EE 562 Project 2
rem Ye Shi
rem shi349
CREATE TABLE books (
    book_id               NUMBER NOT NULL,
    book_title            VARCHAR2(50),
    author_id             NUMBER,
    year_of_publication   NUMBER,
    edition               NUMBER,
    status                VARCHAR2(20) NOT NULL,
    PRIMARY KEY ( book_id ),
    CHECK (
            status = 'charged'
        OR
            status = 'not charged'
    ) -- rule 1
);

CREATE TABLE author (
    author_id   NUMBER PRIMARY KEY,
    name        VARCHAR2(20)
);

ALTER TABLE books
    ADD FOREIGN KEY ( author_id )
        REFERENCES author ( author_id );

CREATE TABLE borrower (
    borrower_id   NUMBER PRIMARY KEY,
    name          VARCHAR2(30),
    status        VARCHAR2(20) NOT NULL,
    CHECK (
            status = 'faculty'
        OR
            status = 'student'
    ) -- rule 2
);

CREATE TABLE issue (
    book_id       NUMBER,
    borrower_id   NUMBER,
    issue_date    DATE,
    return_date   DATE DEFAULT NULL,-- rule 8
    FOREIGN KEY ( book_id )
        REFERENCES books ( book_id ),
    FOREIGN KEY ( borrower_id )
        REFERENCES borrower ( borrower_id ),
    CHECK (
        issue_date < return_date
    ),
    PRIMARY KEY ( book_id,borrower_id,issue_date )
);

CREATE TABLE pending_request (
    book_id        NUMBER,
    requester_id   NUMBER,
    request_date   DATE,
    issue_date     DATE,
    FOREIGN KEY ( book_id )
        REFERENCES books ( book_id ),
    FOREIGN KEY ( requester_id )
        REFERENCES borrower ( borrower_id ),
    UNIQUE ( book_id,requester_id,request_date )
);