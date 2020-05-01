/*
	Function: delete_rdl_serie
	This function's goal is to delete a radiological serie in the database.

	Parameters:
	
		_cid - VARCHAR control_id of the HL7 messages in inbound database.

	Returns: None

	Algo:
	(start code)
		delete_rdl_serie
	(end code)

	See Also:
	<radiological_serie>, <fdw_radiology_pid_obr_obx>, <radiology_hl7>
*/
CREATE FUNCTION delete_rdl_serie(_cid VARCHAR)
RETURNS VOID AS $$

DECLARE
	v_siuid VARCHAR;

BEGIN
	IF length(_cid) = 0 THEN
			RAISE EXCEPTION 'No value given for one required parameter: _cid';
	END IF;

	SELECT obx_3_1 INTO v_siuid FROM fdw_radiology_img_obx(_cid);

	DELETE FROM radiological_serie WHERE serieiuid = v_siuid;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_rdl_serie(VARCHAR)
  OWNER TO fluance;
