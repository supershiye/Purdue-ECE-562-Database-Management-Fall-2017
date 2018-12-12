rem EE 562 Project 2
rem Ye Shi
rem shi349
DROP TABLE Issue;

DROP TABLE Pending_Request;

DROP TABLE Books;

DROP TABLE Author;

DROP TABLE Borrower;

DROP TRIGGER Trg_Charge;

DROP TRIGGER Trg_Maxbooks;

DROP TRIGGER Trg_Notcharge;

DROP TRIGGER Trg_Renew;

DROP TRIGGER Trg_Rule6;

DROP FUNCTION Fun_Issue_Book;

DROP FUNCTION Fun_Issue_Anyedition;

DROP FUNCTION Fun_Most_Popular;

DROP TYPE Pop_Table;

DROP TYPE Pop_Type;

DROP FUNCTION Fun_Mon2num;

-- DROP FUNCTION fun_popular_table;

DROP FUNCTION Fun_Return_Book;

-- DROP FUNCTION fun_123;

DROP FUNCTION Fun_Most_Popular_Noprint;

DROP PROCEDURE Pro_Listborr;

DROP PROCEDURE Pro_Listborr_Mon;

DROP PROCEDURE Pro_Print_Borrower;

DROP PROCEDURE Pro_Print_Fine;

DROP PROCEDURE Pro_List_Popular;

DROP PROCEDURE Pro_List_Mon_Popular;