/*
	Function: delete_visit

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A11 OR ADT/A38 HL7 message is received.
	Delete a pre-admit or an admit visit.

	Parameters:
		_cid - control id of the record

	Returns:
		None

	Algo:
		(start code)
		IF (v_vn AND admitstatus) THEN
			DELETE VISIT(v_vn AND admitstatus)
		ENDIF
		(end code)

	See also:
		<fdw_demographic_pv1>, <visit>
*/
CREATE FUNCTION delete_visit(_cid VARCHAR(255))
RETURNS VOID AS $$

DECLARE
    v_vn BIGINT;
    v_pid BIGINT;
    v_as VARCHAR;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get visit number and admit status
    SELECT pv1_19_1, pid, admitstatus INTO v_vn, v_pid, v_as FROM fdw_demographic_pv1_pv2(_cid);

    -- Check if exists
    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_vn AND admitstatus = v_as) THEN
    	-- Delete visit
    	DELETE FROM visit WHERE nb = v_vn;
    ELSE
	PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_vn || ' WITH PATIENT ID ' || v_pid);
    END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_visit(VARCHAR)
  OWNER TO fluance;
