\c granulaoperate postgres;

------------ DOMAINS --------------
\i domains/d_contact_equipment.sql;
\i domains/d_contact_nbtype.sql;
\i domains/d_admit_status.sql;
----------------------------------

------------ TABLES ---------------
\i tables/capacity.sql
\i tables/contact.sql;
\i tables/physician.sql;
\i tables/physician_contact.sql;
\i tables/guarantor.sql;
\i tables/guarantor_contact.sql;
\i tables/patient.sql;
\i tables/patient_contact.sql;
\i tables/nextofkin.sql;
\i tables/nextofkin_contact.sql;
\i tables/invoice.sql;
\i tables/visit.sql;
\i tables/visit_physician.sql;
\i tables/visit_guarantor.sql;
\i tables/visit_invoice.sql;
\i tables/leaveofabsence.sql;
\i tables/visit_obs_result.sql;
\i tables/visit_healthcare.sql
\i tables/visit_intervention_healthcare.sql
\i tables/visit_benefit.sql;
\i tables/visit_benefit_physician.sql;
----------------------------------

---------- FOREIGN TABLES ---------
\i foreign/for_demographic_dwo_invoice.sql;
\i foreign/for_demographic_exp10_benefit.sql;
\i foreign/for_demographic_hl7.sql;
----------------------------------

---------- FUNCTIONS -------------
\i functions/f_fdw_demographic_adt_gt1.sql;
\i functions/f_fdw_demographic_evn.sql;
\i functions/f_fdw_demographic_mfn_gt1.sql;
\i functions/f_fdw_demographic_mrg.sql;
\i functions/f_fdw_demographic_pid.sql;
\i functions/f_fdw_demographic_nk1.sql;
\i functions/f_fdw_demographic_pv1.sql;
\i functions/f_fdw_demographic_pv2.sql;
\i functions/f_fdw_demographic_pv1_pv2.sql;
\i functions/f_fdw_demographic_stf_pra.sql;
\i functions/f_fdw_demographic_dwo_inv.sql;
\i functions/f_fdw_demographic_benefit.sql;
\i functions/f_fdw_demographic_obx.sql;

\i functions/f_check_dwo_file.sql;

\i functions/f_insert_physician.sql;
\i functions/f_update_physician.sql;
\i functions/f_upsert_physician.sql;
\i functions/f_delete_physician.sql;

\i functions/f_insert_guarantor.sql;
\i functions/f_update_guarantor.sql;
\i functions/f_upsert_guarantor.sql;
\i functions/f_delete_guarantor.sql;

\i functions/f_insert_patient.sql;
\i functions/f_update_patient.sql;
\i functions/f_upsert_patient.sql;
\i functions/f_delete_patient.sql;
\i functions/f_transfert_patient.sql;
\i functions/f_change_patient_class.sql;
\i functions/f_merge_patient.sql;

\i functions/f_insert_nextofkin.sql;

\i functions/f_insert_visit.sql;
\i functions/f_manage_visit_guarantor.sql;
\i functions/f_manage_visit_physician.sql;
\i functions/f_insert_visit_guarantor.sql;
\i functions/f_insert_visit_physician.sql;
\i functions/f_update_visit.sql;
\i functions/f_delete_visit.sql;
\i functions/f_discharge_visit.sql;
\i functions/f_cancel_discharge_visit.sql;
\i functions/f_change_fid_number.sql;

\i functions/f_patient_loa.sql;
\i functions/f_patient_returns_loa.sql;
\i functions/f_cancel_patient_loa.sql;
\i functions/f_cancel_patient_returns_loa.sql;

\i functions/f_upsert_invoice.sql;
\i functions/f_insert_invoice.sql;

\i functions/f_insert_visit_benefit.sql;
\i functions/f_update_visit_benefit.sql;
\i functions/f_upsert_visit_benefit.sql;
\i functions/f_delete_visit_benefit.sql;
\i functions/f_manage_visit_benefit_physician.sql;

\i functions/f_insert_visit_obs_result.sql;
\i functions/f_update_visit_obs_result.sql;

\i functions/f_manage_healthcare.sql;
----------------------------------

------------ TRIGGERS -------------
\i triggers/t_physician_trigger.sql;
\i triggers/t_guarantor_trigger.sql;
\i triggers/t_patient_trigger.sql;
\i triggers/t_visit_trigger.sql;
\i triggers/t_invoice_trigger.sql;
----------------------------------

------------ M_REFDATA -----------
\i views/m_rd_opa_input.sql;
\i views/m_rd_opa_as.sql;
\i views/m_rd_opa_at.sql;
\i views/m_rd_opa_fcl.sql;
\i views/m_rd_opa_hs.sql;
\i views/m_rd_opa_pca.sql;
\i views/m_rd_opa_pcl.sql;
\i views/m_rd_opa_pru.sql;
\i views/m_rd_opa_pt.sql;
\i views/m_rd_opa_pu.sql;
\i views/m_rd_opa_spe.sql;
\i views/m_rd_opa_dtl.sql
\i views/m_cat_opa_ben.sql;
\i views/m_cat_opa_icd.sql;
\i views/m_cat_opa_chop.sql;
---------------------------------

------------ M_VIEWS --------------
\i views/m_bmv_patientunit.sql;
\i views/m_bmv_hospservice.sql;
\i views/m_bmv_patientroom.sql;
\i views/m_bmv_patientbed.sql;
\i views/m_bmv_invoice.sql;
\i views/m_bmv_capacity.sql
--------------------------------

------------- VIEWS --------------
\i views/bmv_patients_list.sql;
\i views/bmv_patient_contacts_list.sql;
\i views/bmv_patient_nextofkins_list.sql;
\i views/bmv_patient_visits_list.sql;
\i views/bmv_patient_detail.sql;

\i views/bmv_physician_contacts_list.sql;
\i views/bmv_physician_detail.sql;
\i views/bmv_physician_patients_list.sql;

\i views/bmv_guarantor_contacts_list.sql;
\i views/bmv_guarantor_detail.sql;

\i views/bmv_nextofkin_contacts_list.sql;

\i views/bmv_visit_physicians_list.sql;
\i views/bmv_visit_guarantors_list.sql;
\i views/bmv_visit_guarantor_invoices_list.sql;
\i views/bmv_visit_benefit_list.sql;
\i views/bmv_visit_benefit_detail.sql;
\i views/bmv_visit_treatment_list.sql;
\i views/bmv_visit_diagnosis_list.sql;
\i views/bmv_visit_detail.sql;
\i views/bmv_invoice_detail.sql;
\i views/bmv_visit_intervention_data.sql;
\i views/bmv_physician_visits_list.sql;
--------------------------------
