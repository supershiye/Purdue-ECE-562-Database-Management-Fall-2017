@DROPALL
@CREATEtable
@POPULATE
@TRG
@FUN
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
-- test fun_popular_table
INSERT INTO issue VALUES (
    '3',
    '1',
    '11-oct-2016',
    '12-oct-2016'
);
INSERT INTO issue VALUES (
    '3',
    '2',
    '11-oct-2016',
    '12-oct-2016'
);

select * from table(FUN_most_popular('oct'));


-- test pro_print_borrower
exec pro_print_borrower;

-- test pro_print_fine
exec pro_print_fine(current_date);

-- test pro_listborr_mon
exec pro_listborr_mon(1,'oct');

exec pro_listborr;

exec Pro_list_popular;


--select * from issue where EXTRACT(month FROM issue_date) = MONTH('March' + ' 1 2014') ;
--select * from issue where issue_date= to_date('Mar') ;
--set serveroutput off;
--select * from issue where rownum < 2 order by issue_date asc;
--delete from issue;
-- begin dbms_output.put_line('fake_Reach the maxium number'); end;