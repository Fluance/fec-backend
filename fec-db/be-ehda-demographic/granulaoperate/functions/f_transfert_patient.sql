/*
	Function: transfert_patient

	This function's goal is to transfert a patient to another unit, room, bed and service.

	It includes :
		- patient unit
		- patient room
		- patient bed
		- patient case
		- prior patient unit
		- prior patient room
		- prior patient bed
		- hospservice

	This function is called by Mirth with the HL7 event ADT-A02 or ADT-A12 (transfert patient).

	It updates the fields PV1.3.1, PV1.3.2, PV1.3.3, PV1.6.1, PV1.6.2, PV1.6.3 and PV1.10.1

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<visit>
*/
CREATE FUNCTION transfert_patient(_cid VARCHAR(255), _src VARCHAR(50))

RETURNS VOID AS $$

DECLARE
  v_pid BIGINT;
  v_vn BIGINT;
  v_pu VARCHAR(255);
  v_pr VARCHAR(255);
  v_pb VARCHAR(255);
  v_pc VARCHAR(255);
  v_hs VARCHAR(20);
  v_ppu VARCHAR(255);
  v_ppr VARCHAR(255);
  v_ppb VARCHAR(255);
  v_cid VARCHAR(255);

BEGIN
  IF (_cid <> '') IS NOT TRUE THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
  END IF;

  -- Get visit details
  SELECT pid, pv1_19_1, pv1_3_1, pv1_3_2, pv1_3_3, pv1_3_5, pv1_6_1, pv1_6_2, pv1_6_3, pv1_10_1, control_id INTO v_pid, v_vn, v_pu, v_pr, v_pb, v_pc, v_ppu, v_ppr, v_ppb, v_hs, v_cid FROM fdw_demographic_pv1_pv2(_cid);

  -- Check if visit exists
  IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_vn AND v.patient_id = v_pid) THEN
	-- Update visit
	UPDATE visit SET patientunit = v_pu, patientroom = v_pr, patientbed = v_pb, patientcase = v_pc, priorunit = v_ppu, priorroom = v_ppr, priorbed = v_ppb, hospservice = v_hs, source = _src, sourceid = v_cid WHERE nb = v_vn;
  ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER ' || v_vn || ' WITH PATIENT ID ' || v_pid);
  END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION transfert_patient(VARCHAR, VARCHAR)
  OWNER TO fluance;
