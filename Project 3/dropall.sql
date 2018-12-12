rem EE 562 Project 3
rem Ye Shi
rem shi349

----------------------------------------------------------
drop table query_10;
drop table query_9;
drop table query_8;
drop table patient_schedule;
drop table query_4;
drop table query_1;
drop view patient_surgery_view;
----------------------------------------------------------
drop TRIGGER trg_pc;
drop procedure pop_patient_chart;
drop procedure pop_patient_input;
drop procedure populate_db;
drop procedure populate_dr;
drop procedure populate_surgeon;
drop function rand_ill;
drop function check_schedule;

----------------------------------------------------------
-- trgs for patient_status
--drop trigger trg_gw2ps;
--drop trigger trg_sw2ps;
--drop trigger trg_pre2ps;
--drop trigger trg_post2ps;
-- trgs for screening bed
drop trigger trg_sw2sb;
drop trigger trg_pre2sb;
--drop trigger trg_ps2sb;
-- trgs for pre bed
drop trigger trg_pre2preb;
--drop trigger trg_ps2preb;

-- trgs for trg_post
--drop trigger Mutating_Trg_3;
--drop trigger mutating_trg_2;
--drop trigger mutating_trg_1;
--drop package post_ward_pkg;
----------------------------------------------------------
drop trigger trg_gen;
drop trigger trg_scr;
drop trigger trg_post;
--drop trigger trg_pre;
----------------------------------------------------------
drop table patient_input;
drop table surgeon_schedule;
drop table dr_schedule;
drop table patient_chart;
drop table post_surgery_ward;
drop table pre_surgery_ward;
drop table screening_ward;
drop table general_ward;
----------------------------------------------------------
-- temp tables
drop table screening_bed;
drop table pre_surgery_bed;
--drop table patient_status;
--

