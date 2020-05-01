/*
	Function: update_patient
	
	This function's goal is to update patient's data in granulaoperate database.
	Next of kin are also added here.
	This function is called by Mirth with the HL7 event ADT-A31/A08 (update patient informations).

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<patient>, <contact>, <nextofkin>, <insert_nextofkin>, <refdata>, <fdw_demographic_pid>
*/
CREATE FUNCTION update_patient(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_rec RECORD;
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

	-- Update patient with data from inbound db
	SELECT * INTO v_rec FROM fdw_demographic_pid(_cid);
	
	IF FOUND THEN
		-- If patient ID not found, raise an exception
		IF NOT EXISTS (SELECT 1 FROM patient WHERE id = v_rec.pid) THEN
			PERFORM raise_error('EXCEPTION', 'Nonexistent PID: ' || v_rec.pid || ' provided by ' || v_rec.companycode);
		END IF;

		UPDATE patient SET lastname = v_rec.pid_5_1, firstname = v_rec.pid_5_2, maidenname = v_rec.pid_6_1, mothername = v_rec.mn, fathername = v_rec.fn, spousename = v_rec.sn, courtesy = v_rec.pid_5_5, birthplace = v_rec.pid_23_1, birthdate = v_rec.pid_7_1,
			origin = v_rec.pid_24_1, nationality = get_refdata('TBS.OPA.PAYS', v_rec.companycode, v_rec.pid_28_1, 'm_rd_opa_input'), sex = get_refdata('TBS.OPA.SEXE', v_rec.companycode, v_rec.pid_8_1, 'm_rd_opa_input'),
			address = v_rec.pid_11_1, address2 = v_rec.pid_11_2, careof = v_rec.pid_11_7, locality = v_rec.pid_11_3, postcode = v_rec.pid_11_5, subpostcode = v_rec.pid_11_8,
			canton = get_refdata('TBS.OPA.CANTON', v_rec.companycode, v_rec.pid_11_4, 'm_rd_opa_input'), country = get_refdata('TBS.OPA.PAYS', v_rec.companycode, v_rec.pid_11_6, 'm_rd_opa_input'),
			complement = v_rec.pid_11_9, maritalstatus = get_refdata('TBS.OPA.ETACIV', v_rec.companycode, v_rec.pid_16_1, 'm_rd_opa_input'), language = get_refdata('TBS.OPA.LANG', v_rec.companycode, v_rec.pid_15_1, 'm_rd_opa_input'),
			confession = get_refdata('TBS.OPA.CONF', v_rec.companycode, v_rec.pid_17_1, 'm_rd_opa_input'), avsnb = v_rec.pid_31_1, oldavsnb = v_rec.pid_19_1, passportnb = v_rec.pid_20_1, mothervnb = v_rec.pid_21_1, jobtitle = v_rec.pid_27_1, employer = v_rec.pid_27_2,
			workplace = v_rec.pid_27_3, incorporation = v_rec.pid_27_4, deadbeat = v_rec.pid_25_1, death = v_rec.pid_30_1, deathdt = v_rec.pid_29_1, source = _src , sourceid = v_rec.control_id
		WHERE id = v_rec.pid;

		/*
		 * Delete existing contacts and store new ones if exist
		 * Get standardized HL7 names for telecommunication equipment type and use code
		 */
		DELETE FROM contact WHERE id IN (SELECT contact_id FROM patient_contact WHERE patient_id = v_rec.pid);

		FOR v_pc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
							SELECT unnest(xpath('/HL7Message/PID/PID.13', hm)) FROM x WHERE xmlexists('/HL7Message/PID/PID.13/node()' PASSING BY REF hm)$$, _cid)
		LOOP
			IF (xmlexists('/PID.13/node()' PASSING BY REF v_pc)) THEN
				v_eqt = get_contact_eqt(CAST((xpath('/PID.13/PID.13.3/text()', v_pc))[1] AS VARCHAR));
				v_nbt = get_contact_nbt(CAST((xpath('/PID.13/PID.13.2/text()', v_pc))[1] AS VARCHAR));
				v_cf1 = CAST((xpath('/PID.13/PID.13.1/text()', v_pc))[1] AS VARCHAR);
				v_cf4 = CAST((xpath('/PID.13/PID.13.4/text()', v_pc))[1] AS VARCHAR);
				v_cf9 = CAST((xpath('/PID.13/PID.13.9/text()', v_pc))[1] AS VARCHAR);

				IF (v_cf1 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_rec.pid, v_conid);
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_rec.pid, v_conid);
				END IF;
			END IF;
		END LOOP;
		
		v_conid := NULL;

		FOR v_pc IN EXECUTE format($$WITH x AS (SELECT hl7_msg AS hm FROM demographic_hl7 WHERE control_id = %L)
						SELECT unnest(xpath('/HL7Message/PID/PID.14', hm)) FROM x WHERE xmlexists('/HL7Message/PID/PID.14/node()' PASSING BY REF hm)$$, _cid)
		LOOP
			IF (xmlexists('/PID.14/node()' PASSING BY REF v_pc)) THEN
				v_eqt = get_contact_eqt(CAST((xpath('/PID.14/PID.14.3/text()', v_pc))[1] AS VARCHAR));
				v_nbt = get_contact_nbt(CAST((xpath('/PID.14/PID.14.2/text()', v_pc))[1] AS VARCHAR));
				v_cf1 = CAST((xpath('/PID.14/PID.14.1/text()', v_pc))[1] AS VARCHAR);
				v_cf4 = CAST((xpath('/PID.14/PID.14.4/text()', v_pc))[1] AS VARCHAR);
				v_cf9 = CAST((xpath('/PID.14/PID.14.9/text()', v_pc))[1] AS VARCHAR);

				IF (v_cf1 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf1, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_rec.pid, v_conid);
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_rec.pid, v_conid);
				END IF;
			END IF;
		END LOOP;

		/*
		* Delete existing nextofkin, nextofkin contact and store new ones if exist
		*/
		DELETE FROM contact WHERE id IN (SELECT contact_id FROM nextofkin_contact WHERE nextofkin_id IN (SELECT id FROM nextofkin WHERE patient_id = v_rec.pid));
		DELETE FROM nextofkin WHERE patient_id = v_rec.pid;

		/*
		* Store nextofkin and nextofkin contact
		*/
		PERFORM insert_nextofkin (_cid, _src);
	END IF;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION update_patient(VARCHAR, VARCHAR)
  OWNER TO fluance;
