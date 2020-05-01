/*
	Function: cancel_patient_returns_loa

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A53 HL7 message is received.
	Update enddt of a leave of abscence.

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		IF (v_loaid) THEN
			UPDATE leaveofabsence_enddt
		ENDIF;
		(end code)

	See also:
		<leaveofabsence>, <fdw_demographic_evn>
*/
CREATE FUNCTION cancel_patient_returns_loa(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$


DECLARE
  v_loaid BIGINT;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get loa id
    SELECT loa.id INTO v_loaid FROM leaveofabsence loa, fdw_demographic_evn(_cid) evn WHERE evn.pv1_19_1 = loa.visit_nb AND evn.pv1_24_1 = loa.sequencenb;

    -- If loa ID not found, raise an exception.
    IF NOT FOUND THEN
          PERFORM raise_error('EXCEPTION', 'Nonexistent LOA or VISIT NUMBER for control_id (' || _cid || ')');
    END IF;

    -- Update leave of absence.
    UPDATE leaveofabsence SET enddt = null, source = _src, sourceid = _cid WHERE id = v_loaid;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION cancel_patient_returns_loa(VARCHAR, VARCHAR)
  OWNER TO fluance;
