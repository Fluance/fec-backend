/*
	Function: patient_returns_loa

	This function is called when a patient comes back from a leave of abscence.
	Mirth calls this function on a ADT-A22 HL7 event.

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<leaveofabsence>
*/
CREATE FUNCTION patient_returns_loa(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$


DECLARE
  v_rec RECORD;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;
    
    -- Get loa id
    SELECT * INTO v_rec FROM leaveofabsence loa, (SELECT * FROM fdw_demographic_evn(_cid)) evn WHERE loa.visit_nb = evn.pv1_19_1 AND loa.sequencenb = evn.pv1_24_1;

    -- If loa ID not found, raise an exception.
    IF FOUND THEN
    	-- Update leave of absence.
    	UPDATE leaveofabsence SET enddt = v_rec.evn_6_1, source = _src, sourceid = v_rec.control_id WHERE id = v_rec.id;
    ELSE
          PERFORM raise_error('EXCEPTION', 'Nonexistent LOA for row_id (' || _cid || ')');
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION patient_returns_loa(VARCHAR, VARCHAR)
  OWNER TO fluance;
