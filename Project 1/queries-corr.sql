rem EE 562 Project 1
rem Ye Shi
rem shi349

-- 1. Find the age of the oldest student who is either a CS major or is enrolled
-- in a course taught by Prof. Brown
BEGIN
        Dbms_Output.Put_Line('Query #1');
END;
/

SELECT DISTINCT
        MAX(Sx.Age)
FROM
        Faculty Fx,
        Enrolled Ex,
        Class Cx,
        Student Sx
WHERE
        (
                        Fx.Fid = Cx.Fid
                AND
                        Ex.Cnum = Cx.Cnum
				and 	ex.sid = sx.sid
        ) AND (
                        Sx.Major = 'CS'
                OR
                        Fx.Fname = 'Prof. Brown'
        );

-- 2. Find the names of all classes that either meet in room 115 or have five or
-- more students enrolled.

BEGIN
        Dbms_Output.Put_Line('Query #2');
END;
/

SELECT
        Cx.Cnum AS Name -- the class name does not exist in the table
FROM
        Class Cx
WHERE
                Cx.Room = '115'
        OR
                Cx.Cnum IN (
                        SELECT
                                Ex.Cnum
                        FROM
                                Enrolled Ex
                        GROUP BY
                                Ex.Cnum
                        HAVING
                                COUNT(*) >= 5
                );

-- 3. Find the names of all students who are enrolled in 2 classes that meet at 
-- the same time.

BEGIN
        Dbms_Output.Put_Line('Query #3');
END;
/

SELECT DISTINCT
        Sx.Sname
FROM
        Student Sx
WHERE
        Sx.Sid IN (
                SELECT
                        Ex.Sid
                FROM
                        Enrolled Ex,
                        Enrolled Ey,
                        Class Cx,
                        Class Cy
                WHERE
                                Ex.Cnum = Cx.Cnum
                        AND
                                Ey.Cnum = Cy.Cnum
                        AND
                                Ex.Sid = Ey.Sid
                        AND
                                Cx.Meets_At = Cy.Meets_At
                        AND
                                Ex.Cnum <> Ey.Cnum
        );

-- 4. Find the names of faculty members who teach in every room in which some
-- class is taught

BEGIN
        Dbms_Output.Put_Line('Query #4');
END;
/

SELECT
        Fx.Fname
FROM
        Faculty Fx
WHERE
        NOT
                EXISTS (
                        ( SELECT
                                Cx.Room
                        FROM
                                Class Cx
                        ) MINUS ( SELECT
                                Cy.Room
                        FROM
                                Class Cy
                        WHERE
                                Cy.Fid = Fx.Fid
                        )
                );

-- 5. Find the names of aculty members for whom combined enrollment of the 
-- courses that they teach is more than eight

BEGIN
        Dbms_Output.Put_Line('Query #5');
END;
/

SELECT
        Fx.Fname
FROM
        Faculty Fx,
        Enrolled Ex,
        Class Cx
WHERE
                Fx.Fid = Cx.Fid
        AND
                Ex.Cnum = Cx.Cnum
GROUP BY
        Fx.Fname
HAVING
        COUNT(Ex.Sid) > 8;

-- 6. Print the level and the average age of students for that level,for all
-- levels except JR.

BEGIN
        Dbms_Output.Put_Line('Query #6');
END;
/

SELECT
        Sx.Levels,
        AVG(Sx.Age)
FROM
        Student Sx
WHERE
        Sx.Levels <> 'JR'
GROUP BY
        Sx.Levels;

-- 7. Find the names of students whos are enrolled in the maximum 
-- number of classes.

BEGIN
        Dbms_Output.Put_Line('Query #7');
END;
/

SELECT DISTINCT
        Sx.Sname
FROM
        Student Sx
WHERE
        Sx.Sid IN (
                SELECT
                        Ex.Sid
                FROM
                        Enrolled Ex
                GROUP BY
                        Ex.Sid
                HAVING
                        COUNT(*) >= ALL (
                                SELECT
                                        COUNT(*)
                                FROM
                                        Enrolled Ey
                                GROUP BY
                                        Ey.Sid
                        )
        );
        
-- 8. Find the names of  students who are not enrolled in any class.

BEGIN
        Dbms_Output.Put_Line('Query #8');
END;
/

SELECT
        Sx.Sname
FROM
        Student Sx
WHERE
        Sx.Sid NOT IN (
                SELECT
                        Ex.Sid
                FROM
                        Enrolled Ex
        );

-- 9. For each age value that appears in the student table,find the 
-- level value that appears most often.

BEGIN
        Dbms_Output.Put_Line('Query #9');
END;
/

SELECT
        Sx.Age,
        Sx.Levels
FROM
        Student Sx
GROUP BY
        Sx.Age,
        Sx.Levels
HAVING
        Sx.Levels IN (
                SELECT
                        Sy.Levels
                FROM
                        Student Sy
                WHERE
                        Sx.Age = Sy.Age
                GROUP BY
                        Sy.Age,
                        Sy.Levels
                HAVING
                        COUNT(*) >= ALL (
                                SELECT
                                        COUNT(*)
                                FROM
                                        Student Sz
                                WHERE
                                        Sy.Age = Sz.Age
                                GROUP BY
                                        Sz.Age,
                                        Sz.Levels
                        )
        )
ORDER BY Sx.Age;

-- 10. Compute and print the difference between the average number
-- of students being taught by an EE faculty member and the average
-- number of students taught by CS faculty member.

-- TA does not understand the instruction

BEGIN
        Dbms_Output.Put_Line('Query #10');
END;
/

SELECT
        AVG(Ee.Count) - AVG(Cs.Count)
FROM
        (
                SELECT
                        Fx.Fid,
                        COUNT(Ex.Sid) AS Count
                FROM
                        Class Cx,
                        Enrolled Ex,
                        Faculty Fx
                WHERE
                                Cx.Cnum = Ex.Cnum
                        AND
                                Fx.Fid = Cx.Fid
                        AND
                                Fx.Dept = 'EE'
                GROUP BY
                        Fx.Fid
        ) Ee,
        (
                SELECT
                        Fy.Fid,
                        COUNT(Ey.Sid) AS Count
                FROM
                        Class Cy,
                        Enrolled Ey,
                        Faculty Fy
                WHERE
                                Cy.Cnum = Ey.Cnum
                        AND
                                Fy.Fid = Cy.Fid
                        AND
                                Fy.Dept = 'CS'
                GROUP BY
                        Fy.Fid
        ) Cs;
        
-- 11. Print the name(s) of the faculty member(s) whos have number 
-- of students greater than the average number of students taught 
-- by EE professor

-- TA does not understand the instruction

BEGIN
        Dbms_Output.Put_Line('Query #11');
END;
/

SELECT
        Fz.Fname
FROM
        Faculty Fz,
        (
                SELECT
                        AVG(Ee.Count) AS Ave
                FROM
                        (
                                SELECT
                                        Fx.Fid,
                                        COUNT(Ex.Sid) AS Count
                                FROM
                                        Class Cx,
                                        Enrolled Ex,
                                        Faculty Fx
                                WHERE
                                                Cx.Cnum = Ex.Cnum
                                        AND
                                                Fx.Fid = Cx.Fid
                                        AND
                                                Fx.Dept = 'EE'
                                GROUP BY
                                        Fx.Fid
                        ) Ee
        ) Eeave,
        (
                SELECT
                        Fy.Fid,
                        COUNT(Ey.Sid) AS Count
                FROM
                        Class Cy,
                        Enrolled Ey,
                        Faculty Fy
                WHERE
                                Cy.Cnum = Ey.Cnum
                        AND
                                Fy.Fid = Cy.Fid
                        AND
                                Fy.Dept = 'EE'
                GROUP BY
                        Fy.Fid
        ) Ee
WHERE
                Fz.Fid = Ee.Fid
        AND
                Ee.Count > Eeave.Ave;

-- 12. Find the name(s) of the faculty member(s) who can substitute
-- Prof. Wasfi for both of his classes when he is out of town.

BEGIN
        Dbms_Output.Put_Line('Query #12');
END;
/
select fname
from faculty fx
where not exists (select * from class cx, faculty fy
where fy.fid=cx.fid
and fy.fid = 'Prof. Wasfi'
and not exists (select * from faculty fz, class cy
where fz.fid = fx.fid
and fz.dept = fy.dept
and cy.meets_at <> cx.meets_at))

SELECT
        Fname
FROM
        (
                SELECT
                        Fz.Fname,
                        Fz.Fid
                FROM
                        Faculty Fz
                MINUS
                SELECT
                        Fx.Fname,
                        Fx.Fid
                FROM
                        Faculty Fx,
                        Class Cx
                WHERE
                                Fx.Fid = Cx.Fid
                        AND
                                Cx.Meets_At = ANY (
                                        SELECT
                                                Cy.Meets_At
                                        FROM
                                                Faculty Fy,
                                                Class Cy
                                        WHERE
                                                        Fy.Fid = Cy.Fid
                                                AND
                                                        Fy.Fname = 'Prof. Wasfi'
                                )
        );

-- 13. Find the names of students who are taking courses that do not
-- have any prerequisite course.

BEGIN
        Dbms_Output.Put_Line('Query #13');
END;
/
-- Correct?
SELECT
        Sname
FROM
        (
                SELECT
                        Sy.Sid,
                        Sy.Sname
                FROM
                        Student Sy
                MINUS
                SELECT DISTINCT
                        Sx.Sid,
                        Sx.Sname
                FROM
                        Student Sx,
                        Enrolled Ex
                WHERE
                                Sx.Sid = Ex.Sid
                        AND
                                Ex.Cnum = ANY (
                                        SELECT
                                                Px.Prereq
                                        FROM
                                                Prerequisite Px
                                )
                        OR
                                Sx.Sid NOT IN (
                                        SELECT
                                                Ey.Sid
                                        FROM
                                                Enrolled Ey
                                )
        );

-- 14. Find all courses can be taken simulatenously in a semester 
-- with their all immediate prerequisite courses. 

BEGIN
        Dbms_Output.Put_Line('Query #14');
END;
/

SELECT
        Px.Cnum,
        Px.Prereq
FROM
        Prerequisite Px,
        Class Cx,
        Class Cy
WHERE
                Px.Cnum = Cx.Cnum
        AND
                Px.Prereq = Cy.Cnum
        AND
                Cx.Meets_At <> Cy.Meets_At
MINUS
SELECT
        Py.Cnum,
        Py.Prereq
FROM
        Prerequisite Py,
        Prerequisite Pz,
        Class Cz,
        Class Cj
WHERE
                Py.Cnum = Pz.Cnum
        AND
                Py.Prereq <> Pz.Prereq
        AND
                Cz.Cnum = Py.Prereq
        AND
                Pz.Prereq = Cj.Cnum
        AND
                Cz.Meets_At <> Cj.Meets_At;
                
-- 15. Find the names(s) of an instructor(s) who teaches both a
-- course and all its immediate prerequisite course.
BEGIN
        Dbms_Output.Put_Line('Query #15');
END;
/
SELECT
        Fx.Fname
FROM
        Faculty Fx
WHERE
        Fx.Fid IN (
                SELECT
                        Cx.Fid
                FROM
                        Prerequisite Px,
                        Class Cx,
                        Class Cy
                WHERE
                                Px.Cnum = Cx.Cnum
                        AND
                                Px.Prereq = Cy.Cnum
                        AND
                                Cx.Fid = Cy.Fid
                MINUS
                SELECT
                        Cz.Fid
                FROM
                        Prerequisite Py,
                        Prerequisite Pz,
                        Class Cz,
                        Class Cj
                WHERE
                                Py.Cnum = Pz.Cnum
                        AND
                                Py.Prereq <> Pz.Prereq
                        AND
                                Cz.Cnum = Py.Prereq
                        AND
                                Pz.Prereq = Cj.Cnum
                        AND
                                Cz.Fid <> Cj.Fid
        ); 
                
-- 16. Find all courses that have no more than three extended prerequisite
-- coureses.

BEGIN
        Dbms_Output.Put_Line('Query #16');
END;
/

SELECT
        Cx.Cnum
FROM
        Class Cx
WHERE
        Cx.Cnum NOT IN (
                SELECT
                        Px.Cnum
                FROM
                        Prerequisite Px,
                        Prerequisite Py,
                        Prerequisite Pz,
                        Prerequisite Pi
                WHERE
                                Px.Prereq = Py.Cnum
                        AND
                                Py.Prereq = Pz.Cnum
                        AND
                                Pz.Prereq = Pi.Cnum
        ) -- courses need at least 4 prereqs.
        ;

-- 17. Find the names of students who have taken courses which have 
-- only one extended prerequisite course. Also list the course and its
-- extended prerequisite course.

BEGIN
        Dbms_Output.Put_Line('Query #17');
END;
/

select sx.name, px.cnum, px.prereq
from student sx, prerequisite px, enrolled ex, enrolled ey
where sx.sid = ex.sid and sx.sid = ey.sid
px.cnum = ex.cnum and px.prereq = ey.cnum
and ex.cnum not in (                        SELECT
                                Px.Cnum
                        FROM
                                Prerequisite Px,
                                Prerequisite Py
                        WHERE
                                Px.Prereq = Py.Cnum);
								
-- The following does not ensure the student takes the prereq
SELECT
        Sx.Sname,
        Pi.Cnum,
        Pi.Prereq
FROM
        Student Sx,
        Prerequisite Pi,
        Enrolled Ex
WHERE
                Sx.Sid = Ex.Sid
        AND
                Ex.Cnum = Pi.Cnum
        AND
                Ex.Cnum NOT IN (
                        SELECT
                                Px.Cnum
                        FROM
                                Prerequisite Px,
                                Prerequisite Py
                        WHERE
                                Px.Prereq = Py.Cnum
                );

-- A view that shows the Faculty ID ,faculty name and the name of the class he/she teaches

BEGIN
        Dbms_Output.Put_Line('View A');
END;
/

CREATE VIEW Viewa AS
        SELECT
                Fx.Fid,
                Fx.Fname,
                Cx.Cnum
        FROM
                Faculty Fx,
                Class Cx
        WHERE
                Fx.Fid = Cx.Fid
        ORDER BY Fx.Fid;

SELECT
        *
FROM
        Viewa;

-- A view that shows the student id,student name,course number of the classes he/she is enrolled in

BEGIN
        Dbms_Output.Put_Line('View B');
END;
/

CREATE VIEW Viewb AS
        SELECT
                Sx.Sid,
                Sx.Sname,
                Ex.Cnum
        FROM
                Student Sx,
                Enrolled Ex
        WHERE
                Sx.Sid = Ex.Sid
        ORDER BY Sx.Sid;

SELECT
        *
FROM
        Viewb;