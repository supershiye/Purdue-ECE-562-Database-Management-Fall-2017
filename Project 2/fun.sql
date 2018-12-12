rem EE 562 Project 2
rem Ye Shi
rem shi349
CREATE OR REPLACE FUNCTION Fun_Issue_Book (
        Borrower_Id1    NUMBER,
        Book_Id1        NUMBER,
        Current_Date1   DATE -- current_date is reserved by PL/SQL
) RETURN NUMBER IS
        Result      NUMBER;
        Bk_Status   VARCHAR2(20);
BEGIN

        SELECT
                Bx.Status
        INTO
                Bk_Status
        FROM
                Books Bx
        WHERE
                Bx.Book_Id = Book_Id1;

        -- Dbms_Output.Put_Line(Bk_Status);

        IF
                Bk_Status = 'charged'
        THEN
                INSERT INTO Pending_Request VALUES (
                        Book_Id1,
                        Borrower_Id1,
                        Current_Date1,
                        NULL
                );

                Result := 0;
        ELSIF Bk_Status = 'not charged' THEN
                update pending_request set issue_date =current_date1 where book_id=book_id1
                and requester_id = borrower_id1;
                                dbms_output.put_line('Book ID '||Book_id1||' issued to '||'Borrower ID '||Borrower_Id1);

                INSERT INTO Issue VALUES (
                        Book_Id1,
                        Borrower_Id1,
                        Current_Date1,
                        NULL
                );

                Result := 1;
        ELSE
                Raise_Application_Error(-20003,'The book does not exist.');
        END IF;

        RETURN Result;
END;
/

CREATE OR REPLACE FUNCTION Fun_Issue_Anyedition (
        Borrower_Id1    NUMBER,
        Book_Title1     VARCHAR2,
        Author_Name1    VARCHAR2,
        Current_Date1   DATE
) RETURN NUMBER IS
        Result          NUMBER;
        Book_Id1        NUMBER;
        Book_Edition1   NUMBER;
BEGIN

        BEGIN
                SELECT
                        MAX(Bx.Edition)
                INTO
                        Book_Edition1
                FROM
                        Books Bx,
                        Author Ax
                WHERE
                                Bx.Author_Id = Ax.Author_Id
                        AND
                                Ax.Name = Author_Name1
                        AND
                                Bx.Book_Title = Book_Title1
                        AND
                                Bx.Status = 'not charged';

        EXCEPTION
                WHEN No_Data_Found THEN
                        Raise_Application_Error(-20003,'All the books are charged.');
        END;
        if book_edition1 is null then
        dbms_output.put_line('All the books are charged.');
        -- put the earlist issued same book into pending request
                        SELECT
                        *
                INTO
                        book_Id1
                from(        select  bx.book_id
                FROM
                        issue ix,
                        books bx,
                        author ax
                WHERE
                                ix.book_id=bx.book_id
                        AND bx.book_title = book_title1
                        and ax.name = author_name1
                                        ORDER BY issue_Date ASC)
                        where
                                ROWNUM < 2;

                        Result := Fun_Issue_Book(Borrower_Id1,Book_Id1,Current_Date1);

        else

        SELECT
                Bx.Book_Id
        INTO
                Book_Id1
        FROM
                Books Bx,
                Author Ax
        WHERE
                        Bx.Author_Id = Ax.Author_Id
                AND
                        Ax.Name = Author_Name1
                AND
                        Bx.Book_Title = Book_Title1
                AND
                        Bx.Edition = Book_Edition1;

                Result := Fun_Issue_Book(Borrower_Id1,Book_Id1,Current_Date1);

        end if;
        RETURN Result;
END;
/

-- funcs for most popular
CREATE OR REPLACE FUNCTION fun_mon2num ( mon VARCHAR2 ) RETURN NUMBER IS
    mon_num   NUMBER;
BEGIN
    CASE
        WHEN upper(mon) = 'JAN' THEN
            mon_num := 1;
        WHEN upper(mon) = 'FEB' THEN
            mon_num := 2;
        WHEN upper(mon) = 'MAR' THEN
            mon_num := 3;
        WHEN upper(mon) = 'APR' THEN
            mon_num := 4;
        WHEN upper(mon) = 'MAY' THEN
            mon_num := 5;
        WHEN upper(mon) = 'JUN' THEN
            mon_num := 6;
        WHEN upper(mon) = 'JUL' THEN
            mon_num := 7;
        WHEN upper(mon) = 'AUG' THEN
            mon_num := 8;
        WHEN upper(mon) = 'SEP' THEN
            mon_num := 9;
        WHEN upper(mon) = 'OCT' THEN
            mon_num := 10;
        WHEN upper(mon) = 'NOV' THEN
            mon_num := 11;
        WHEN upper(mon) = 'DEC' THEN
            mon_num := 12;
        ELSE
            raise_application_error(-20004,'The input requires to be a month as "Jan"');
    END CASE;

    RETURN mon_num;
END;
/
CREATE OR REPLACE TYPE pop_type AS OBJECT (
    book_id   NUMBER,
    month     NUMBER,
    year      NUMBER
);
/
CREATE OR REPLACE TYPE pop_table AS
    TABLE OF pop_type;
/    
create or replace function fun_most_popular(mon varchar2)
return pop_table pipelined as 
pop_rows pop_type;
mon_num number;
cursor year_cur is
select distinct extract(year from ix.issue_date) from issue ix;
year1   number;
begin
dbms_output.put_line('Most Popular Books');
dbms_output.put_line('Year  Month  Book_id');

mon_num:=fun_mon2num(mon);
open year_cur;
loop fetch year_cur into year1;
exit when year_cur%notfound;
--year1:=2017;
--dbms_output.put_line(year1);
for myrow in
(select ix.book_id as book_id, mon_num as month,year1 as year 
from issue ix 
where extract(month from ix.issue_date) = mon_num
and extract(year from ix.issue_date) = year1
having count(book_id) = (select max(count(iy.book_id)) from  issue iy where  extract(month from iy.issue_date) = mon_num
and extract(year from iy.issue_date) = year1
group by iy.book_id)
group by ix.book_id)
 loop
 pop_rows := pop_type(myrow.book_id, myrow.month,myrow.year);
 --if myrow.book_id  is not null then
 dbms_output.put_line(myrow.year||'    '|| myrow.month||'   '||myrow.book_id);
 --end if;
 pipe row (pop_rows);
 end loop;
 
end loop;
close year_cur;
return;
end;
/
---- discuss in class
--CREATE OR REPLACE FUNCTION FUN_most_popular (mon varchar2)
--return sys_refcursor is
--book_id_list sys_refcursor;
--begin
--open book_id_list for select book_id from table(fun_popular_table(mon));
--
--end;
--/

CREATE OR REPLACE FUNCTION Fun_Return_Book
( Book_Id1 NUMBER,Return_Date1 DATE ) 
RETURN NUMBER IS
        Result          NUMBER;
        Requester_Id1   NUMBER;
BEGIN
        UPDATE Issue Ix
                SET
                        Ix.Return_Date = Return_Date1
        WHERE
                        Ix.Book_Id = Book_Id1
                AND
                        Ix.Return_Date IS NULL;

        BEGIN
        select * into Requester_Id1 from
               (SELECT
                        Px.Requester_Id
--                INTO
--                        Requester_Id1
                FROM
                        Pending_Request Px
                WHERE
                                Px.Book_Id = Book_Id1

                ORDER BY Request_Date ASC)
                where rownum<2;
                dbms_output.put_line('Book ID '||Book_id1||' goes to '||'Borrower ID '||Requester_Id1);
        result:=           fun_Issue_Book (
        requester_Id1 ,
        Book_Id1    ,
        return_Date1);
        return result;
        EXCEPTION
                WHEN No_Data_Found THEN
                        RETURN 1;
        END;

END;
/

--CREATE OR REPLACE FUNCTION Fun_123 ( Book_Id1 NUMBER ) RETURN VARCHAR2 IS
--        Bk_Status   VARCHAR2(20);
--BEGIN
--        Dbms_Output.Put_Line(Book_Id1);
--        SELECT
--                Bx.Status
--        INTO
--                Bk_Status
--        FROM
--                Books Bx
--        WHERE
--                Bx.Book_Id = Book_Id1;
--
--        Dbms_Output.Put_Line(Bk_Status);
--        RETURN Bk_Status;
--END;
--/