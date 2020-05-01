\c granulaoperate postgres;

------------ TABLE ---------------
\i tables/radiological_serie.sql
\i tables/radiological_report.sql
----------------------------------

---------- FOREIGN TABLE ---------
\i foreign/for_radiology_hl7.sql
\i foreign/for_radiology_dicom.sql
----------------------------------

---------- FUNCTIONS -------------
\i functions/f_fdw_radiology_img_obx.sql
\i functions/f_fdw_radiology_img_pid_obr_obx.sql
\i functions/f_fdw_radiology_img_pid_obr_obx_stringify.sql

\i functions/f_fdw_radiology_rep_dicom.sql

\i functions/f_insert_rdl_serie.sql
\i functions/f_update_rdl_serie.sql
\i functions/f_update_rdl_partial_serie.sql
\i functions/f_upsert_rdl_serie.sql
\i functions/f_delete_rdl_serie.sql

\i functions/f_insert_rdl_report.sql
----------------------------------

------------ TRIGGER -------------
\i triggers/t_radiological_serie_trigger.sql
\i triggers/t_radiological_report_trigger.sql
----------------------------------

------------ M_CAT ---------------
\i views/m_cat_tel_dicom.sql
----------------------------------

------------- VIEWS --------------
\i views/bmv_radiological_serie.sql
\i views/bmv_radiological_report.sql
----------------------------------
