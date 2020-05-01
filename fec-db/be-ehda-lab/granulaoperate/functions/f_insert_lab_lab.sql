/*
	Function: insert_lab_lab
	
	This function's goal is to insert lab data related to an order for a patient in the database.

	Parameters:
		_cid - VARCHAR row_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: 
		None

	Algo:
		(start code)
		IF (pid or vn) THEN
			LOOP OBR segments
				INSERT lab_obs_request;
				LOOP NTE related to OBR
					INSERT lab_obs_request_note;
					LOOP OBX related to OBR
						INSERT lab_obs_result;
						LOOP NTE related to OBX
							INSERT lab_obs_result_note
						END LOOP
					END LOOP
				END LOOP
			END LOOP
		END IF
		(end code)

	See also:
		<lab_hl7>, <lab_obs_request>, <lab_obs_request_note>, <lab_obs_result>, <lab_obs_result_note>, <fdw_lab_pid_pv1>, <fdw_lab_obr>, <fdw_lab_obr_nte>, <fdw_lab_obx>, <fdw_lab_obx_nte>
*/
CREATE FUNCTION insert_lab_lab(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_pid BIGINT;
	v_company_id INTEGER;
	v_syn RECORD;
	v_obx RECORD;
	v_obr RECORD;
	v_obr_nte RECORD;
	v_obx_nte RECORD;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get patient_id, ordernb and company code
	SELECT * INTO v_syn FROM fdw_lab_pid_pv1(_cid);
	
	SELECT id INTO v_company_id FROM company WHERE code = v_syn.companycode;
	
	If NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent COMPANY CODE');
	END IF;
	
	-- If PID is provided but does not exist, raise an exception
	IF v_syn.pid_3_1 IS NOT NULL THEN
		IF EXISTS (SELECT 1 FROM patient WHERE id = v_syn.pid_3_1) THEN
			v_pid = v_syn.pid_3_1;
		ELSE
			PERFORM raise_error('EXCEPTION', 'Nonexistent PATIENT ID ' || v_syn.pid_3_1 || ' provided by ' || v_syn.companycode);
		END IF;
	-- If no PID is provided, check if VN exists else raise an exception
	ELSIF EXISTS (SELECT 1 FROM visit WHERE nb = v_syn.pv1_19_1) THEN
		SELECT patient_id INTO v_pid FROM visit WHERE nb = v_syn.pv1_19_1;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_syn.pv1_19_1 || ' provided by ' || v_syn.companycode);
	END IF;
	
	-- Loop first on OBR segments
	FOR v_obr IN
		SELECT * FROM fdw_lab_obr(_cid)
	LOOP
		INSERT INTO lab_obs_request (id, ordernb, patient_id, company_id, namespace, groupid, groupname, observationdt, source, sourceid) VALUES (v_obr.obr_1_1, v_obr.obr_3_1, v_pid, v_company_id, v_obr.obr_3_2, v_obr.obr_4_1, v_obr.obr_4_2, v_obr.obr_7_1, _src, v_obr.control_id);

		-- Insert NTE related to OBR
		FOR v_obr_nte IN 
			SELECT * FROM fdw_lab_obr_nte(_cid, v_obr.obr_1_1)
		LOOP
			INSERT INTO lab_obs_request_note (id, lab_obs_req_ordernb, lab_obs_req_id, commentsrc, comment) VALUES (v_obr_nte.nte_1_1, v_obr.obr_3_1, v_obr_nte.parent_obr, v_obr_nte.nte_2_1, v_obr_nte.nte_3_1);
		END LOOP;
	
		-- Loop on every OBX segments related to an OBR
		FOR v_obx IN
			SELECT * FROM fdw_lab_obx(_cid, v_obr.obr_1_1)
		LOOP
			INSERT INTO lab_obs_result (lab_obs_req_ordernb, lab_obs_req_id, id, valuetype, analysiscode, analysisname, loinccode, value, unit, refrange, abnormalflag, resultstatus, source, sourceid) 
			VALUES (v_obr.obr_3_1, v_obx.parent_obr, v_obx.obx_1_1, v_obx.obx_2_1, v_obx.obx_3_1, v_obx.obx_3_2, v_obx.obx_3_5, v_obx.obx_5_1, v_obx.obx_6_1, v_obx.obx_7_1,v_obx.obx_8_1, v_obx.obx_11_1, _src, v_obx.control_id);
		
			-- Insert NTE related to OBX
			FOR v_obx_nte IN
				SELECT * FROM fdw_lab_obx_nte(_cid, v_obr.obr_1_1, v_obx.obx_1_1)
			LOOP
				INSERT INTO lab_obs_result_note (id, lab_obs_res_id, lab_obs_res_req_ordernb, lab_obs_res_req_id, commentsrc, comment) VALUES (v_obx_nte.nte_1_1, v_obx_nte.parent_obx, v_obr.obr_3_1, v_obx_nte.parent_obr, v_obx_nte.nte_2_1, v_obx_nte.nte_3_1);
			END LOOP;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_lab_lab(VARCHAR, VARCHAR)
  OWNER TO fluance;
