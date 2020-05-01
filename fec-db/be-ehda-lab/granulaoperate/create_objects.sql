\c granulaoperate postgres;

------------ TABLES ---------------
\i tables/lab_obs_request.sql;
\i tables/lab_obs_request_note.sql;
\i tables/lab_obs_result.sql;
\i tables/lab_obs_result_note.sql;
----------------------------------

---------- FOREIGN TABLES ---------
\i foreign/for_lab_hl7.sql;
----------------------------------

---------- FUNCTIONS -------------
\i functions/f_fdw_lab_pid_pv1.sql;
\i functions/f_fdw_lab_obr.sql
\i functions/f_fdw_lab_obr_nte.sql;
\i functions/f_fdw_lab_obx.sql;
\i functions/f_fdw_lab_obx_nte.sql;

\i functions/f_insert_lab_lab.sql;
\i functions/f_update_lab_lab.sql;
\i functions/f_delete_lab_lab.sql;
----------------------------------

------------ TRIGGERS -------------
\i triggers/t_lab_obs_request_trigger.sql;
\i triggers/t_lab_obs_result_trigger.sql;
----------------------------------

------------- VIEWS --------------
\i views/bmv_lab_groupname_list.sql;
\i views/bmv_lab_data_list.sql;
--------------------------------
