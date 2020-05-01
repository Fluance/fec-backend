/*
	Function: upsert_physician

	This function's goal is to update a physician.
	Also, it is necessary to test if the physician already exists. According to Opale,
	if it does not exist, we MUST create it to bypass the issue with physician deactivated not sent

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None
	
	Algo:
		(start code)
		If (exists) THEN
			update physician
		ELSE
			insert physician
		END IF
		(end code)

	See also:
		<physician>, <insert_physician>, <update_physician>, <fdw_demographic_stf_pra>
*/
CREATE FUNCTION upsert_physician(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_sid INTEGER;
	v_compid INTEGER;
	
BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get physician staffid
	SELECT stf.sid, stf.company_id INTO v_sid, v_compid FROM fdw_demographic_stf_pra(_cid) stf;
	
	-- Check if the physician exists
	IF EXISTS (SELECT 1 FROM physician WHERE staffid = v_sid AND company_id = v_compid) THEN
		PERFORM update_physician(_cid, _src);
	ELSE
		PERFORM insert_physician(_cid, _src);
	END IF;

END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION upsert_physician(VARCHAR, VARCHAR)
  OWNER TO fluance;