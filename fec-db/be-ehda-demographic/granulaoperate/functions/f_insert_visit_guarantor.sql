/*
	Function: insert_visit_guarantor

	This function's goal is to add/update guarantors linked to a visit in operate database.
	Also, this function is designed to handle occasional guarantors.

	Parameters:
		_vn - BIGINT visit number.
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<guarantor>, <visit_guarantor>, <guarantor_contact>, <contact>, <fdw_demographic_adt_gt1>
*/
CREATE FUNCTION insert_visit_guarantor(_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $BODY$

DECLARE
  v_gua_id INTEGER;
  v_con_id BIGINT;
  v_gc XML;
  v_eqt VARCHAR(20);
  v_nbt VARCHAR(20);
  v_cf1 VARCHAR;
  v_cf4 VARCHAR;
  v_cf9 VARCHAR;
  v_gua RECORD;

BEGIN
  IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
  END IF;

  --Loop on gt1 segment to handle occasional guarantor
  FOR v_gua IN
    SELECT * FROM fdw_demographic_adt_gt1(_cid) ORDER BY gt1_15_1, gt1_29_1
  LOOP
    -- Check if the guarantor is occasional
    IF v_gua.gt1_2_1 IS NULL THEN
      SELECT id INTO v_gua_id FROM guarantor WHERE code = (_vn::text || v_gua.gt1_15_1::text || v_gua.gt1_29_1::text)::text;
      IF NOT FOUND THEN
          -- Insert new guarantor from inbound adt pv1 (occasional)
          INSERT INTO guarantor (code, name, address, address2, locality, postcode, canton, country, complement, begindate, enddate, occasional, source, sourceid)
                      VALUES ((_vn::text || v_gua.gt1_15_1::text || v_gua.gt1_29_1::text)::text, v_gua.gt1_3_1, v_gua.gt1_5_1, v_gua.gt1_5_2, v_gua.gt1_5_3, v_gua.gt1_5_5, get_refdata('TBS.OPA.CANTON', v_gua.companycode, v_gua.gt1_5_4, 'm_rd_opa_input'), get_refdata('TBS.OPA.PAYS', v_gua.companycode, v_gua.gt1_5_6, 'm_rd_opa_input'),
    			v_gua.gt1_5_9, v_gua.gt1_13_1, v_gua.gt1_14_1, true, _src, v_gua.control_id)
          RETURNING id INTO v_gua_id;
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
    				RETURNING id INTO v_con_id;
    			ELSIF (v_cf4 IS NOT NULL) THEN
    				INSERT INTO contact (nbtype, equipment, data, holder, source, sourceid) VALUES (v_nbt, v_eqt, v_cf4, v_cf9, _src, _cid)
    				RETURNING id INTO v_con_id;
    			END IF;

    			INSERT INTO guarantor_contact VALUES (v_gua_id, v_con_id);
    		END IF;
          END LOOP;
      END IF;
      -- Add occasional guarantor to a visit
      INSERT INTO visit_guarantor VALUES (_vn, v_gua_id, v_gua.gt1_15_1, v_gua.gt1_11_1, v_gua.gt1_11_2, v_gua.gt1_13_1, v_gua.gt1_14_1, v_gua.gt1_16_1, v_gua.gt1_19_1, v_gua.gt1_25_1, v_gua.gt1_29_1, v_gua.gt1_54_1, _src, v_gua.control_id);
    ELSE
      -- Add guarantor to a visit
      -- Get guarantor ID
      SELECT id INTO v_gua_id FROM guarantor WHERE code = v_gua.gt1_2_1;
      -- Insert only if guarantor ID is assigned
      IF (v_gua_id IS NOT NULL) THEN
	       INSERT INTO visit_guarantor VALUES (_vn, v_gua_id, v_gua.gt1_15_1, v_gua.gt1_11_1, v_gua.gt1_11_2, v_gua.gt1_13_1, v_gua.gt1_14_1, v_gua.gt1_16_1, v_gua.gt1_19_1, v_gua.gt1_25_1, v_gua.gt1_29_1, v_gua.gt1_54_1, _src, v_gua.control_id);
      END IF;
    END IF;
  END LOOP;
END;
$BODY$ LANGUAGE plpgsql;

ALTER FUNCTION insert_visit_guarantor(BIGINT, VARCHAR, VARCHAR)
  OWNER TO fluance;
