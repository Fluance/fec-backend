/*
	Function: update_rdl_serie
	This function's goal is to update a radiological serie in the database.

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: None

	Algo:
	(start code)
		check if serie exists
		update_rdl_serie
	(end code)

	See also:
	<radiological_serie>, <fdw_radiology_pid_obr_obx>, <radiology_hl7>
*/
CREATE FUNCTION update_rdl_serie(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_rec RECORD;

BEGIN
	IF length(_cid) = 0 THEN
		RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT * INTO v_rec FROM fdw_radiology_pid_obr_obx(_cid);

	-- Check if the serie exists
	IF EXISTS (SELECT 1 FROM radiological_serie WHERE serieiuid = v_rec.obx_3_1) THEN
		UPDATE radiological_serie SET patient_id = v_rec.pid_3_1, company_id = v_rec.company_id, ordernb = v_rec.obr_3_1, diagnosticservice = v_rec.obr_24_1, 
			serieobs = v_rec.obx_5_2, serieobsdt = v_rec.obx_14_1, orderobs = v_rec.obr_20_1, orderurl = v_rec.obr_21_1, source = _src, sourceid = v_rec.control_id 
		WHERE serieiuid = v_rec.obx_3_1;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent SERIE IUID ' || v_rec.obx_3_1);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_rdl_serie(VARCHAR, VARCHAR)
  OWNER TO fluance;
