@create
@populate
@trg
@fun
INSERT INTO issue VALUES (
    '3',
    '1',
    '11-oct-2017',
    NULL
);

INSERT INTO issue VALUES (
    '1',
    '1',
    '11-oct-2017',
    NULL
);
-- check rule 3
select * from issue ix where ix.return_date is NULL;

INSERT INTO issue VALUES (
    '2',
    '1',
    '11-oct-2017',
    NULL
);
-- check trg_notcharge

UPDATE issue ix
    SET
        ix.return_date = '12-oct-2017'
WHERE
        ix.book_id = 3
    AND
        ix.borrower_id = 1;

-- check trg_renew

UPDATE issue ix
    SET
        ix.return_date = '12-oct-2017'
WHERE
        ix.book_id = 1
    AND
        ix.borrower_id = 1;

INSERT INTO issue VALUES (
    '1',
    '1',
    '12-oct-2017',
    NULL
);

insert into pending_request values (
    '1',
    '2',
    '10-oct-2017',
    NULL
);

UPDATE issue ix
    SET
        ix.return_date = '13-oct-2017'
WHERE
        ix.book_id = 1
    AND
        ix.borrower_id = 1
        and ix.issue_date = '12-oct-2017';

INSERT INTO issue VALUES (
    '1',
    '2',
    '14-oct-2017',
    NULL
);

-- test fun_issue_book
DECLARE
        Result   VARCHAR2(20);
BEGIN
        Result := Fun_Issue_Book(3,15,Current_Date);
END;
/

-- test fun_issue_anyedition
DECLARE
        Result   VARCHAR2(20);
BEGIN
        Result := Fun_Issue_Anyedition (
       4,
        'ARCHITECTURE',
        'CLOIS KICKLIGHTER' ,
        Current_Date
);
END;
/


delete from issue;
-- begin dbms_output.put_line('fake_Reach the maxium number'); end;
@dropall