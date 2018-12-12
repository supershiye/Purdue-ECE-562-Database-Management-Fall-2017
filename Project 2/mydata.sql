rem EE 562 Project 2
rem Ye Shi
rem shi349
declare
re number;
begin
re :=fun_issue_book(1, 1, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(2, 2, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(3, 3, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(4, 4, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(5, 5, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(6, 6, to_date('02/10/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(7, 1, to_date('02/11/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(8, 2, to_date('02/12/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(9, 3, to_date('02/13/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(10, 4, to_date('02/14/03','MM/DD/YY'));
dbms_output.put_line(re);
re :=fun_issue_book(11, 10, to_date('02/15/03','MM/DD/YY'));
dbms_output.put_line(re);
end;
/