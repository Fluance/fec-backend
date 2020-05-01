/*
	Function: insert_guarantor
	
	This function is used to insert guarantor from granulainbound to granulaoperate.
	Mirth uses this function when it receive a MFN-Z61/MAD hl7 message type.

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		IF (!code_guarantor) THEN
			insert guarantor
			insert guarantor contact
		END IF;
		(end code)

	See also:
		<guarantor>, <contact>, <guarantor_contact>
*/
CREATE FUNCTION insert_guarantor(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
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

	-- Insert new guarantor with data from inbound db, if not already existing
	SELECT id INTO v_garid FROM guarantor WHERE code = (SELECT gt1_2_1 FROM fdw_demographic_mfn_gt1(_cid));

	IF NOT FOUND THEN

		INSERT INTO guarantor (code, name, address, address2, locality, postcode, canton, country, complement, begindate, enddate, occasional, source, sourceid)
								SELECT gt1_2_1, gt1_3_1, gt1_5_1, gt1_5_2, gt1_5_3, gt1_5_5, get_refdata('TBS.OPA.CANTON', companycode, gt1_5_4, 'm_rd_opa_input'),
									get_refdata('TBS.OPA.PAYS', companycode, gt1_5_6, 'm_rd_opa_input'), gt1_5_9, gt1_13_1, gt1_14_1, false, _src, control_id
								FROM fdw_demographic_mfn_gt1(_cid)
		RETURNING id INTO v_garid;

		/*
		* Store contacts if exist
		* Get standardized HL7 names for telecommunication equipment type and use code
		*/

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
	END IF;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION insert_guarantor(VARCHAR, VARCHAR)
  OWNER TO fluance;
