rem EE 562 Project 2
rem Ye Shi
rem shi349

@Dropall;
EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('1. Popluate the Books,Author and Borrower tables.');

EXEC Dbms_Output.Put_Line('============================================');

@Createtable;

@Populate;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('2. Execute all the triggers.');

EXEC Dbms_Output.Put_Line('============================================');

@Trg;

EXEC Dbms_Output.Put_Line('     Execute all the functions.');

@Fun;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('3. Use the function fun_issue_book() to populate the Issue and Pending_request tables');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('     * 1: issued successfully; 0: failed to issue');

@Mydata;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('4. Use the function fun_issue_anyedition() to isert the following records in your sample database for testing');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('     * 1: issued successfully; 0: failed to issue');

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                2,
                'DATA MANAGEMENT',
                'C.J. DATES',
                TO_DATE('03/03/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                4,
                'CALCULUS',
                'H. ANTON',
                TO_DATE('03/04/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                5,
                'ORACLE',
                'ORACLE PRESS',
                TO_DATE('03/04/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                10,
                'IEEE MULTIMEDIA',
                'IEEE',
                TO_DATE('02/27/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                2,
                'MIS MANAGEMENT',
                'C.J. CATES',
                TO_DATE('05/03/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                4,
                'CALCULUS II',
                'H. ANTON',
                TO_DATE('03/04/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                10,
                'ORACLE',
                'ORACLE PRESS',
                TO_DATE('03/04/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                5,
                'IEEE MULTIMEDIA',
                'IEEE',
                TO_DATE('02/26/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                2,
                'DATA STRUCTURE',
                'W. GATES',
                TO_DATE('03/03/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/
DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                4,
                'CALCULUS III',
                'H. ANTON',
                TO_DATE('04/04/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                11,
                'ORACLE',
                'ORACLE PRESS',
                TO_DATE('03/08/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Issue_Anyedition(
                6,
                'IEEE MULTIMEDIA',
                'IEEE',
                TO_DATE('02/17/05','MM/DD/YY')
        );

        Dbms_Output.Put_Line(Re);
END;
/

EXEC Dbms_Output.Put_Line('     Compile all the procedures.');

@Pro;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('5. Execute pro_print_borrower.');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Pro_Print_Borrower;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('6. Execute pro_print_fine');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Pro_Print_Fine(Current_Date);

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('7. ues the function fun_return_book() to return books with book_id 1,2,4,10. Also,specify the returns date as the second parameter');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('     * 1: returned successfully; 0: failed to return');

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Return_Book(1,Current_Date);
        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Return_Book(2,Current_Date);
        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Return_Book(4,Current_Date);
        Dbms_Output.Put_Line(Re);
END;
/

DECLARE
        Re   NUMBER;
BEGIN
        Re := Fun_Return_Book(10,Current_Date);
        Dbms_Output.Put_Line(Re);
END;
/

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('8. Print Pending_request table and the Issue table');

EXEC Dbms_Output.Put_Line('============================================');

SELECT
        *
FROM
        Pending_Request;

SELECT
        *
FROM
        Issue;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('9. Execute pro_listborr_mon for the month of February and March,for a give borrow_id.(Here I use 2)');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Pro_Listborr_Mon(2,'feb');

EXEC Pro_Listborr_Mon(2,'mar');

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('10. Execute pro_listborr');

EXEC Dbms_Output.Put_Line('============================================');

EXECUTE Pro_Listborr;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('11. Execute pro_list_popular');

EXEC Dbms_Output.Put_Line('============================================');

EXECUTE Pro_List_Popular;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('12. Print the average time a requester waits in the pending_request table');

EXEC Dbms_Output.Put_Line('============================================');

SELECT
        AVG(Px.Issue_Date - Px.Request_Date) AS Ave_Waiting_Time
FROM
        Pending_Request Px
WHERE
        Px.Issue_Date IS NOT NULL;

EXEC Dbms_Output.Put_Line('============================================');

EXEC Dbms_Output.Put_Line('13. Print the name and the borrower_id of the person who has waited the longest amount of time for any book.');

EXEC Dbms_Output.Put_Line('============================================');

SELECT
        Bx.Name,
        Bx.Borrower_Id
FROM
        (
                SELECT
                        Requester_Id,
                        ( Px.Issue_Date - Px.Request_Date ) AS Waiting_Time
                FROM
                        Pending_Request Px
                WHERE
                        Px.Issue_Date IS NOT NULL
                ORDER BY Waiting_Time
        ) Wx,
        Borrower Bx
WHERE
                Wx.Requester_Id = Bx.Borrower_Id
        AND
                ROWNUM < 2;
                
@Dropall;