/*
	Function: insert_physician
		This function's goal is to add physicians.
 		Mirth calls this function when a HL7 event MFN-M02/MAD occured. (insert physician).

	Parameters:
		_cid - control_id of the hl7 data in inbound.
		_src - application source name.

	Returns:
		None
	Algo:
		(start code)
		-- check if physician is already inserted
		IF !(code_physician & com_id) THEN
			insert physician
			insert phyisican contact
		END IF;
		(end code)
	
	See also:
		<physician>, <fdw_demographic_stf_pra>, <physician_contact>, <contact>, <refdata>
*/
CREATE FUNCTION insert_physician(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
	v_phyid INTEGER;
	v_sid INTEGER;
	v_compid INTEGER;
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

	-- Insert new physician with data from inbound db, if not already existing
	SELECT p.id, stf.sid, stf.company_id INTO v_phyid, v_sid, v_compid FROM physician p, fdw_demographic_stf_pra(_cid) stf WHERE p.staffid = stf.sid AND p.company_id = stf.company_id;

	IF NOT FOUND THEN

		INSERT INTO physician (lastname, firstname, prefix, staffid, alternateid, alternateidname, speciality, address, locality, postcode, canton,
							country, complement, language, startdate, enddate, employmentcode, company_id, source, sourceid)
							SELECT stf_3_1, stf_3_2, stf_3_5, sid, altid, altidname, pra_5_1, stf_11_1, stf_11_3, stf_11_5,
								get_refdata('TBS.OPA.CANTON', companycode, stf_11_4, 'm_rd_opa_input'), get_refdata('TBS.OPA.PAYS', companycode, stf_11_6, 'm_rd_opa_input'),
								stf_11_9, get_refdata('TBS.OPA.LANG', companycode, stf_27_1, 'm_rd_opa_input'), stf_12_1, stf_13_1, stf_20_1, company_id, _src, control_id
							FROM fdw_demographic_stf_pra(_cid)
		RETURNING id INTO v_phyid;

		/*
		* Store contacts if exist
		* Get standardized HL7 names for telecommunication equipment type and use code
		*/
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
	END IF;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION insert_physician(VARCHAR, VARCHAR)
  OWNER TO fluance;
