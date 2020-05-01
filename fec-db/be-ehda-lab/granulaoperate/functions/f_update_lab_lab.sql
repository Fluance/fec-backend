/*
	Function: update_lab_lab
	
	This function's goal is to update lab data related to a specific order in the database.

	Parameters:
		_cid - VARCHAR row_id of the HL7 messages in inbound database.
		_src - VARCHAR application name.

	Returns: 
		None

	Algo:
		(start code)
		delete_lab
		insert_lab
		(end code)

	See also:
		<lab_hl7>, <delete_lab_lab>, <insert_lab_lab>
*/
CREATE FUNCTION update_lab_lab(_cid VARCHAR, _src VARCHAR)
RETURNS VOID AS $$

DECLARE
	
BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	PERFORM delete_lab_lab(_cid);
	
	PERFORM insert_lab_lab(_cid, _src);
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_lab_lab(VARCHAR, VARCHAR)
  OWNER TO fluance;
