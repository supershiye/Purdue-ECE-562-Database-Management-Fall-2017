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
create or replace function fun_popular_table(mon varchar2)
return pop_table pipelined as 
pop_rows pop_type;
mon_num number;
cursor year_cur is
select distinct extract(year from ix.issue_date) from issue ix;
year1   number;
begin
mon_num:=fun_mon2num(mon);
open year_cur;
loop fetch year_cur into year1;
exit when year_cur%notfound;
--year1:=2017;
dbms_output.put_line(year1);
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
 pipe row (pop_rows);
 end loop;
 
end loop;
close year_cur;
return;
end;
/


CREATE OR REPLACE FUNCTION FUN_most_popular (mon varchar2)
return sys_refcursor is book_id1 number;
mon_num number;
year2 number;
book_id_list sys_refcursor;
cursor year_cur is
select distinct extract(year from ix.issue_date) from issue ix;
year1   number;--year_cur%ROWTYPE;
begin
case 
when upper(mon) = 'JAN' then mon_num := 1;
when upper(mon) = 'FEB' then mon_num := 2;
when upper(mon) = 'MAR' then mon_num := 3;
when upper(mon) = 'APR' then mon_num := 4;
when upper(mon) = 'MAY' then mon_num := 5;
when upper(mon) = 'JUN' then mon_num := 6;
when upper(mon) = 'JUL' then mon_num := 7;
when upper(mon) = 'AUG' then mon_num := 8;
when upper(mon) = 'SEP' then mon_num := 9;
when upper(mon) = 'OCT' then mon_num := 10;
when upper(mon) = 'NOV' then mon_num := 11;
when upper(mon) = 'DEC' then mon_num := 12;
else raise_application_error(-20004,'The input requires to be a month as "Jan"');
end case;
dbms_output.put_line('Year    Month    Book_id');
-- return mon_num;]
open year_cur;

loop fetch year_cur into year1;
exit when year_cur%notfound;
--year2 :=year1;
open book_id_list for 

select ix.book_id from issue ix where extract(month from ix.issue_date) = 10
and extract(year from ix.issue_date) =2017
having count(book_id) = (select max(count(iy.book_id)) from  issue iy where  extract(month from iy.issue_date) = 10
and extract(year from iy.issue_date) =2017
group by iy.book_id)
group by ix.book_id;

--select ix.book_id from issue ix where extract(month from ix.issue_date) = mon_num
--and extract(year from ix.issue_date) = year1
--having count(book_id) = (select max(count(iy.book_id)) from  issue iy where  extract(month from iy.issue_date) = mon_num
--and extract(year from iy.issue_date) = year1
--group by iy.book_id)
--group by ix.book_id;
-- dbms_output.put_line(year1||'    '||Mon_num||'    ');
dbms_output.put_line(year1||'    '||Mon_num||'        '||book_id_list%ROWCOUNT);
end loop;
return book_id_list;
end;
/



DECLARE
    x   sys_refcursor;
BEGIN
    x := fun_most_popular('Oct');  -- This returns an open cursor
   -- dbms_output.put_line(x);
END;
/
select distinct extract(year from ix.issue_date) from issue ix;


select ix.book_id from issue ix where extract(month from ix.issue_date) = 10
and extract(year from ix.issue_date) =2017
having count(book_id) = (select max(count(iy.book_id)) from  issue iy where  extract(month from iy.issue_date) = 10
and extract(year from iy.issue_date) =2017
group by iy.book_id)
group by ix.book_id;

select 10 as number1 from issue;