/*
	Function: delete_patient

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A29 HL7 message is received.
	Delete a patient/person.

	Parameters:
		_cid - control id of the record

	Returns:
		None

	Algo:
		(start code)
		IF (v_patid) THEN
			DELETE ALL CONTACTS (v_patid)
			DELETE PATIENT(v_patid)
		ENDIF
		(end code)

	See also:
		<contact>, <patient>, <fdw_demographic_pid>
*/
CREATE FUNCTION delete_patient(_cid VARCHAR(255))
RETURNS VOID AS $$

DECLARE
	v_patid BIGINT;
	v_cc VARCHAR;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Get patient ID
	SELECT pid, companycode INTO v_patid, v_cc FROM fdw_demographic_pid(_cid);

	-- If patient ID found, delete it
	IF EXISTS (SELECT 1 FROM patient WHERE id = v_patid) THEN
		-- Delete existing contacts
		DELETE FROM contact WHERE id IN (SELECT contact_id FROM patient_contact WHERE patient_id = v_patid);

		-- Delete patient
		DELETE FROM patient WHERE id = v_patid;
	END IF;
	
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_patient(VARCHAR)
  OWNER TO fluance;
