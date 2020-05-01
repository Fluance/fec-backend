/*
	Function: upsert_guarantor

	This function's goal is to update a guarantor.
	Also, it is necessary to test if the guarantor already exists. According to Opale,
	if it does not exist, we MUST create it to bypass the issue with guarantor deactivated not sent

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None
	
	Algo:
		(start code)
		If (exists) THEN
			update guarantor
		ELSE
			insert guarantor
		END IF
		(end code)

	See also:
		<guarantor>, <insert_guarantor>, <update_guarantor>, <fdw_demographic_mfn_gt1>
*/
CREATE FUNCTION upsert_guarantor(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_gcode VARCHAR;
	
BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get guarantor code
	SELECT gt1_2_1 INTO v_gcode FROM fdw_demographic_mfn_gt1(_cid);
	
	-- Check if the guarantor exists
	IF EXISTS (SELECT 1 FROM guarantor WHERE code = v_gcode) THEN
		PERFORM update_guarantor(_cid, _src);
	ELSE
		PERFORM insert_guarantor(_cid, _src);
	END IF;

END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_guarantor(VARCHAR, VARCHAR)
  OWNER TO fluance;