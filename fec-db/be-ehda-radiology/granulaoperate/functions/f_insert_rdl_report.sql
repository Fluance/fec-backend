/*
	Function: insert_rdl_report
	This function's goal is to insert a radiological report for a patient and an particular order in the database.

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: None

	Algo:
	(start code)
		check if patient still exists
		insert_rdl_report
	(end code)

	See also:
	<radiological_report>, <fdw_radiology_rep_dicom>, <radiology_dicom>
*/
CREATE FUNCTION insert_rdl_report(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_rec RECORD;
	v_company_id INTEGER;

BEGIN
	IF length(_cid) = 0 THEN
			RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT * INTO v_rec FROM fdw_radiology_rep_dicom(_cid);
	
	v_company_id = get_company(v_rec.companycode);

	-- Check if the patient still exists
	IF EXISTS (SELECT 1 FROM patient WHERE id = v_rec.tag00100020) THEN
		INSERT INTO radiological_report (studyuid, patient_id, company_id, ordernb, studydt, report, completion, verification, referringphysician, recordphysician, performingphysician, readingphysician, source, sourceid) 
						VALUES (v_rec.tag0020000D, v_rec.tag00100020, v_company_id, v_rec.tag00080050, v_rec.studydt, v_rec.tag0040A160, v_rec.tag0040A491, 
							v_rec.tag0040A493, v_rec.tag00080090, v_rec.tag00081048, v_rec.tag00081050, v_rec.tag00081060, _src, v_rec.control_id)
		ON CONFLICT ON CONSTRAINT radiological_report_pkey 
		DO UPDATE SET patient_id = v_rec.tag00100020, company_id = v_company_id, ordernb = v_rec.tag00080050, studydt = v_rec.studydt, report = v_rec.tag0040A160, completion = v_rec.tag0040A491, verification = v_rec.tag0040A493, 
				referringphysician = v_rec.tag00080090, recordphysician = v_rec.tag00081048, performingphysician = v_rec.tag00081050, readingphysician = v_rec.tag00081060, source = _src, sourceid = v_rec.control_id;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent PATIENT ID ' || v_rec.tag00100020);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_rdl_report(VARCHAR, VARCHAR)
  OWNER TO fluance;
