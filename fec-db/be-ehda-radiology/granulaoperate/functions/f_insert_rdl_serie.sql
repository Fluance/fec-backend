/*
	Function: insert_rdl_serie
	This function's goal is to insert a radiological serie for a patient in the database.

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: None

	Algo:
	(start code)
		check if patient still exists
		insert_rdl_serie
	(end code)

	See also:
	<radiological_serie>, <fdw_radiology_pid_obr_obx>, <radiology_hl7>
*/
CREATE FUNCTION insert_rdl_serie(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_rec RECORD;

BEGIN
	IF length(_cid) = 0 THEN
			RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT * INTO v_rec FROM fdw_radiology_img_pid_obr_obx(_cid);

	-- Check if the patient still exists
	IF EXISTS (SELECT 1 FROM patient WHERE id = v_rec.pid_3_1) THEN
		INSERT INTO radiological_serie (serieiuid, patient_id, company_id, ordernb, diagnosticservice, serieobs, serieobsdt, orderobs, orderurl, source, sourceid) 
		SELECT v_rec.obx_3_1, v_rec.pid_3_1, v_rec.company_id, v_rec.obr_3_1, v_rec.obr_24_1, v_rec.obx_5_2, v_rec.obx_14_1, v_rec.obr_20_1, v_rec.obr_21_1, _src, v_rec.control_id;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent PATIENT ID ' || v_rec.pid_3_1);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_rdl_serie(VARCHAR, VARCHAR)
  OWNER TO fluance;
