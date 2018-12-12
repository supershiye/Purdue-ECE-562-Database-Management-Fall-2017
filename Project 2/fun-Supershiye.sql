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
        RETURN Result;
END;
/

create or replace function (mon varchar2(10))
return number is book_id1 number;


CREATE OR REPLACE FUNCTION Fun_123 ( Book_Id1 NUMBER ) RETURN VARCHAR2 IS
        Bk_Status   VARCHAR2(20);
BEGIN
        Dbms_Output.Put_Line(Book_Id1);
        SELECT
                Bx.Status
        INTO
                Bk_Status
        FROM
                Books Bx
        WHERE
                Bx.Book_Id = Book_Id1;

        Dbms_Output.Put_Line(Bk_Status);
        RETURN Bk_Status;
END;
/