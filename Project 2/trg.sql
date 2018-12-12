rem EE 562 Project 2
rem Ye Shi
rem shi349
CREATE OR REPLACE TRIGGER trg_maxbooks BEFORE--instead of
    INSERT ON issue
    FOR EACH ROW
ENABLE DECLARE
    total_books   NUMBER := 0;
    status        VARCHAR2(20);
   -- charge_flag   number :=0;
BEGIN
    -- dbms_output.put_line('asdfasdf');
    BEGIN
        SELECT
            COUNT(ix.borrower_id),
            bx.status
        INTO
            total_books,status
        FROM
            issue ix,
            borrower bx
        WHERE
                ix.borrower_id =:new.borrower_id
            AND
                bx.borrower_id = ix.borrower_id
            AND
                ix.return_date IS NULL
        GROUP BY
            ix.borrower_id,
            bx.status;

    EXCEPTION
        WHEN no_data_found THEN
            status := NULL;
            total_books := 0;
    END;

--    dbms_output.put_line('status '
--     || status
--     || '; total books '
--     || total_books);
     
    IF
        ( status = 'student' AND total_books >= 2 ) OR ( status = 'faculty' AND total_books >= 3 )
    THEN
       -- charge_flage :=1;
        raise_application_error(-20001,'Rule 3: Reach the maxium book number');
    END IF;

END;
/
-- needs to be fixed
CREATE OR REPLACE TRIGGER trg_charge before
    INSERT ON issue
    FOR EACH ROW
ENABLE declare 
    total_books   NUMBER := 0;
    status        VARCHAR2(20);
BEGIN
 BEGIN
        SELECT
            COUNT(ix.borrower_id),
            bx.status
        INTO
            total_books,status
        FROM
            issue ix,
            borrower bx
        WHERE
                ix.borrower_id =:new.borrower_id
            AND
                bx.borrower_id = ix.borrower_id
            AND
                ix.return_date IS NULL
        GROUP BY
            ix.borrower_id,
            bx.status;

    EXCEPTION
        WHEN no_data_found THEN
            status := NULL;
            total_books := 0;
    END;
     IF
        ( status = 'student' AND total_books >= 2 ) OR ( status = 'faculty' AND total_books >= 3 )
    THEN
       -- charge_flage :=1;
        raise_application_error(-20001,'Rule 3: Reach the maxium book number');
    END IF;
    UPDATE books bx
        SET
            bx.status = 'charged'
    WHERE
            bx.book_id =:new.book_id;  
END;
/

-- backup trg_charge
--CREATE OR REPLACE TRIGGER trg_charge after
--    INSERT ON issue
--    FOR EACH ROW
--ENABLE BEGIN
--    UPDATE books bx
--        SET
--            bx.status = 'charged'
--    WHERE
--            bx.book_id =:new.book_id;  
--END;
--/
CREATE OR REPLACE TRIGGER trg_notcharge before
    UPDATE ON issue
    FOR EACH ROW
ENABLE BEGIN
    UPDATE books bx
        SET
            bx.status = 'not charged'
    WHERE
        bx.book_id =:old.book_id;
END;
/

CREATE OR REPLACE TRIGGER trg_renew BEFORE
    INSERT ON issue
    FOR EACH ROW
ENABLE DECLARE
redate date;
    flag7   NUMBER := 0; -- rule 7
        reflag   NUMBER := 1; -- renew flag
--    flag6i   number :=0; -- rule 6
--    flag6p number := 0;
BEGIN
-- check renew action
begin
        select ix.return_date into redate from issue ix where ix.return_date = :new.issue_date 
        and ix.book_id = :new.book_id and ix.borrower_id= :new.borrower_id;
        exception
        when no_data_found then
        reflag :=0;
        end;
if reflag = 1 then
            SELECT
        COUNT(*)
    INTO
        flag7
    FROM
        pending_request px
    WHERE
            px.book_id =:new.book_id
            and
        px.issue_date is null;
            IF
        flag7 > 0
    THEN
        raise_application_error(-20002,'Rule 7: The book is in pending request');
    END IF;
       end if;
        



--    SELECT
--        COUNT(*)
--    INTO
--        flag6i
--    FROM
--        issue ix
--    WHERE
--            ix.borrower_id =:new.borrower_id
--            and ix.return_date is null;
--    
--    select count(*)       
--    into flag6p
--    from pending_request px
--    where px.requester_id =:new.borrower_id
--    and px.issue_date is null;
--    
--    if flag6p+flag6i > 7 then
--    raise_application_error(-20005,'Rule 6: Pending and Issued is greater than 7.');
--    
--    end if;
    
END;
/

CREATE OR REPLACE TRIGGER trg_rule6 BEFORE
    INSERT ON pending_request
    FOR EACH ROW
ENABLE DECLARE
bkname varchar2(100);
--bkid number;
--brid number;
    flag6a   NUMBER := 1; -- same book
        flag6b   NUMBER := 1; -- same book

    flag6i   number :=0; -- rule 6
    flag6p number := 0;
BEGIN
begin
    SELECT
 bx.book_title
    INTO
        bkname
    FROM
       issue ix,
       books bx
    WHERE
            ix.book_id =:new.book_id
        and bx.book_id = ix.book_id
        and
            ix.borrower_id =:new.requester_id
            and  ix.return_date is null;
            exception
            when no_data_found
            then
            flag6a := 0;
            end;
        begin    
                SELECT
 bx.book_title
    INTO
        bkname
    FROM
       pending_request px,
       books bx
    WHERE
            px.book_id =:new.book_id
        and bx.book_id = px.book_id
        and
            px.requester_id =:new.requester_id
            and  px.issue_date is null;
            exception
            when no_data_found
            then
            flag6b := 0;
            end;


    IF
        flag6a = 1 or flag6b = 1
    THEN
        raise_application_error(-20002,'Rule 6: Cannot pend your current borrowing or pending book');
    END IF;

    SELECT
        COUNT(*)
    INTO
        flag6i
    FROM
        issue ix
    WHERE
            ix.borrower_id =:new.requester_id
            and ix.return_date is null;
    
    select count(*)       
    into flag6p
    from pending_request px
    where px.requester_id =:new.requester_id
    and px.issue_date is null;
    
    if flag6p+flag6i > 7 then
    raise_application_error(-20005,'Rule 6: Pending and Issued is greater than 7.');
    
    end if;
    
END;
/