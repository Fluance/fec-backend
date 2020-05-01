/*
	Function: change_fid_number
	
	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A50 HL7 message is received.
	Update visit folder number (fid in operate).

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		IF (vn) THEN
			UPDATE visit SET fid = ?
		ENDIF
		(end code)

	See also:
		<visit>, <fdw_demographic_pv1_pv2>
*/
CREATE FUNCTION change_fid_number(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
	v_rec RECORD;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	-- Get visit number and fid
	SELECT pv1_19_1, pv1_50_1, control_id INTO v_rec FROM fdw_demographic_pv1_pv2(_cid);

	-- If visit nb is found update it, else raise an exception
	IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_rec.pv1_19_1) THEN
		-- Update fid
		UPDATE visit SET fid = v_rec.pv1_50_1, source = _src, sourceid = v_rec.control_id WHERE nb = v_rec.pv1_19_1;
	ELSE
		PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_rec.pv1_19_1);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION change_fid_number(VARCHAR, VARCHAR)
  OWNER TO fluance;
