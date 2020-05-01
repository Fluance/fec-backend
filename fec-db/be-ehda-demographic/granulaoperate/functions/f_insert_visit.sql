/*
	Function: insert_visit
	
	This function's goal is to insert a new visit for a patient.
	- It needs to update the patient details because the ADT event A28 is missing some information (done in Mirth channel).
	- This function is called by Mirth with the HL7 ADT event A01/A04/A05
	- In order to handle the reservation (pre-admit) of a visit, we have to test if the visit is already created. (this occured when we received A01/A04 after a previous A05 HL7 ADT event)

	Parameters:
		_cid - BIGINT control_id of the hl7 data in inbound.
		_src - VARCHAR application source name.

	Returns:
		None

	Algo:
		(start code)
		IF v_vn = NULL THEN
			insert the visit/visit_physician/visit_guarantor/visit_obs_result/visit_healthcare
		ELSE
			update the visit
		(end code)

	See also:
		<visit>, <manage_visit_physician>, <manage_visit_guarantor>, <insert_visit_obs_result>, <manage_healthcare>, <update_visit>, <fdw_demographic_pv1_pv2>
*/
CREATE FUNCTION insert_visit(_cid VARCHAR(255), _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
	v_vn BIGINT := NULL;

BEGIN
	IF (_cid <> '') IS NOT TRUE THEN
		PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _cid');
	END IF;

	-- Get visit nb
	SELECT nb INTO v_vn FROM visit WHERE nb = (SELECT pv1_19_1 FROM fdw_demographic_pv1_pv2(_cid));

	-- If visit nb not found, insert it
	IF NOT FOUND THEN

		-- Insert new visit with data from inbound db
		INSERT INTO visit SELECT pv1_19_1, pid, pv1_2_1, pv1_3_1, pv1_3_2, pv1_3_3, pv1_3_5, company_id, pv1_4_1, pv1_6_1, pv1_6_2, pv1_6_3, pv1_10_1, pv1_12_1,
						pv1_14_1, pv1_18_1, pv1_19_4, pv1_20_1, pv1_21_1, pv1_24_1, pv1_34_1, pv1_36_1, pv1_37_1, pv1_38_1, pv1_41_1, pv1_43_1,
						pv1_44_1, pv1_45_1, pv1_47_1, pv1_50_1, pv1_51_1, pv2_3_1, pv2_6_1, pv2_8_1, pv2_9_1, pv2_16_1, pv2_17_1, pv2_18_1,
						pv2_19_1, pv2_33_1, pv2_41_1, pv2_12_1, pv2_41_4, pv2_41_5, pv2_41_2, pv2_41_6, admitstatus, _src, control_id
						FROM fdw_demographic_pv1_pv2(_cid)
		RETURNING nb INTO v_vn;

		/*
		* Store physicians if exists
		*/
		PERFORM manage_visit_physician(v_vn, _cid, _src);

		/*
		* Store guarantors if exists
		*/
		PERFORM manage_visit_guarantor(v_vn, _cid, _src);

		/*
		* Store observations results if exists
		*/
		PERFORM insert_visit_obs_result(v_vn, _cid, _src);

		/*
		* Store new healthcare information
		*/
		PERFORM manage_healthcare(v_vn, _cid, _src);

	ELSE
		-- Update already existing visit
		PERFORM update_visit(_cid, _src);
	END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_visit(VARCHAR, VARCHAR)
  OWNER TO fluance;
