\c granulaoperate postgres;

------------ TABLES ---------------
\i tables/appointment.sql;
\i tables/resource_device.sql;
\i tables/resource_location.sql;
\i tables/resource_personnel.sql;
\i tables/appointment_resource_personnel.sql;
\i tables/appointment_resource_location.sql;
\i tables/appointment_resource_device.sql;
\i tables/process_status.sql;
\i tables/appointment_process_status.sql;
----------------------------------

---------- FOREIGN TABLES ---------
\i foreign/for_rap_hl7.sql;
----------------------------------

---------- FUNCTIONS -------------
\i functions/f_fdw_rap_aig.sql;
\i functions/f_fdw_rap_sch_ais.sql;
\i functions/f_fdw_rap_nte.sql;

\i functions/f_insert_appointment.sql;
\i functions/f_update_appointment.sql;
\i functions/f_upsert_appointment.sql;
\i functions/f_delete_appointment.sql;
\i functions/f_manage_appoint_resource.sql;
\i functions/f_manage_appoint_process.sql;
----------------------------------

------------ TRIGGERS -------------
\i triggers/t_appointment_trigger.sql;
\i triggers/t_resource_device_trigger.sql;
\i triggers/t_resource_location_trigger.sql;
\i triggers/t_resource_personnel_trigger.sql;
\i triggers/t_process_status_trigger.sql;
----------------------------------

------------- VIEWS --------------
\i views/bmv_appointment_detail.sql;
--------------------------------
