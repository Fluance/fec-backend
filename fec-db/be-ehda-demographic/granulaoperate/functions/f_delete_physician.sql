/*
	Function: delete_physician

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a MFN-M02/MDL HL7 message is received.
	Delete a physician.

	Parameters:
		_cid - control id of the record

	Returns:
		None

	Algo:
		(start code)
		IF (v_phyid) THEN
			DELETE ALL CONTACT (v_phyid)
			DELETE PHYSICIAN (v_phyid)
		ENDIF
		(end code)

	See also:
		<contact>, <physician>, <physician_contact>, <refdata>, <fdw_demographic_stf_pra>
*/
CREATE FUNCTION delete_physician(_cid VARCHAR(255))
RETURNS VOID AS $$

DECLARE
	v_phyid INTEGER;
	v_sid INTEGER;
	v_compid INTEGER;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Get physician ID
	SELECT p.id, stf.sid, stf.company_id INTO v_phyid, v_sid, v_compid FROM physician p, fdw_demographic_stf_pra(_cid) stf WHERE p.staffid = stf.sid AND p.company_id = stf.company_id;

	-- If physician ID found, delete it
	IF FOUND THEN
		-- Delete existing contacts
		DELETE FROM contact WHERE id IN (SELECT contact_id FROM physician_contact WHERE physician_id = v_phyid);

		-- Delete physician
		DELETE FROM physician WHERE id = v_phyid;
	END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_physician(VARCHAR)
  OWNER TO fluance;
