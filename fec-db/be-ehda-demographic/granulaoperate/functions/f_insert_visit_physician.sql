/*
	Function: insert_visit_physician

	This function's goal is to add/update physicians linked to a visit in operate database.
	Also, this function is designed to handle occasional physicians.

	Parameters:
		_vn  - BIGINT  visit number
		_cid - VARCHAR control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	See also:
		<physician>, <visit_physician>, <fdw_demographic_pv1>
*/
CREATE FUNCTION insert_visit_physician(_vn BIGINT, _cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
  v_att_phy INTEGER;
  v_ref_phy INTEGER;
  v_con_phy INTEGER;
  v_adm_phy INTEGER;
  v_phy RECORD;

BEGIN
  IF _vn IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _vn');
  END IF;

  -- Get the pv1 segment to handle occasional physician
  SELECT * INTO v_phy FROM fdw_demographic_pv1(_cid);

  IF FOUND THEN
    /*
     * Handeling occaional attending physician
     */
    IF v_phy.pv1_7_2 IS NOT NULL THEN
      IF v_phy.pv1_7_1 IS NULL THEN
        -- Test if occasional physician already exists
        SELECT id INTO v_att_phy FROM physician WHERE  company_id = v_phy.company_id AND staffid = (v_phy.pv1_19_1::text || v_phy.pv1_7_8::text)::integer;
        IF NOT FOUND THEN
            -- Insert new physician from inbound adt pv1 (occasional)
            INSERT INTO physician (staffid, lastname, company_id ,occasional, source, sourceid)
                        VALUES ((v_phy.pv1_19_1::text || v_phy.pv1_7_8::text)::integer, v_phy.pv1_7_2, v_phy.company_id, true, _src, v_phy.control_id)
            RETURNING id INTO v_att_phy;
        END IF;
      ELSE
        SELECT id INTO v_att_phy FROM physician WHERE company_id = v_phy.company_id AND staffid = v_phy.pv1_7_1;
        IF NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent attending PHYSICIAN: STAFFID (' || v_phy.pv1_7_1 || '), COMPANYID (' || v_phy.company_id || ')');
        END IF;
      END IF;
    END IF;

    /*
     * Handeling occasional referring physician
     */
    IF v_phy.pv1_8_2 IS NOT NULL THEN
      IF v_phy.pv1_8_1 IS NULL THEN
        -- Test if occasional physician already exists
        SELECT id INTO v_ref_phy FROM physician WHERE  company_id = v_phy.company_id AND staffid = (v_phy.pv1_19_1::text || v_phy.pv1_8_8::text)::integer;
        IF NOT FOUND THEN
            -- Insert new physician from inbound adt pv1 (occasional)
            INSERT INTO physician (staffid, lastname, company_id ,occasional, source, sourceid)
                        VALUES ((v_phy.pv1_19_1::text || v_phy.pv1_8_8::text)::integer, v_phy.pv1_8_2, v_phy.company_id, true, _src, v_phy.control_id)
            RETURNING id INTO v_ref_phy;
        END IF;
      ELSE
        SELECT id INTO v_ref_phy FROM physician WHERE company_id = v_phy.company_id AND staffid = v_phy.pv1_8_1;
        IF NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent attending PHYSICIAN: STAFFID (' || v_phy.pv1_8_1 || '), COMPANYID (' || v_phy.company_id || ')');
        END IF;
      END IF;
    END IF;

    /*
     * Handeling occasional consulting physician
     */
    IF v_phy.pv1_9_2 IS NOT NULL THEN
      IF v_phy.pv1_9_1 IS NULL THEN
        -- Test if occasional physician already exists
        SELECT id INTO v_con_phy FROM physician WHERE  company_id = v_phy.company_id AND staffid = (v_phy.pv1_19_1::text || v_phy.pv1_9_8::text)::integer;
        IF NOT FOUND THEN
            -- Insert new physician from inbound adt pv1 (occasional)
            INSERT INTO physician (staffid, lastname, company_id ,occasional, source, sourceid)
                        VALUES ((v_phy.pv1_19_1::text || v_phy.pv1_9_8::text)::integer, v_phy.pv1_9_2, v_phy.company_id, true, _src, v_phy.control_id)
            RETURNING id INTO v_con_phy;
        END IF;
      ELSE
        SELECT id INTO v_con_phy FROM physician WHERE company_id = v_phy.company_id AND staffid = v_phy.pv1_9_1;
        IF NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent attending PHYSICIAN: STAFFID (' || v_phy.pv1_9_1 || '), COMPANYID (' || v_phy.company_id || ')');
        END IF;
      END IF;
    END IF;

    /*
     * Handeling occasional admitting physician
     */
    IF v_phy.pv1_17_2 IS NOT NULL THEN
      IF v_phy.pv1_17_1 IS NULL THEN
        -- Test if occasional physician already exists
        SELECT id INTO v_adm_phy FROM physician WHERE  company_id = v_phy.company_id AND staffid = (v_phy.pv1_19_1::text || v_phy.pv1_17_8::text)::integer;
        IF NOT FOUND THEN
            -- Insert new physician from inbound adt pv1 (occasional)
            INSERT INTO physician (staffid, lastname, company_id ,occasional, source, sourceid)
                        VALUES ((v_phy.pv1_19_1::text || v_phy.pv1_17_8::text)::integer, v_phy.pv1_17_2, v_phy.company_id, true, _src, v_phy.control_id)
            RETURNING id INTO v_adm_phy;
        END IF;
      ELSE
        SELECT id INTO v_adm_phy FROM physician WHERE company_id = v_phy.company_id AND staffid = v_phy.pv1_17_1;
        IF NOT FOUND THEN
		PERFORM raise_error('EXCEPTION', 'Nonexistent attending PHYSICIAN: STAFFID (' || v_phy.pv1_17_1 || '), COMPANYID (' || v_phy.company_id || ')');
        END IF;
      END IF;
    END IF;

    -- Insert visit_physician for the visit
    IF (v_att_phy IS NOT NULL OR v_ref_phy IS NOT NULL OR v_con_phy IS NOT NULL OR v_adm_phy IS NOT NULL) THEN
      INSERT INTO visit_physician VALUES (_vn, v_att_phy, v_ref_phy, v_con_phy, v_adm_phy, _src, v_phy.control_id);
    END IF;

  END IF;
END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_visit_physician(BIGINT, VARCHAR, VARCHAR)
  OWNER TO fluance;
