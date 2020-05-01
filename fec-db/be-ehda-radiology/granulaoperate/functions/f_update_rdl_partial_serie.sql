/*
	Function: update_rdl_partial_serie
	This function's goal is to update a radiological serie in the database.

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: None

	Algo:
	(start code)
		check if serie exists
		update_rdl_partial_serie
	(end code)

	See also:
	<radiological_serie>, <fdw_radiology_pid_obr_obx>, <radiology_hl7>
*/
CREATE FUNCTION update_rdl_partial_serie(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_rec RECORD;
	v_pid BIGINT;
	v_onb VARCHAR;
	v_url VARCHAR;

BEGIN
	IF length(_cid) = 0 THEN
		RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT * INTO v_rec FROM fdw_radiology_img_pid_obr_obx_stringify(_cid); 

	-- Check if the serie exists
	IF EXISTS (SELECT 1 FROM radiological_serie WHERE serieiuid = v_rec.obx_3_1) THEN
	
		-- Ugly fix to bypass incomplete URL data in HL7 file
		SELECT patient_id, ordernb, orderurl INTO v_pid, v_onb, v_url FROM radiological_serie WHERE serieiuid = v_rec.obx_3_1;
		
		IF v_rec.pid_3_1 <> '-' THEN
			v_pid = v_rec.pid_3_1::BIGINT;
		END IF;
		
		IF  v_rec.obr_3_1 <> '-' THEN
			v_onb = v_rec.obr_3_1;
		END IF;
		
		SELECT SUBSTRING(v_url, '^.*/') || v_onb || '-' || v_pid INTO v_url;
		-- End of the very ugly fix
	
		UPDATE radiological_serie SET company_id = v_rec.company_id, 
			patient_id = CASE WHEN v_rec.pid_3_1 <> '-' THEN v_rec.pid_3_1::BIGINT ELSE patient_id END, 
			ordernb = CASE WHEN v_rec.obr_3_1 <> '-' THEN v_rec.obr_3_1 ELSE ordernb END, 
			serieobs = CASE WHEN v_rec.obx_5_2 <> '-' THEN v_rec.obx_5_2 ELSE serieobs END, 
			serieobsdt = CASE WHEN v_rec.obx_14_1 <> '--' THEN to_timestamp(v_rec.obx_14_1, 'YYYYMMDDHH24MISS') ELSE serieobsdt END, 
			orderobs = CASE WHEN v_rec.obr_20_1 <> '-' THEN v_rec.obr_20_1 ELSE orderobs END, 
			orderurl = v_url, 
			source = _src, sourceid = v_rec.control_id 
		WHERE serieiuid = v_rec.obx_3_1;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent SERIE IUID ' || v_rec.obx_3_1);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_rdl_partial_serie(VARCHAR, VARCHAR)
  OWNER TO fluance;
