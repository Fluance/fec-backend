/*
	Function: insert_nextofkin
		
	This function is used to insert a specific next of kin from granulainbound to granulaoperate.

	Parameters:
		_cid - control id of the record
		_src - source application name

	Returns:
		None

	Algo:
		(start code)
		for nextofkins of a specific record
			insert nextofkin
			store contacts if exist
		end for
		(end code)

	See also:
		<nextofkin>, <nextofkin_contact>, <contact>, <fdw_demographic_nk1>, <get_contact_eqt>, <get_contact_nbt>, <get_refdata>
*/
CREATE FUNCTION insert_nextofkin(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_nkid BIGINT;
	v_conid BIGINT;
	v_nokc XML;
	v_eqt VARCHAR(20);
	v_nbt VARCHAR(20);
	v_cf1 VARCHAR;
	v_cf4 VARCHAR;
	v_cf9 VARCHAR;
	v_nokp RECORD;

BEGIN

	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;
	
	FOR v_nokp IN
		SELECT pid, nk1_2_1, nk1_2_2, nk1_2_5, nk1_3_1, nk1_4_1, nk1_4_2, nk1_4_7, nk1_4_3, nk1_4_5, nk1_4_4, nk1_4_6, nk1_4_9, nk1_10_1, nk1_13_1, nk1_11_1, nk1_22_1, nk1_23_1, _src, control_id, companycode
		FROM fdw_demographic_nk1(_cid)
	LOOP

		-- Insert new nextofkin with data from inbound db
		INSERT INTO nextofkin (patient_id, lastname, firstname, courtesy, type, address, address2, careof, locality, postcode, canton, country, complement, jobtitle, employer, workplace, relationship, addresstype, source, sourceid)
				VALUES (v_nokp.pid, v_nokp.nk1_2_1, v_nokp.nk1_2_2, v_nokp.nk1_2_5, get_refdata('TBS.OPA.TYPADR', v_nokp.companycode, v_nokp.nk1_3_1, 'm_rd_opa_input'), v_nokp.nk1_4_1, v_nokp.nk1_4_2, v_nokp.nk1_4_7, v_nokp.nk1_4_3, v_nokp.nk1_4_5,
				get_refdata('TBS.OPA.CANTON', v_nokp.companycode, v_nokp.nk1_4_4, 'm_rd_opa_input'), get_refdata('TBS.OPA.PAYS', v_nokp.companycode, v_nokp.nk1_4_6, 'm_rd_opa_input'), v_nokp.nk1_4_9, v_nokp.nk1_10_1, v_nokp.nk1_13_1, v_nokp.nk1_11_1,
				v_nokp.nk1_22_1, v_nokp.nk1_23_1, v_nokp._src, v_nokp.control_id)
		RETURNING id INTO v_nkid;

		/*
		* Store contacts if exist
		* Get standardized HL7 names for telecommunication equipment type and use code
		*/
		FOR v_nokc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
						SELECT unnest(xpath('/HL7Message/PID/PID.13', hm)) FROM x WHERE xmlexists('/HL7Message/PID/PID.13/node()' PASSING BY REF hm)$$, _cid)
		 LOOP
			IF (xmlexists('/PID.13/node()' PASSING BY REF v_nokc)) THEN
				v_eqt = get_contact_eqt(CAST((xpath('/PID.13/PID.13.3/text()', v_nokc))[1] AS VARCHAR));
				v_nbt = get_contact_nbt(CAST((xpath('/PID.13/PID.13.2/text()', v_nokc))[1] AS VARCHAR));
				v_cf1 = CAST((xpath('/PID.13/PID.13.1/text()', v_nokc))[1] AS VARCHAR);
				v_cf4 = CAST((xpath('/PID.13/PID.13.4/text()', v_nokc))[1] AS VARCHAR);
				v_cf9 = CAST((xpath('/PID.13/PID.13.9/text()', v_nokc))[1] AS VARCHAR);

				IF (v_cf1 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
				END IF;

				INSERT INTO nextofkin_contact VALUES (v_nkid, v_conid);
			END IF;
		 END LOOP;

		 FOR v_nokc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
						SELECT unnest(xpath('/HL7Message/PID/PID.14', hm)) FROM x WHERE xmlexists('/HL7Message/PID/PID.14/node()' PASSING BY REF hm)$$, _cid)
		 LOOP
			IF (xmlexists('/PID.14/node()' PASSING BY REF v_nokc)) THEN
				v_eqt = get_contact_eqt(CAST((xpath('/PID.14/PID.14.3/text()', v_nokc))[1] AS VARCHAR));
				v_nbt = get_contact_nbt(CAST((xpath('/PID.14/PID.14.2/text()', v_nokc))[1] AS VARCHAR));
				v_cf1 = CAST((xpath('/PID.14/PID.14.1/text()', v_nokc))[1] AS VARCHAR);
				v_cf4 = CAST((xpath('/PID.14/PID.14.4/text()', v_nokc))[1] AS VARCHAR);
				v_cf9 = CAST((xpath('/PID.14/PID.14.9/text()', v_nokc))[1] AS VARCHAR);

				IF (v_cf1 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
				END IF;

				INSERT INTO nextofkin_contact VALUES (v_nkid, v_conid);
			END IF;
		 END LOOP;
	END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION insert_nextofkin(VARCHAR, VARCHAR)
  OWNER TO fluance;
