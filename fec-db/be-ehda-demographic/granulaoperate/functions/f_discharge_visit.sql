/*
	Function: discharge_visit
	
	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A03 HL7 message is received.
	Update the discharge date of a visit.

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		IF (vn) THEN
			UPDATE dischargedt = evn_6_1
		END
		(end code)

	See also:
		<visit>, <fdw_demographic_evn>
*/
CREATE FUNCTION discharge_visit(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_evn RECORD;

BEGIN

    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;
    
    SELECT * INTO v_evn FROM fdw_demographic_evn(_cid);
    -- Check if visit exists
    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_evn.pv1_19_1 AND patient_id = v_evn.pid) THEN
        -- Update visit
        UPDATE visit SET dischargedt = v_evn.evn_6_1, source = _src, sourceid = v_evn.control_id WHERE nb = v_evn.pv1_19_1;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_evn.pv1_19_1 || ' WITH PATIENT ID ' || v_evn.pid);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION discharge_visit(VARCHAR, VARCHAR)
  OWNER TO fluance;
