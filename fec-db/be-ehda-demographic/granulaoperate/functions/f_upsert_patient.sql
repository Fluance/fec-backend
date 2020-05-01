/*
	Function: upsert_patient

	This function's goal is to update a patient.
	- This function is called by Mirth with the HL7 event ADT-A31 (update patient).
	Also, it is necessary to test if the patient already exists. According to Opale,
	if it does not exist, we MUST create it to bypass the issue with A28 not sent

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None
	
	Algo:
		(start code)
		If (exists) THEN
			update patient
		ELSE
			insert patient
		END IF
		(end code)

	See also:
		<patient>, <insert_patient>, <update_patient>, <fdw_demographic_pid>
*/
CREATE FUNCTION upsert_patient(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_patid BIGINT;
	
BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get patient ID
	SELECT pid INTO v_patid FROM fdw_demographic_pid(_cid);
	
	-- check if the patient exists
	IF EXISTS (SELECT 1 FROM patient WHERE id = v_patid) THEN
		PERFORM update_patient(_cid, _src);
	ELSE
		PERFORM insert_patient(_cid, _src);
	END IF;

END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_patient(VARCHAR, VARCHAR)
  OWNER TO fluance;