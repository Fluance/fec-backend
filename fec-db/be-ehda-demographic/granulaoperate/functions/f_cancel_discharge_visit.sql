/*
	Function: cancel_discharge_visit

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A13 HL7 message is received.
	Update dischargedt of a visit.

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		IF (visit_nb) THEN
			UPDATE dischargedt = null
		ENDIF
		(end code)

	See also:
		<visit>, <fdw_demographic_pv1_pv2>
*/
CREATE FUNCTION cancel_discharge_visit(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
  v_vn BIGINT;
  v_pid BIGINT;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get visit_nb
    SELECT pv1_19_1, pid INTO v_vn, v_pid FROM fdw_demographic_pv1_pv2(_cid);

    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_vn AND v.patient_id = v_pid) THEN
        -- Update visit
        UPDATE visit SET dischargedt = NULL, source = _src, sourceid = _cid WHERE nb = v_vn;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_vn || ' WITH PATIENT ID ' || v_pid);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION cancel_discharge_visit(VARCHAR, VARCHAR)
  OWNER TO fluance;
