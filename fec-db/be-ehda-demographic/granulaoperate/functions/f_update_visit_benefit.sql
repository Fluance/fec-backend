/*
	Function: update_visit_benefit

	This function's goal is to update a specific visit_benefit record in operate from inbound data.
	This function is called by Mirth in the channel P_DEMOGRAPHIC_EXP10_BENEFITS when a mutecode 02 is received in export10 message.

	Parameters:
		_rid - UUID row id of the HL7 messages in inbound database
		_src - source application name

	Returns:
		None

	See also:
		<visit_benefit>, <manage_visit_benefit_physician>, <fdw_demographic_benefit>
*/
CREATE OR REPLACE FUNCTION update_visit_benefit(_rid UUID, _src VARCHAR(50))
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
  
        SELECT id INTO v_id FROM visit_benefit vb WHERE vb.visit_nb = v_ben.visit_nb AND vb.internalnb = v_ben.internalnb AND vb.sequencenb = v_ben.sequencenb;

        IF NOT FOUND THEN
            PERFORM raise_error('EXCEPTION', 'Nonexistent BENEFIT WITH VISIT NUMBER ' || v_ben.visit_nb || ' INTERNAL NUMBER ' || v_ben.internalnb || ' SEQUENCE NUMBER ' || v_ben.sequencenb);
	ELSE
            -- Update visit benefit
            UPDATE visit_benefit vb SET code = v_ben.benefit_code, benefitdt = v_ben.benefitdt, quantity = v_ben.quantity, side = v_ben.benefit_side,
            		actingdpt = v_ben.acting_department, actingdptdesc = v_ben.acting_department_description, note = v_ben.note,
            		visamodifier = v_ben.visa_last_modifier, modifieddt = v_ben.date_last_modified, source = _src, sourceid = _rid
            WHERE vb.id = v_id;

            -- Manage visit benefit physician
            PERFORM manage_visit_benefit_physician(v_id, _rid, _src);
        END IF;
    ELSE
        PERFORM raise_error('EXCEPTION', 'Nonexistent VISIT NUMBER: ' || v_ben.visit_nb);
    END IF;

END;
$$ LANGUAGE plpgsql;

ALTER FUNCTION update_visit_benefit(UUID, VARCHAR)
  OWNER TO fluance;
