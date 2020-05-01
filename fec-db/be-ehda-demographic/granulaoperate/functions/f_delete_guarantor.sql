/*
	Function: delete_guarantor

	This function is used by mirth in the channel P_DEMOGRAPHIC_HL7_BM when a MFN-Z61/MDL HL7 message is received.
	Delete a guarantor.

	Parameters:
		_cid - control id of the record

	Returns:
		None

	Algo:
		(start code)
		IF (v_garid) THEN
			DELETE ALL CONTACTS (v_garid)
			DELETE GUARANTOR(v_garid)
		ENDIF
		(end code)

	See also:
		<guarantor>, <contact>, <fdw_demographic_mfn_gt1>
*/
CREATE FUNCTION delete_guarantor(_cid VARCHAR(255))
RETURNS VOID AS $$

DECLARE
	v_garid INTEGER;
	v_garcode VARCHAR;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Get guarantor ID
	SELECT g.id, gt1.gt1_2_1 INTO v_garid, v_garcode FROM guarantor g, fdw_demographic_mfn_gt1(_cid) gt1 WHERE g.code = gt1.gt1_2_1;

	-- If guarantor ID found, delete it
	IF FOUND THEN
		-- Delete existing contacts
		DELETE FROM contact WHERE id IN (SELECT contact_id FROM guarantor_contact WHERE guarantor_id = v_garid);

		-- Delete guarantor
		DELETE FROM guarantor WHERE id = v_garid;
	END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION delete_guarantor(VARCHAR)
  OWNER TO fluance;
