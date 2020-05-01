/*
	Function: insert_patient

	This function's goal is to add a patient.
	This function is called by Mirth with the HL7 event ADT-A28 (insert patient).
	Also, it is necessary to test if the patient already exists. According to Opale...

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<patient>, <contact>, <nextofkin>, <insert_nextofkin>, <refdata>, <fdw_demographic_pid>
*/
CREATE FUNCTION insert_patient(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_patid BIGINT;
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


	SELECT id FROM patient WHERE id = (SELECT pid INTO v_patid FROM fdw_demographic_pid(_cid));

	-- If patient ID not found, insert it
	IF NOT FOUND THEN
			-- Insert new patient with data from inbound db
			INSERT INTO patient SELECT pid, refnb, pid_5_1, pid_5_2, pid_6_1, mn, fn, sn, pid_5_5, pid_23_1, pid_7_1, pid_24_1, get_refdata('TBS.OPA.PAYS', companycode, pid_28_1, 'm_rd_opa_input'), get_refdata('TBS.OPA.SEXE', companycode, pid_8_1, 'm_rd_opa_input'),
										pid_11_1, pid_11_2, pid_11_7, pid_11_3, pid_11_5, pid_11_8, get_refdata('TBS.OPA.CANTON', companycode, pid_11_4, 'm_rd_opa_input'), get_refdata('TBS.OPA.PAYS', companycode, pid_11_6, 'm_rd_opa_input'),
										pid_11_9, get_refdata('TBS.OPA.ETACIV', companycode, pid_16_1, 'm_rd_opa_input'), get_refdata('TBS.OPA.LANG', companycode, pid_15_1, 'm_rd_opa_input'), get_refdata('TBS.OPA.CONF', companycode, pid_17_1, 'm_rd_opa_input'),
										pid_31_1, pid_19_1, pid_20_1, pid_21_1, pid_27_1, pid_27_2, pid_27_3, pid_27_4, pid_25_1, pid_30_1, pid_29_1, _src, control_id
										FROM fdw_demographic_pid(_cid)
			RETURNING id INTO v_patid;

		/*
		 * Store contacts if exist
		 * Get standardized HL7 names for telecommunication equipment type and use code
		 */
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
					
					INSERT INTO patient_contact VALUES (v_patid, v_conid);
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_patid, v_conid);
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
					
					INSERT INTO patient_contact VALUES (v_patid, v_conid);
				ELSIF (v_cf4 IS NOT NULL) THEN
					INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
					RETURNING id INTO v_conid;
					
					INSERT INTO patient_contact VALUES (v_patid, v_conid);
				END IF;
			END IF;
		 END LOOP;
	END IF;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION insert_patient(VARCHAR, VARCHAR)
  OWNER TO fluance;
