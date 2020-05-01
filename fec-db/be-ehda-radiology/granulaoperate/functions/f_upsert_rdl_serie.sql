/*
	Function: upsert_rdl_serie
	This function's goal is to update a radiological serie in the database if it already exists

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: None

	Algo:
	(start code)
		check if patient still exists
		if exists siuid then
			update_rdl_partial_serie
		else
			insert_rdl_serie
	(end code)

	See also:
	<radiological_serie>, <fdw_radiology_pid_obr_obx>, <radiology_hl7>
*/
CREATE FUNCTION upsert_rdl_serie(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_siuid VARCHAR;

BEGIN
	IF length(_cid) = 0 THEN
			RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT obx_3_1 INTO v_siuid FROM fdw_radiology_img_pid_obr_obx(_cid);
	
	IF EXISTS(SELECT 1 FROM radiological_serie WHERE serieiuid = v_siuid) THEN
		PERFORM update_rdl_partial_serie(_cid, _src);
	ELSE
		PERFORM insert_rdl_serie(_cid, _src);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_rdl_serie(VARCHAR, VARCHAR)
  OWNER TO fluance;
