/*
	Function: update_guarantor

	This function's goal is to update physician's data in granulaoperate database.
	This function is called by Mirth with the HL7 event MFN-M02/MUP (update physician).
	Also, it removes then add all the contact's details of this particular physician.

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<guarantor>, <contact>, <guarantor_contact>, <refdata>, <fdw_demographic_mfn_gt1>
*/
CREATE FUNCTION update_guarantor(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_rec RECORD;
	v_garid INTEGER;
	v_conid BIGINT;
	v_gc XML;
	v_eqt VARCHAR(20);
	v_nbt VARCHAR(20);
	v_cf1 VARCHAR;
	v_cf4 VARCHAR;
	v_cf9 VARCHAR;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Update guarantor with data from inbound db
	SELECT * INTO v_rec FROM fdw_demographic_mfn_gt1(_cid);
	
	SELECT g.id INTO v_garid FROM guarantor g WHERE g.code = v_rec.gt1_2_1;

	-- If guarantor ID not found, raise an exception
        IF NOT FOUND THEN
                PERFORM raise_error('EXCEPTION', 'Nonexistent GUARANTOR CODE: ' || v_rec.gt1_2_1);
        END IF;

	UPDATE guarantor SET name = v_rec.gt1_3_1, address = v_rec.gt1_5_1, address2 = v_rec.gt1_5_2, locality = v_rec.gt1_5_3, postcode = v_rec.gt1_5_5, canton = get_refdata('TBS.OPA.CANTON', v_rec.companycode, v_rec.gt1_5_4, 'm_rd_opa_input'),
				country = get_refdata('TBS.OPA.PAYS', v_rec.companycode, v_rec.gt1_5_6, 'm_rd_opa_input'), complement = v_rec.gt1_5_9, begindate = v_rec.gt1_13_1, enddate = v_rec.gt1_14_1, source = _src, sourceid = v_rec.control_id
	WHERE id = v_garid;

	/*
	 * Delete existing contacts and store new ones if exist
	 * Get standardized HL7 names for telecommunication equipment type and use code
	 */

	DELETE FROM contact WHERE id IN (SELECT contact_id FROM guarantor_contact WHERE guarantor_id = v_garid);

	FOR v_gc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
					SELECT unnest(xpath('/HL7Message/GT1/GT1.6', hm)) FROM x WHERE xmlexists('/HL7Message/GT1/GT1.6/node()' PASSING BY REF hm)$$, _cid)
	LOOP
		IF (xmlexists('/GT1.6/node()' PASSING BY REF v_gc)) THEN
			v_eqt = get_contact_eqt(CAST((xpath('/GT1.6/GT1.6.3/text()', v_gc))[1] AS VARCHAR));
			v_nbt = get_contact_nbt(CAST((xpath('/GT1.6/GT1.6.2/text()', v_gc))[1] AS VARCHAR));
			v_cf1 = CAST((xpath('/GT1.6/GT1.6.1/text()', v_gc))[1] AS VARCHAR);
			v_cf4 = CAST((xpath('/GT1.6/GT1.6.4/text()', v_gc))[1] AS VARCHAR);
			v_cf9 = CAST((xpath('/GT1.6/GT1.6.9/text()', v_gc))[1] AS VARCHAR);

			IF (v_cf1 IS NOT NULL) THEN
				INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
				RETURNING id INTO v_conid;
			ELSIF (v_cf4 IS NOT NULL) THEN
				INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
				RETURNING id INTO v_conid;
			END IF;

			INSERT INTO guarantor_contact VALUES (v_garid, v_conid);
		END IF;
	END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION update_guarantor(VARCHAR, VARCHAR)
  OWNER TO fluance;
