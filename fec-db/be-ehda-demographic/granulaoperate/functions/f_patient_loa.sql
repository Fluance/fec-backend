/*
	Function: patient_loa

	This function is called when a patient go on a leave of abscence.
	Mirth calls this function on a ADT-A21 HL7 event.

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<leaveofabsence>
*/

CREATE FUNCTION patient_loa(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
    v_rec RECORD;

BEGIN
    IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
    END IF;
    
    -- Get record from inbound
    SELECT * INTO v_rec FROM fdw_demographic_evn(_cid);

    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_rec.pv1_19_1) THEN
    	-- Check if already exists
    	IF NOT EXISTS (SELECT 1 FROM leaveofabsence loa WHERE loa.visit_nb = v_rec.pv1_19_1 AND loa.sequencenb = v_rec.pv1_24_1) THEN
    		INSERT INTO leaveofabsence (visit_nb, sequencenb, startdt, enddt, source, sourceid) VALUES (v_rec.pv1_19_1, v_rec.pv1_24_1, v_rec.evn_6_1, null, _src, v_rec.control_id);
    	END IF;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_rec.pv1_19_1);
    END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION patient_loa(VARCHAR, VARCHAR)
  OWNER TO fluance;
