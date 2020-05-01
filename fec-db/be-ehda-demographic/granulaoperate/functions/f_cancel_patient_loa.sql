/*
	Function: cancel_patient_loa

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a ADT/A52 HL7 message is received.
	Delete a leave of absence for a visit.

	Parameters:
		_cid - control id of the record

	Returns:
		None

	Algo:
		(start code)
		IF (v_loaid) THEN
			DELETE leaveofabsence
		ENDIF
		(end code)

	See also:
		<leaveofabsence>, <fdw_demographic_evn>
*/
CREATE FUNCTION cancel_patient_loa(_cid VARCHAR(255))
RETURNS VOID AS $$

DECLARE
  v_loaid BIGINT;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;

    -- Get loa id
    SELECT id INTO v_loaid FROM leaveofabsence loa, (SELECT * FROM fdw_demographic_evn(_cid)) evn WHERE loa.visit_nb = evn.pv1_19_1 AND loa.sequencenb = evn.pv1_24_1;

    -- If loa ID not found, raise an exception.
    IF NOT FOUND THEN
          PERFORM raise_error('EXCEPTION', 'Nonexistent LOA or VISIT NUMBER for control_id (' || _cid || ')');
    END IF;

    -- Update leave of absence.
    DELETE FROM leaveofabsence WHERE id = v_loaid;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION cancel_patient_loa(VARCHAR)
  OWNER TO fluance;
