rem EE 562 Project 2
rem Ye Shi
rem shi349
CREATE OR REPLACE PROCEDURE Pro_Print_Borrower IS

        CURSOR Bor_Cur IS
                SELECT
                        Book_Id,
                        Borrower_Id,
                        Issue_Date
                FROM
                        Issue
                WHERE
                        Return_Date IS NULL;

        Bkid      NUMBER;
        Brid      NUMBER;
        Idate     DATE;
        Day_Num   NUMBER;
        Brname    VARCHAR2(20);
        Bktitle   VARCHAR2(100);
        Bkspace   NUMBER;
BEGIN
        Dbms_Output.Put_Line('Borrower Name   Book Title                  <=5 days <=10 days <=15 days >15 days');
        Dbms_Output.Put_Line('----------------   ---------------------  ---------- ----------- ----------- ---------');
        OPEN Bor_Cur;
        LOOP
                FETCH Bor_Cur INTO Bkid,Brid,Idate;
                EXIT WHEN Bor_Cur%Notfound;
                SELECT
                        Bx.Name
                INTO
                        Brname
                FROM
                        Borrower Bx
                WHERE
                        Borrower_Id = Brid;

                SELECT
                        Book_Title
                INTO
                        Bktitle
                FROM
                        Books
                WHERE
                        Bkid = Book_Id;

                Day_Num := Floor(Current_Date - Idate);
--day_num:= 20;
                IF
                        Day_Num <= 5
                THEN
                        Bkspace := 10;
                ELSIF Day_Num <= 10 THEN
                        Bkspace := 20;
                ELSIF Day_Num <= 15 THEN
                        Bkspace := 38;
                ELSE
                        Bkspace := 55;
                END IF;

                Dbms_Output.Put_Line(Rpad(Brname,20)
                 || Rpad(Bktitle,20)
                 || Lpad(Day_Num,Bkspace) );

        END LOOP;

END;
/

--select floor(current_date- issue_date) as days from issue;

CREATE OR REPLACE PROCEDURE Pro_Print_fine( A_Date IN DATE ) IS

        Brid      NUMBER;
        Brname    VARCHAR2(20);
        Bkid      NUMBER;
        Day_Num   NUMBER;
        Idate     DATE;
        rdate     date;
        Fmont     NUMBER;
        CURSOR Bor_Cur IS
                SELECT
                        Book_Id,
                        Borrower_Id,
                        Issue_Date,
                        return_date
                FROM
                        Issue
                WHERE
                        Return_Date IS NULL or (return_date-issue_date) >5;
                        
--CURSOR Bor_paid_cur IS
--                SELECT
--                        Book_Id,
--                        Borrower_Id,
--                        Issue_Date,
--                        (return_date-issue_date)*5 as fine
--                FROM
--                        Issue
--                WHERE
--                        Return_Date is not NULL and (return_date-issue_date) >5;    

BEGIN
        Dbms_Output.Put_Line('Borrower Name   Book ID  Issue_date  fine');
        Dbms_Output.Put_Line('----------------   --------  ----------- ----');
        OPEN Bor_Cur;
        LOOP
                FETCH Bor_Cur INTO Bkid,Brid,Idate, rdate;
                EXIT WHEN Bor_Cur%Notfound;
                SELECT
                        Bx.Name
                INTO
                        Brname
                FROM
                        Borrower Bx
                WHERE
                        Borrower_Id = Brid;
--select book_title into bktitle from books where bkid=book_id;
        if rdate is null then
                Day_Num := Floor(A_Date - Idate);
                else Day_Num := Floor(rDate - Idate);
                end if;
                IF
                        Day_Num > 5
                THEN
                        Fmont := ( Day_Num - 5 ) * 5;
                        Dbms_Output.Put_Line(Rpad(Brname,20)
                         || Rpad(Bkid,12)
                         || Idate
                         || Lpad(Fmont,10) );

                END IF;

        END LOOP;
        close bor_cur;
--        open Bor_paid_cur;
--        loop fetch bor_paid_cur into Bkid,Brid,Idate,fmont;
--        EXIT WHEN Bor_Cur%Notfound;
--                               Dbms_Output.Put_Line(Rpad(Brname,20)
--                         || Rpad(Bkid,12)
--                         || Idate
--                         || Lpad(Fmont,5) );
--                         end loop;
--                         close bor_paid_cur;
END;
/

-- exec pro_print_borrower(current_date);

CREATE OR REPLACE PROCEDURE Pro_Listborr_Mon (
        Brid   IN NUMBER,
        Mon    IN VARCHAR2
) IS

        Mon_Num   NUMBER;
        CURSOR Ix_Cur IS
                SELECT
                        Ix.Book_Id,
                        Ix.Issue_Date,
                        Ix.Return_Date
                FROM
                        Issue Ix
                WHERE
                        Ix.Borrower_Id = Brid
                        and
                         extract(month from ix.issue_date) = Fun_Mon2num(Mon);

        Brname    VARCHAR2(20);
        Bkid      NUMBER;
        Bktitle   VARCHAR2(100);
        Idate     DATE;
        Rdate     DATE;
BEGIN
        Dbms_Output.Put_Line('Borrower ID  Borrower Name   Book ID  Book Title  Issue Date  Return Date');
        Dbms_Output.Put_Line('------------  ----------------   --------  ----------  -----------  ------------');
        --Mon_Num := Fun_Mon2num(Mon);
        OPEN Ix_Cur;
        LOOP
                FETCH Ix_Cur INTO Bkid,Idate,Rdate;
                EXIT WHEN Ix_Cur%Notfound;
                SELECT
                        Bx.Name
                INTO
                        Brname
                FROM
                        Borrower Bx
                WHERE
                        Bx.Borrower_Id = Brid;

                SELECT
                        Bi.Book_Title
                INTO
                        Bktitle
                FROM
                        Books Bi
                WHERE
                        Bi.Book_Id = Bkid;

                Dbms_Output.Put_Line(Brid
                 || '     '
                 || Rpad(Brname,25)
                 || Bkid
                 || '   '
                 || Rpad(Bktitle,30)
                 || Idate
                 || '  '
                 || Rdate);

        END LOOP;

        CLOSE Ix_Cur;
END;
/

CREATE OR REPLACE PROCEDURE Pro_Listborr IS

        CURSOR Ix_Cur IS
                SELECT
                ix.borrower_id,
                        Ix.Book_Id,
                        Ix.Issue_Date
                FROM
                        Issue Ix
                WHERE
                        Ix.Return_Date IS NULL;
        brname varchar2(20);
        brid number;
        Bkid    NUMBER;
        Idate   DATE;
BEGIN
        Dbms_Output.Put_Line('Borrower Name  Book ID  Issue Date');
        Dbms_Output.Put_Line('---------------- --------  -----------');
        OPEN Ix_Cur;
        LOOP
                FETCH Ix_Cur INTO brid,Bkid,Idate;
                EXIT WHEN Ix_Cur%Notfound;
                select bx.name into brname from borrower bx where bx.borrower_id = brid;
                Dbms_Output.Put_Line( rpad(brname,20)|| Bkid || '    ' || Idate);
        END LOOP;

END;
/

-- EXEC Pro_Listborr;

create or replace function fun_most_popular_noprint(mon varchar2)
return pop_table pipelined as 
pop_rows pop_type;
mon_num number;
cursor year_cur is
select distinct extract(year from ix.issue_date) from issue ix;
year1   number;
begin
--dbms_output.put_line('Most Popular Books');
--dbms_output.put_line('Year  Month  Book_id');

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
 --dbms_output.put_line(myrow.year||'    '|| myrow.month||'   '||myrow.book_id);
 --end if;
 pipe row (pop_rows);
 end loop;
 
end loop;
close year_cur;
return;
end;
/


CREATE OR REPLACE PROCEDURE Pro_List_Mon_Popular ( Mon IN VARCHAR2 ) IS

        CURSOR Pop_Cur IS
                SELECT
                        Px.Year,
                        Px.Month,
                        Px.Book_Id
                FROM
                        TABLE ( Fun_Most_Popular_Noprint(Mon) ) Px;

        Year1     NUMBER;
        Mon1      NUMBER;
        Bkid      NUMBER;
        Bktitle   VARCHAR2(100);
        Auid      NUMBER;
        Aname     VARCHAR2(20);
        Bknum     NUMBER;
        monstr varchar2(10);
        flag number :=1;
BEGIN
CASE
        WHEN upper(mon) = 'JAN' THEN
            monstr := 'Januray';
        WHEN upper(mon) = 'FEB' THEN
           monstr :='February';
        WHEN upper(mon) = 'MAR' THEN
            monstr := 'March';
        WHEN upper(mon) = 'APR' THEN
           monstr := 'April';
        WHEN upper(mon) = 'MAY' THEN
            monstr := 'May';
        WHEN upper(mon) = 'JUN' THEN
            monstr := 'June';
        WHEN upper(mon) = 'JUL' THEN
            monstr := 'July';
        WHEN upper(mon) = 'AUG' THEN
            monstr :='August';
        WHEN upper(mon) = 'SEP' THEN
            monstr :='September';
        WHEN upper(mon) = 'OCT' THEN
            monstr := 'October';
        WHEN upper(mon) = 'NOV' THEN
            monstr :='November';
        WHEN upper(mon) = 'DEC' THEN
            monstr := 'December';
        ELSE
            raise_application_error(-20004,'The input requires to be a month as "Jan"');
    END CASE;

        OPEN Pop_Cur;
        LOOP
                FETCH Pop_Cur INTO Year1,Mon1,Bkid;
                EXIT WHEN Pop_Cur%Notfound;
                flag :=0;
                SELECT
                        Ax.Author_Id,
                        Ax.Name,
                        Bx.Book_Title
                INTO
                        Auid,Aname,Bktitle
                FROM
                        Author Ax,
                        Books Bx
                WHERE
                                Bx.Book_Id = Bkid
                        AND
                                Ax.Author_Id = Bx.Author_Id;

                SELECT
                        COUNT(*)
                INTO
                        Bknum
                FROM
                        Books Bx
                WHERE
                                Bx.Author_Id = Auid
                        AND
                                Bx.Book_Title = Bktitle;

                Dbms_Output.Put_Line(Rpad(Monstr,15)
                 || rpad(year1,10)
                 || Rpad(Aname,20)
                 || Rpad(Bknum,2) );

        END LOOP;
if flag = 1 then
                Dbms_Output.Put_Line(Rpad(Monstr,15));
                end if;
END;
/
-- exec Pro_list_mon_popular('oct');

CREATE OR REPLACE PROCEDURE Pro_List_Popular 
is 
begin
dbms_output.put_line('Month      Year      Author Name      # of Editions');
dbms_output.put_line('---------  -----     --------------     -------------');
Pro_list_mon_popular('jan');
Pro_list_mon_popular('feb');
Pro_list_mon_popular('mar');
Pro_list_mon_popular('apr');
Pro_list_mon_popular('may');
Pro_list_mon_popular('Jun');
Pro_list_mon_popular('jul');
Pro_list_mon_popular('aug');
Pro_list_mon_popular('sep');
Pro_list_mon_popular('oct');
Pro_list_mon_popular('nov');
Pro_list_mon_popular('dec');
end;
/











