rem EE 562 Project 3
rem Ye Shi
rem shi349
----------------------------------------------------------
EXEC dbms_output.put_line('Populate Patient_Chart and Patient_Input');

--EXEC pop_patient_chart;
exec pop_patient_input;

EXEC dbms_output.put_line('Populate General_Ward from Patient_Input');

EXEC populate_db;