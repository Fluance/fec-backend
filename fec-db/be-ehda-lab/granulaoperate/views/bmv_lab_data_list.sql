-- View: test_lab_list

CREATE OR REPLACE VIEW bmv_lab_data_list AS
SELECT lreq.patient_id,
       lreq.groupname,
       lreq.observationdt,
       lres.analysisname,
       lres.value,
       lres.valuetype,
       lres.unit,
       lres.refrange,
       lres.abnormalflag,
       sa.abnormalflagdesc,
       lres.resultstatus,
       sr.resultstatusdesc,
       c.comments
FROM lab_obs_request lreq,
     lab_obs_result lres,
     LATERAL
    (SELECT json_object_agg(lnote.id, lnote.comment
                            ORDER BY lnote.id) AS comments
     FROM lab_obs_result_note lnote
     WHERE lres.id = lnote.lab_obs_res_id
         AND lres.lab_obs_req_ordernb = lnote.lab_obs_res_req_ordernb
         AND lres.lab_obs_req_id = lnote.lab_obs_res_req_id
     ORDER BY min(lnote.id)) c
LEFT JOIN LATERAL
    (SELECT abnormalflagdesc
     FROM m_h2t_ic mic
     WHERE mic.abnormalflag = lres.abnormalflag) sa ON TRUE
LEFT JOIN LATERAL
    (SELECT resultstatusdesc
     FROM m_h2t_orsci morsci
     WHERE morsci.resultstatus = lres.resultstatus) sr ON TRUE
WHERE lreq.id = lres.lab_obs_req_id
    AND lreq.ordernb = lres.lab_obs_req_ordernb;

ALTER TABLE bmv_lab_data_list OWNER TO fluance;
