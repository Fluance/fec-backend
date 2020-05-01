/*
	Function: update_physician

	This function's goal is to update physician's data in granulaoperate database.
	This function is called by Mirth with the HL7 event MFN-M02/MUP (update physician).
	Also, it removes then add all the contact's details of this particular physician.

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<physician>, <contact>, <physician_contact>, <refdata>, <fdw_demographic_stf_pra>
*/
CREATE FUNCTION update_physician(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_rec RECORD;
	v_phyid INTEGER;
	v_conid BIGINT;
	v_pc XML;
	v_eqt VARCHAR(20);
	v_nbt VARCHAR(20);
	v_cf1 VARCHAR;
	v_cf4 VARCHAR;
	v_cf9 VARCHAR;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Update physician with data from inbound db
	SELECT * INTO v_rec FROM fdw_demographic_stf_pra(_cid);

	SELECT p.id INTO v_phyid FROM physician p WHERE p.staffid = v_rec.sid AND p.company_id = v_rec.company_id;

	-- If physician ID not found, raise an exception	
	IF NOT FOUND THEN
        	PERFORM raise_error('EXCEPTION', 'Nonexistent PHYSICIAN STAFFID '|| v_rec.sid || ' WITH COMPANYID ' || v_rec.company_id);
	END IF;

	UPDATE physician SET lastname = v_rec.stf_3_1, firstname = v_rec.stf_3_2, prefix = v_rec.stf_3_5, alternateid = v_rec.altid, alternateidname = v_rec.altidname, speciality = v_rec.pra_5_1, address = v_rec.stf_11_1,
				locality = v_rec.stf_11_3, postcode = v_rec.stf_11_5, canton = get_refdata('TBS.OPA.CANTON', v_rec.companycode, v_rec.stf_11_4, 'm_rd_opa_input'),
				country = get_refdata('TBS.OPA.PAYS', v_rec.companycode, v_rec.stf_11_6, 'm_rd_opa_input'), complement = v_rec.stf_11_9,
				language = get_refdata('TBS.OPA.LANG', v_rec.companycode, v_rec.stf_27_1, 'm_rd_opa_input'), startdate = v_rec.stf_12_1,
				enddate = v_rec.stf_13_1, employmentcode = v_rec.stf_20_1, source = _src, sourceid = v_rec.control_id
	WHERE id = v_phyid;

	/*
	 * Delete existing contacts and store new ones if exist
	 * Get standardized HL7 names for telecommunication equipment type and use code
	 */
	DELETE FROM contact WHERE id IN (SELECT contact_id FROM physician_contact WHERE physician_id = v_phyid);

	FOR v_pc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
						SELECT unnest(xpath('/HL7Message/STF/STF.10', hm)) FROM x WHERE xmlexists('/HL7Message/STF/STF.10/node()' PASSING BY REF hm)$$, _cid)
	LOOP
		IF (xmlexists('/STF.10/node()' PASSING BY REF v_pc)) THEN
			v_eqt = get_contact_eqt(CAST((xpath('/STF.10/STF.10.3/text()', v_pc))[1] AS VARCHAR));
			v_nbt = get_contact_nbt(CAST((xpath('/STF.10/STF.10.2/text()', v_pc))[1] AS VARCHAR));
			v_cf1 = CAST((xpath('/STF.10/STF.10.1/text()', v_pc))[1] AS VARCHAR);
			v_cf4 = CAST((xpath('/STF.10/STF.10.4/text()', v_pc))[1] AS VARCHAR);
			v_cf9 = CAST((xpath('/STF.10/STF.10.9/text()', v_pc))[1] AS VARCHAR);

			IF (v_cf1 IS NOT NULL) THEN
				INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
				RETURNING id INTO v_conid;
			ELSIF (v_cf4 IS NOT NULL) THEN
				INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
				RETURNING id INTO v_conid;
			END IF;

			INSERT INTO physician_contact VALUES (v_phyid, v_conid);
		END IF;
	END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION update_physician(VARCHAR, VARCHAR)
  OWNER TO fluance;
