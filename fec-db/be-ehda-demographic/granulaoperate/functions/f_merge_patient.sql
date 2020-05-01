/*
	Function: merge_patient
	
	This function is called when there is a complete or partial transfert of a visit from a patient to another.
	Mirth calls this function on a ADT-A45 HL7 event.
	Keep in mind that when a patient X merges with a patient Y, patient X's address erase patient Y's address.

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<fdw_demographic_mrg>, <fdw_demographic_pid>, <update_patient>, <visit>
*/
CREATE FUNCTION merge_patient(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
  v_rec RECORD;

BEGIN
  IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
  END IF;

  -- Get visit nb to be merged
  SELECT mrg_1_1, mrg_5_1 INTO v_rec FROM fdw_demographic_mrg(_cid);

  -- If visit nb is found update it, else raise an exception
  IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_rec.mrg_5_1 AND v.patient_id = v_rec.mrg_1_1) THEN
	UPDATE visit SET patient_id = q.pid, source = _src, sourceid = q.control_id
	FROM (SELECT pid, control_id FROM fdw_demographic_pid(_cid)) q
	WHERE nb = v_rec.mrg_5_1 AND patient_id = v_rec.mrg_1_1;
  ELSE
	PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_rec.mrg_5_1 || ' WITH PATIENT ID ' || v_rec.mrg_1_1);
  END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION merge_patient(VARCHAR, VARCHAR)
  OWNER TO fluance;
