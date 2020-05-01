/*
	Function: delete_lab_lab
	
	This function's goal is to delete lab data related to a specific order in the database.

	Parameters:
		_cid - VARCHAR row_id of the HL7 messages in inbound database.

	Returns: 
		None

	Algo:
		(start code)
		LOOP OBR segments
			DELETE lab_obs_request CASCADED
		END LOOP
		(end code)

	See also:
		<lab_hl7>, <lab_obs_request>, <fdw_lab_pid_pv1>
*/
CREATE FUNCTION delete_lab_lab(_cid VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_syn RECORD;
	v_obr RECORD;
	v_company_id INTEGER;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get patient_id and company code
	SELECT * INTO v_syn FROM fdw_lab_pid_pv1(_cid);
	
	SELECT id INTO v_company_id FROM company WHERE code = v_syn.companycode;
	
	If NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent COMPANY CODE');
	END IF;
	
	-- If PID is provided but does not exist, raise an exception
	IF v_syn.pid_3_1 IS NOT NULL THEN
		IF NOT EXISTS (SELECT 1 FROM patient WHERE id = v_syn.pid_3_1) THEN
			PERFORM raise_error('EXCEPTION', 'Nonexistent PATIENT ID ' || v_syn.pid_3_1 || ' provided by ' || v_syn.companycode);
		END IF;
	-- If no PID is provided, check if VN exists else raise an exception
	ELSIF NOT EXISTS (SELECT 1 FROM visit WHERE nb = v_syn.pv1_19_1) THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_syn.pv1_19_1 || ' provided by ' || v_syn.companycode);
	END IF;
	
	-- Loop first on OBR segments
	FOR v_obr IN
		SELECT * FROM fdw_lab_obr(_cid)
	LOOP
		DELETE FROM lab_obs_request WHERE ordernb = v_obr.obr_3_1 AND id = v_obr.obr_1_1;
	END LOOP;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_lab_lab(VARCHAR)
  OWNER TO fluance;
