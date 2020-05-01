/*
	Function: insert_visit_benefit

	This function's goal is to insert a medical benefit to a visit in operate database.
	This function is called by Mirth in the channel P_DEMOGRAPHIC_EXP10_BENEFITS when a mutecode 01 is received in export10 message.

	Parameters:
	
		_rid - UUID row id of the HL7 messages in inbound database
		_src - source application name

	Returns: 
		None

	Algo:
		(start code)
			insert visit_benefit;
			manage_visit_benefit_physician;
		(end code)

	See also:
		<visit_benefit>, <manage_visit_benefit_physician>, <fdw_demographic_benefit>
*/
CREATE OR REPLACE FUNCTION insert_visit_benefit(_rid UUID, _src VARCHAR(50))
RETURNS VOID AS $$

DECLARE
	v_ben RECORD;
	v_id BIGINT;
BEGIN

    IF _rid IS NULL THEN
	PERFORM raise_error('EXCEPTION', 'No value given for one required parameter: _rid');
    END IF;

    SELECT * INTO v_ben FROM fdw_demographic_benefit(_rid);
    
    IF NOT FOUND THEN
        PERFORM raise_error('EXCEPTION', 'Record not found in granulainbound for UUID: ' || _rid);
    END IF;

    -- Check if visit number exists
    IF EXISTS (SELECT 1 FROM visit v WHERE v.nb = v_ben.visit_nb) THEN
	-- Insert visit benefit
	-- ON CONFLICT DO UPDATE is used to bypass a bug from Progress DB that generates duplicates
        INSERT INTO visit_benefit (code, visit_nb, internalnb, sequencenb, benefitdt, quantity, side, actingdpt, actingdptdesc, note, visamodifier, modifieddt, source, sourceid) 
			VALUES (v_ben.benefit_code, v_ben.visit_nb, v_ben.internalnb, v_ben.sequencenb, v_ben.benefitdt, v_ben.quantity, v_ben.benefit_side, v_ben.acting_department, 
				v_ben.acting_department_description, v_ben.note, v_ben.visa_last_modifier, v_ben.date_last_modified, _src, _rid)
        ON CONFLICT ON CONSTRAINT un_vis_ben_vis_int_seq 
	DO UPDATE SET code = v_ben.benefit_code, benefitdt = v_ben.benefitdt, quantity = v_ben.quantity, side = v_ben.benefit_side,
			actingdpt = v_ben.acting_department, actingdptdesc = v_ben.acting_department_description, note = v_ben.note,
			visamodifier = v_ben.visa_last_modifier, modifieddt = v_ben.date_last_modified, source = _src, sourceid = _rid
	RETURNING id INTO v_id;

        -- Insert visit benefit physicians
        PERFORM manage_visit_benefit_physician(v_id, _rid, _src);
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_ben.visit_nb);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION insert_visit_benefit(UUID, VARCHAR)
  OWNER TO fluance;
